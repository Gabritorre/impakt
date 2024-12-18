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
										Padding(
											padding: const EdgeInsets.symmetric(horizontal: 40),
											child: ThemeAppWidget(controller: controller),
										),

										Padding(
											padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
											child: Divider(
												thickness: 2,
											),
										),

										const Text(
											'Unit of measurement:',
											style: TextStyle(
												fontSize: 20,
												fontWeight: FontWeight.bold,
											),
										),

										const SizedBox(height: 20),

										Padding(
											padding: const EdgeInsets.symmetric(horizontal: 40),
											child: Row(
												mainAxisAlignment: MainAxisAlignment.spaceBetween,
												children: [
													const Text(
														'Electricity:',
														style: TextStyle(
															fontSize: 18,
															fontWeight: FontWeight.bold,
														),
													),
													DropdownButton(
														value: controller.units['electricity']!.code,
														onChanged: (String? newValue){
															controller.updateUnits({'electricity': newValue!});
														},
														items: List.generate(
															Storage.getUnits()['electricity']!.length,
															(index) => DropdownMenuItem(
																value: Storage.getUnits()['electricity']![index].code,
																child: Text(Storage.getUnits()['electricity']![index].label),
															),
														),

														icon: Icon(
															Icons.arrow_drop_down,
															size: 32,
														),
														borderRadius: BorderRadius.circular(8),
													),
												],
											),
										),
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

class ThemeAppWidget extends StatelessWidget {
	const ThemeAppWidget({
		super.key,
		required this.controller,
	});

	final SettingsController controller;

	@override
	Widget build(BuildContext context) {
		return Row(
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
		);
	}
}
