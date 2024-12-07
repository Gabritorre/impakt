import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:impakt/src/api/broker.dart';

class ElectricityEstimationView extends StatefulWidget  {
	const ElectricityEstimationView({super.key});
	static const routeName = '/electricity_estimation';
	
	@override
	ElectricityEstimationViewState createState() => ElectricityEstimationViewState();
}

class ElectricityEstimationViewState extends State<ElectricityEstimationView> {
	String responseJson = '';

	// On first widget's render
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			final broker = CarbonEstimateBroker();
			broker.fetchElectricityEstimates(
				country: 'us',
				state: 'fl',
				electricityUnit: 'mwh',
				electricityValue: 42.0
			).then((response) {
				setState(() {
					responseJson = jsonEncode(response);
				});
			}).catchError((error){
				setState(() {
				  responseJson = 'Error: $error';
				});
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Electricity Estimation'),
			),
			body: Center(
				child: Text(responseJson.isEmpty ? 'Loading...' : responseJson)
			),
		);
	}
}