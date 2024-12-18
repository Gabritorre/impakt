import 'package:flutter/material.dart';

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// SettingsController uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
	SettingsController(this._settingsService);

	final SettingsService _settingsService;
	late ThemeMode _themeMode;

	ThemeMode get themeMode => _themeMode; 		// Getter for the ThemeMode

	/// Load the user's settings from the SettingsService.
	Future<void> loadSettings() async {
		_themeMode = await _settingsService.themeMode();
		notifyListeners();		 // Inform listeners a change has occurred.
	}

	/// Update and persist the ThemeMode based on the user's selection.
	Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
		if (newThemeMode == null) return;
		if (newThemeMode == _themeMode) return;

		_themeMode = newThemeMode;
		notifyListeners();		// Inform listeners a change has occurred.

		// Makes the changes persistent
		await _settingsService.updateThemeMode(newThemeMode);
	}
}
