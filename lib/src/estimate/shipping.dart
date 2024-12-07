import 'package:flutter/material.dart';

class ShippingEstimationView extends StatelessWidget {
	const ShippingEstimationView({super.key});

	static const routeName = '/shipping_estimation';
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Shipping Estimation'),
			),
			body: const Center(
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Text('Shipping Estimation'),
					],
				),
			),
		);
	}
}