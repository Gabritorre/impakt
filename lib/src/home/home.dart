import 'package:flutter/material.dart';

import '../estimate/electricity.dart';
import '../estimate/flight.dart';
import '../estimate/fuel_combustion.dart';
import '../estimate/shipping.dart';
import '../estimate/vehicle.dart';


class HomePage extends StatelessWidget {
	const HomePage({super.key});

	static const routeName = '/home';

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Home page'),
			),
			body: Center(
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children:[
						ElevatedButton(
							onPressed: () {
								Navigator.pushNamed(context, ElectricityEstimationView.routeName);
							},
							child: const Text('Electricity'),
						),
						ElevatedButton(
							onPressed: () {
								Navigator.pushNamed(context, FlightEstimationView.routeName);
							},
							child: const Text('Flight'),
						),
						ElevatedButton(
							onPressed: () {
								Navigator.pushNamed(context, FuelCombustionEstimationView.routeName);
							},
							child: const Text('Fuel combustion'),
						),
						ElevatedButton(
							onPressed: () {
								Navigator.pushNamed(context, ShippingEstimationView.routeName);
							},
							child: const Text('Shipping'),
						),
						ElevatedButton(
							onPressed: () {
								Navigator.pushNamed(context, VehicleEstimationView.routeName);
							},
							child: const Text('Vehicle'),
						),
					]
				)
			),
		);
	}
}

