import 'package:flutter/material.dart';

class FuelEstimationView extends StatelessWidget {
	const FuelEstimationView({super.key});

	static const routeName = '/fuel_estimation';
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Fuel combustion Estimation'),
			),
			body: const Center(
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Text('Fuel combustion Estimation'),
					],
				),
			),
		);
	}
}