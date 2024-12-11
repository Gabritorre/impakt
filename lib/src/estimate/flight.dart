import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';

import '../api/storage.dart';

class FlightEstimationView extends StatefulWidget  {
	const FlightEstimationView({super.key});
	static const routeName = '/flight_estimation';
	
	@override
	State<FlightEstimationView> createState() => _FlightEstimationViewState();
}

class _FlightEstimationViewState extends State<FlightEstimationView> {
	String? estimate;
	String? error;
	

	// On first widget's render
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			try {
				final flightEstimate = await Broker.getFlightEstimate(
					passengers: 42,
					departureAirport: 'nce',
					destinationAirport: 'arn',
					cabinClass: 'economy'
				);
				setState(() => estimate = flightEstimate);
			} catch (error) {
				setState(() => this.error = 'Error: $error');
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Flight Estimation'),
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