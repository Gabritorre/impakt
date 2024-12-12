import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';
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
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			try {
				final fuelCombustionEstimate = await Broker.getFuelCombustionEstimate(
					fuelSourceType: 'dfo',
					fuelSourceValue: 42.0
				);
				setState(() => estimate = fuelCombustionEstimate);
			} catch (error) {
				setState(() => this.error = 'Error: $error');
			}
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
							//return Text('$estimate ${Storage.getSavedUnits()['carbon']}');
							return Text('please wait while i search for the punch card containing the string you asked for');
						} else {
							return const CircularProgressIndicator();
						}
					},
				),
			),
		);
	}
}