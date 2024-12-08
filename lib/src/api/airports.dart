import 'dart:convert';

import 'package:flutter/services.dart';

class Airport {
	final String name, municipality, iata;

	Airport(this.name, this.municipality, this.iata);

	@override
	String toString() {
		if (name.isEmpty && municipality.isEmpty) {
			return iata;
		}

		String location = name;
		if (name.isNotEmpty && municipality.isNotEmpty) {
			location += ', ';
		}
		location += municipality;
		return '$location ($iata)';
	}

	factory Airport.fromMap(Map<String, dynamic> entry) {
		return Airport(
			entry['name']!,
			entry['municipality']!,
			entry['iata_code']!
		);
	}
}

class AirportsInfo {
	static const _dataFile = 'assets/airports.json';

	static Future<List<Airport>> airports() async {
		final data = jsonDecode(await rootBundle.loadString(_dataFile));
		return data
			.cast<Map<String, dynamic>>()
			.map((entry) => Airport.fromMap(entry))
			.cast<Airport>()
			.toList();
	}
}