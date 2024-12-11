import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';

import '../api/storage.dart';

class VehicleEstimationView extends StatefulWidget  {
	const VehicleEstimationView({super.key});
	static const routeName = '/vehicle_estimation';
	
	@override
	State<VehicleEstimationView> createState() => _VehicleEstimationViewState();
}

class _VehicleEstimationViewState extends State<VehicleEstimationView> {
	String? estimate;
	String? error;

	// On first widget's render
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			try {
				final vehicleEstimate = await Broker.getVehicleEstimate(
					distanceValue: 1000.0,
					veichleModelId: 'f46c68e5-4b0d-4136-a8cd-ed103cc202d1'
				);
				setState(() => estimate = vehicleEstimate);
			} catch (error) {
				setState(() => this.error = 'Error: $error');
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Vehicle Estimation'),
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