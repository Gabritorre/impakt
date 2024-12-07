import 'package:flutter/material.dart';

class VehicleEstimationView extends StatelessWidget {
	const VehicleEstimationView({super.key});

	static const routeName = '/vehicle_estimation';
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Vehicle Estimation'),
			),
			body: const Center(
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Text('Vehicle Estimation'),
					],
				),
			),
		);
	}
}