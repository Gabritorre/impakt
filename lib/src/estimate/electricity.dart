import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';

class ElectricityEstimationView extends StatefulWidget  {
	const ElectricityEstimationView({super.key});
	static const routeName = '/electricity_estimation';
	
	@override
	State<ElectricityEstimationView> createState() => _ElectricityEstimationViewState();
}

class _ElectricityEstimationViewState extends State<ElectricityEstimationView> {
	String? estimate;
	String? error;
	String carbonUnit = 'kg';
	

	// On first widget's render
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			final broker = CarbonEstimateBroker();
			broker.fetchElectricityEstimates(
				electricityValue: 42.0,
				country: 'us',
				electricityUnit: 'mwh',
				state: 'fl',
			).then((response) {
				setState(() {
					String measure = 'carbon_$carbonUnit';
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
				title: const Text('Electricity Estimation'),
			),
			body: Center(
				child: Builder(
					builder: (context) {
						if (error != null) {
							return Text(error!);
						} else if (estimate != null) {
							return Text('$estimate $carbonUnit');
						} else {
							return const CircularProgressIndicator();
						}
					},
				),
			),
		);
	}
}