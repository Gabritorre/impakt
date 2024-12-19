import 'package:flutter/material.dart';

import 'settings_controller.dart';
import '../api/storage.dart';


/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
	const SettingsView({super.key, required this.controller});

	static const routeName = '/settings';

	final SettingsController controller;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Settings'),
			),
			body: Center(
				child: ListenableBuilder(
					listenable: controller,
					builder: (BuildContext context, Widget? child) {
						return Align(
							alignment: Alignment.topCenter,
							child: SingleChildScrollView(
								child: Column(
									children: [
										const SizedBox(height: 20),
										ThemeSelector(controller: controller),

										Padding(
											padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
											child: Divider(
												thickness: 2,
											),
										),

										const Text(
											'Unit of measurement',
											style: TextStyle(
												fontSize: 22,
												fontWeight: FontWeight.bold,
											),
										),

										const SizedBox(height: 20),

										UnitSelector(controller: controller, label: 'Electricity:', measureName: 'electricity'),
										const SizedBox(height: 20),
										UnitSelector(controller: controller, label: 'Distance:', measureName: 'distance'),
										const SizedBox(height: 20),
										UnitSelector(controller: controller, label: 'Weight:', measureName: 'weight'),
										const SizedBox(height: 20),
										UnitSelector(controller: controller, label: 'Carbon:', measureName: 'carbon'),
										Padding(
											padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20.0),
											child: Divider(
												thickness: 1,
											),
										),
										...Storage.getFuelSources().map((fuelSource) {
											return Padding(
												padding: const EdgeInsets.symmetric(vertical: 10.0),
												child: UnitSelector(
													controller: controller,
													label: fuelSource.label,
													measureName: 'fuel_${fuelSource.code}',
												),
											);
										}),

										const SizedBox(height: 40),
									],
								),
							),
						);
					},
				),
			),
		);
	}
}

class UnitSelector extends StatelessWidget {
	const UnitSelector({
		super.key,
		required this.controller,
		required this.label,
		required this.measureName,
	});

	final SettingsController controller;
	final String label;
	final String measureName;


	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 35),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Text(
						label,
						style: TextStyle(
							fontSize: 18,
							fontWeight: FontWeight.bold,
						),
					),
					DropdownButton(
						value: controller.units[measureName]!.code,
						onChanged: (String? newValue){
							controller.updateUnits({measureName: newValue!});
						},
						items: List.generate(
							Storage.getUnits()[measureName]!.length,
							(index) => DropdownMenuItem(
								value: Storage.getUnits()[measureName]![index].code,
								child: Text(
									Storage.getUnits()[measureName]![index].label,
									style: TextStyle(
										height: 1,
									),
								),
							),
						),
						dropdownColor: Theme.of(context).brightness == Brightness.dark
							? HSLColor.fromColor(Theme.of(context).primaryColor).withLightness(0.2).toColor()
							: HSLColor.fromColor(Theme.of(context).primaryColor).withLightness(1).toColor(),
						icon: Icon(
							Icons.arrow_drop_down,
							size: 32,
						),
						borderRadius: BorderRadius.circular(8),
					),
				],
			),
		);
	}
}

class ThemeSelector extends StatelessWidget {
	const ThemeSelector({
		super.key,
		required this.controller,
	});

	final SettingsController controller;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 35),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					const Text(
						'Theme:',
						style: TextStyle(
							fontSize: 18,
							fontWeight: FontWeight.bold,
						),
					),
					// When a user selects a theme from the dropdown list, the
					// SettingsController is updated, which rebuilds the MaterialApp.
					DropdownButton(
						value: controller.themeMode,	// Read the current theme from the controller
						onChanged: controller.updateThemeMode,
						items: const [
							DropdownMenuItem(
								value: ThemeMode.system,
								child: Row(
									children: [
										Icon(Icons.settings, color: Colors.blueAccent),
										SizedBox(width: 8),
										Text('System Theme'),
									],
								),
							),
							DropdownMenuItem(
								value: ThemeMode.light,
								child: Row(
									children: [
									Icon(Icons.wb_sunny, color: Colors.orangeAccent),
									SizedBox(width: 8),
									Text('Light Theme'),
									],
								),
							),
							DropdownMenuItem(
								value: ThemeMode.dark,
								child: Row(
									children: [
									Icon(Icons.nights_stay, color: Colors.purpleAccent),
									SizedBox(width: 8),
									Text('Dark Theme'),
									],
								),
							)
						],
						icon: Icon(
							Icons.arrow_drop_down,
							size: 32,
						),
						borderRadius: BorderRadius.circular(8),
					),
				],
			),
		);
	}
}
