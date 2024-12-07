import 'package:flutter/material.dart';

class ElectricityEstimationView extends StatelessWidget {
	const ElectricityEstimationView({super.key});

	static const routeName = '/electricity_estimation';
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Electricity Estimation'),
			),
			body: const Center(
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Text('Electricity Estimation'),
					],
				),
			),
		);
	}
}