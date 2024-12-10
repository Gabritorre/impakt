import 'package:flutter/material.dart';
import 'package:impakt/src/api/api.dart';

import '../api/storage.dart';

class ShippingEstimationView extends StatefulWidget  {
	const ShippingEstimationView({super.key});
	static const routeName = '/shipping_estimation';
	
	@override
	State<ShippingEstimationView> createState() => _ShippingEstimationViewState();
}

class _ShippingEstimationViewState extends State<ShippingEstimationView> {
	String? estimate;
	String? error;
	

	// On first widget's render
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			Api.getShippingEstimate(
				weightUnit: 'g',
				weightValue: 200.0,
				distanceUnit: 'mi',
				distanceValue: 2000.0,
				transportMethod: 'truck'
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
				title: const Text('Shipping Estimation'),
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