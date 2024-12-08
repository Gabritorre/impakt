import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';

class FuelCombustionEstimationView extends StatefulWidget  {
	const FuelCombustionEstimationView({super.key});
	static const routeName = '/fuel_estimation';
	
	@override
	State<FuelCombustionEstimationView> createState() => _FuelCombustionEstimationViewState();
}

class _FuelCombustionEstimationViewState extends State<FuelCombustionEstimationView> {
	String? estimate;
	String? error;
	String carbonUnit = 'kg';
	

	// On first widget's render
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			final broker = CarbonEstimateBroker();
			broker.fetchFuelCombustionEstimates(
				fuelSourceType: 'dfo',
				fuelSourceUnit: 'btu',
				fuelSourceValue: 42.0,
			).then((response) {
				setState(() {
					String measure = 'carbon_$carbonUnit';
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
							return Text('$estimate $carbonUnit');
						} else {
							return const CircularProgressIndicator();
						}
					},
				),
			),
		);
	}
}