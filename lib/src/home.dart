import 'package:flutter/material.dart';

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
								Navigator.pushNamed(context, '/');
							},
							child: const Text('Electricity'),
						),
						ElevatedButton(
							onPressed: () {
								Navigator.pushNamed(context, '/');
							},
							child: const Text('Flight'),
						),
						ElevatedButton(
							onPressed: () {
								Navigator.pushNamed(context, '/');
							},
							child: const Text('Fuel combustion'),
						),
						ElevatedButton(
							onPressed: () {
								Navigator.pushNamed(context, '/');
							},
							child: const Text('Shipping'),
						),
						ElevatedButton(
							onPressed: () {
								Navigator.pushNamed(context, '/');
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
							Navigator.pushNamed(context, '/');
							break;
						case 1:
							Navigator.pushNamed(context, '/estimation_list');
							break;
						case 2:
							Navigator.pushNamed(context, '/settings');
							break;
						default:
							Navigator.pushNamed(context, '/');
					}
				},
			),
		);
	}
}