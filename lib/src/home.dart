import 'package:flutter/material.dart';

import 'estimate/electricity.dart';
import 'estimate/flight.dart';
import 'estimate/fuel_combustion.dart';
import 'estimate/shipping.dart';
import 'estimate/vehicle.dart';

import 'info/estimation_item_list_view.dart';

import 'settings/settings_view.dart';

class HomePage extends StatelessWidget {
	const HomePage({super.key});

	static const routeName = '/';

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
								Navigator.pushNamed(context, FuelEstimationView.routeName);
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
			bottomNavigationBar: BottomNavigationBar(
				items: const <BottomNavigationBarItem>[
					BottomNavigationBarItem(
						icon: Icon(Icons.home),
						label: 'Home',
					),
					BottomNavigationBarItem(
						icon: Icon(Icons.info),
						label: 'Info',
					),
					BottomNavigationBarItem(
						icon: Icon(Icons.settings),
						label: 'Settings',
					),
				],
				selectedItemColor: Colors.amber[800],
				onTap: (int index) {
					switch(index){
						case 0:
							if (ModalRoute.of(context)!.settings.name != HomePage.routeName){
								Navigator.pushNamed(context, HomePage.routeName);
							}
							break;
						case 1:
							if (ModalRoute.of(context)!.settings.name != SampleItemListView.routeName){
								Navigator.pushNamed(context, SampleItemListView.routeName);
							}
							break;
						case 2:
							if (ModalRoute.of(context)!.settings.name != SettingsView.routeName){
								Navigator.pushNamed(context, SettingsView.routeName);
							}
							break;
						default:
							Navigator.pushNamed(context, HomePage.routeName);
					}
				},
			),
		);
	}
}