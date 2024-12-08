import 'package:flutter/material.dart';

import 'estimate/electricity.dart';
import 'estimate/flight.dart';
import 'estimate/fuel_combustion.dart';
import 'estimate/shipping.dart';
import 'estimate/vehicle.dart';

import 'info/estimation_item_details_view.dart';
import 'info/estimation_item_list_view.dart';
import 'home/home.dart';
import 'settings/settings_view.dart';
import 'settings/settings_controller.dart';


class MainView extends StatefulWidget {
	const MainView({super.key, required this.settingsController});

	final SettingsController settingsController;
	static const routeName = '/';

	@override
	State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
	int currentIndex = 0;

	// List of GlobalKeys to manage the state of each Navigator.
	final List<GlobalKey<NavigatorState>> _navigatorKeys = [
		GlobalKey<NavigatorState>(),
		GlobalKey<NavigatorState>(),
		GlobalKey<NavigatorState>(),
	];

	void _onItemTapped(int index) {
		// If the tapped item is the current item, pop until the last page is reached
		if (index == currentIndex) {
			_navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
		}
		// Otherwise, only go on the last visited page of that item
		else {
			setState(() {
				currentIndex = index;
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: IndexedStack(
				index: currentIndex,
				children: <Widget>[
					_buildNavigatorFor(_navigatorKeys[0], HomePage.routeName),
					_buildNavigatorFor(_navigatorKeys[1], EstimationListView.routeName),
					_buildNavigatorFor(_navigatorKeys[2], SettingsView.routeName),
				],
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
				currentIndex: currentIndex,
				selectedItemColor: Colors.amber[800],
				onTap: _onItemTapped,
			),
		);
	}

	Widget _buildNavigatorFor(GlobalKey<NavigatorState> navigatorKey, String initialRoute) {
		return Navigator(
			key: navigatorKey,
			initialRoute: initialRoute,
			onGenerateRoute: (RouteSettings settings) {
				Widget page;
				switch (settings.name) {
					case HomePage.routeName:
						page = const HomePage();
						break;
					case EstimationListView.routeName:
						page = const EstimationListView();
						break;
					case SettingsView.routeName:
						page = SettingsView(controller: widget.settingsController);
						break;

					// internal path on /home
					case ElectricityEstimationView.routeName:
						page = const ElectricityEstimationView();
						break;
					case FlightEstimationView.routeName:
						page = const FlightEstimationView();
						break;
					case FuelCombustionEstimationView.routeName:
						page = const FuelCombustionEstimationView();
						break;
					case ShippingEstimationView.routeName:
						page = const ShippingEstimationView();
						break;
					case VehicleEstimationView.routeName:
						page = const VehicleEstimationView();
						break;

					// internal path on /estimation_list
					case EstimationItemDetailsView.routeName:
						page = const EstimationItemDetailsView();
						break;
					default:
						return null;
				}
				return MaterialPageRoute(builder: (context) => page);
			},
		);
	}
}
