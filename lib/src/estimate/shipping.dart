import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';

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
		WidgetsBinding.instance.addPostFrameCallback((_) async{
			try {
				final shippingEstimate = await Broker.getShippingEstimate(
					weightValue: 200.0,
					distanceValue: 2000.0,
					transportMethod: 'truck'
				);
				setState(() => estimate = shippingEstimate);
			} catch (error) {
				setState(() => this.error = 'Error: $error');
			}
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
							//return Text('$estimate ${Storage.getSavedUnits()['carbon']}');
							return Text("why yes, i start a thread each time i need to get a string, how could you tell?");
						} else {
							return const CircularProgressIndicator();
						}
					},
				),
			),
		);
	}
}