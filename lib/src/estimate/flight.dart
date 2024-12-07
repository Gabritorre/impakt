import 'package:flutter/material.dart';

class FlightEstimationView extends StatelessWidget {
	const FlightEstimationView({super.key});

	static const routeName = '/flight_estimation';
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Flight Estimation'),
			),
			body: const Center(
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Text('Flight Estimation'),
					],
				),
			),
		);
	}
}