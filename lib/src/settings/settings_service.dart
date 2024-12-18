import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package.
class SettingsService {
	/// Loads the User's preferred ThemeMode from local storage.
	Future<ThemeMode> themeMode() async {
		final preferences = await SharedPreferences.getInstance();
		final themeIndex = preferences.getInt('theme') ?? 0;
		return ThemeMode.values[themeIndex];
	}
	/// Persists the user's preferred ThemeMode to local storage.
	Future<void> updateThemeMode(ThemeMode theme) async {
		// Use the shared_preferences package to persist settings locally
		final preferences = await SharedPreferences.getInstance();
		await preferences.setInt('theme', theme.index);
	}
}
