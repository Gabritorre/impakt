import 'package:flutter/material.dart';
import 'package:impakt/src/api/api.dart';
import 'package:impakt/src/api/storage.dart';

class FuelCombustionEstimationView extends StatefulWidget  {
	const FuelCombustionEstimationView({super.key});
	static const routeName = '/fuel_estimation';
	
	@override
	State<FuelCombustionEstimationView> createState() => _FuelCombustionEstimationViewState();
}

class _FuelCombustionEstimationViewState extends State<FuelCombustionEstimationView> {
	String? estimate;
	String? error;
	

	// On first widget's render
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			Api.getFuelCombustionEstimate(
				fuelSourceType: 'dfo',
				fuelSourceUnit: 'btu',
				fuelSourceValue: 42.0,
			).then((response) {
				setState(() {
					String measure = 'carbon_${Storage.getSavedUnits()['carbon']}';
					estimate = response['data']['attributes'][measure].toString();
				});
			}).catchError((error){
				setState(() {
					this.error = 'Error: $error';
				});
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('FuelCombustion Estimation'),
			),
			body: Center(
				child: Builder(
					builder: (context) {
						if (error != null) {
							return Text(error!);
						} else if (estimate != null) {
							return Text('$estimate ${Storage.getSavedUnits()['carbon']}');
						} else {
							return const CircularProgressIndicator();
						}
					},
				),
			),
		);
	}
}