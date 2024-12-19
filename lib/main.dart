import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:impakt/src/api/broker.dart';
import 'src/navigation_page.dart';

import 'src/settings/settings_controller.dart';

void main() async {
	await dotenv.load(fileName: 'assets/.env');
	Broker.getVehicleManufacturers();	// Asynchronously fill the list of vehicle manufacturers

	// Set up the SettingsController, which will glue user settings to multipleFlutter Widgets.
	final settingsController = SettingsController();

	// Load the user's preferred theme while the splash screen is displayed.
	// This prevents a sudden theme change when the app is first displayed.
	await settingsController.loadSettings();

	SystemChrome.setPreferredOrientations([
		DeviceOrientation.portraitUp,
	]);

	// Run the app and pass in the SettingsController. The app listens to the
	// SettingsController for changes, then passes it further down to the SettingsView.
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
		// The ListenableBuilder Widget listens to the SettingsController for changes.
		// Whenever the user updates their settings, the MaterialApp is rebuilt.
		return ListenableBuilder(
			listenable: settingsController,
			builder: (BuildContext context, Widget? child) {
				return MaterialApp(
					title: 'impakt',

					debugShowCheckedModeBanner: false,
					// Define a light and dark color theme.
					theme: ThemeData(),
					darkTheme: ThemeData.dark(),
					
					// Then, read the user's preferred ThemeMode (light, dark, or system default) from the
					// SettingsController to display the correct theme.
					themeMode: settingsController.themeMode,

					home: MainView(settingsController: settingsController),
				);
			},
		);
	}
}
