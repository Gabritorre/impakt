import 'package:flutter/material.dart';

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
	int currentViewIndex = 0;

	List<Widget> pages = [];

	@override
	void initState() {
		super.initState();
		pages = [
			const HomePage(),
			const SampleItemListView(),
			SettingsView(controller: widget.settingsController),
		];
	}

	void _onItemTapped(int index) {
		setState(() {
			currentViewIndex = index;
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: IndexedStack(
				index: currentViewIndex,
				children: pages,
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
				currentIndex: currentViewIndex,
				selectedItemColor: Colors.amber[800],
				onTap: _onItemTapped,
			),
		);
	}
}
