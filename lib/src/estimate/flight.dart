import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';

class FlightEstimationView extends StatefulWidget  {
	const FlightEstimationView({super.key});
	static const routeName = '/flight_estimation';
	
	@override
	State<FlightEstimationView> createState() => _FlightEstimationViewState();
}

class _FlightEstimationViewState extends State<FlightEstimationView> {
	String? estimate;
	String? error;
	String carbonUnit = 'kg';
	

	// On first widget's render
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			final broker = CarbonEstimateBroker();
			broker.fetchFlightEstimates(
				passengers: 42,
				departureAirport: 'nce',
				destinationAirport: 'arn',
				distanceUnit: 'km',
				cabinClass: 'economy'
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
				title: const Text('Flight Estimation'),
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