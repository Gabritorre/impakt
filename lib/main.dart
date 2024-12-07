import 'package:flutter/material.dart';

import 'src/home.dart';

import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/settings/settings_view.dart';

import 'src/info/estimation_item_details_view.dart';
import 'src/info/estimation_item_list_view.dart';

void main() async {
	// Set up the SettingsController, which will glue user settings to multiple
	// Flutter Widgets.
	final settingsController = SettingsController(SettingsService());

	// Load the user's preferred theme while the splash screen is displayed.
	// This prevents a sudden theme change when the app is first displayed.
	await settingsController.loadSettings();

	// Run the app and pass in the SettingsController. The app listens to the
	// SettingsController for changes, then passes it further down to the
	// SettingsView.
	runApp(MyApp(settingsController: settingsController));
}

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
	const MyApp({
		super.key,
		required this.settingsController,
	});

	final SettingsController settingsController;

	@override
	Widget build(BuildContext context) {
		// Glue the SettingsController to the MaterialApp.
		//
		// The ListenableBuilder Widget listens to the SettingsController for changes.
		// Whenever the user updates their settings, the MaterialApp is rebuilt.
		return ListenableBuilder(
			listenable: settingsController,
			builder: (BuildContext context, Widget? child) {
				return MaterialApp(
					// the title of the application
					title: 'impakt',

					// Define a light and dark color theme. Then, read the user's
					// preferred ThemeMode (light, dark, or system default) from the
					// SettingsController to display the correct theme.
					theme: ThemeData(),
					darkTheme: ThemeData.dark(),
					themeMode: settingsController.themeMode,

					// Sets the routes for the application
					initialRoute: HomePage.routeName,
					routes: {
						HomePage.routeName: (context) => const HomePage(),
						SampleItemListView.routeName: (context) => const SampleItemListView(),
						SettingsView.routeName: (context) => SettingsView(controller: settingsController),
						SampleItemDetailsView.routeName: (context) => const SampleItemDetailsView(),
					},
				);
			},
		);
	}
}
