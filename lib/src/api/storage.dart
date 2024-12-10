import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Option {
	final String code, label;
	Option(this.code, this.label);
	static DropdownMenuEntry<String> asDropdownMenuEntry(Option option) => DropdownMenuEntry(value: option.code, label: option.label);
}

class Storage {
	static String getCarbonUnit() {
		return 'kg';	// TODO: Read from memory
	}

	static Future<List<Option>> getAirports() async {
		return jsonDecode(await rootBundle.loadString('assets/airports.json'))
		.map((entry) {
			final name = entry['name']!, municipality = entry['municipality']!, iata = entry['iata_code']!;
			final label = '$name${name.isNotEmpty && municipality.isNotEmpty ? ', ' : ''}$municipality ($iata)';
			return Option(iata, label);
		})
		.cast<Option>()
		.toList();
	}

	static List<Option> getCountries() {
		return [
			['at', 'Austria'],
			['be', 'Belgium'],
			['bg', 'Bulgaria'],
			['ca', 'Canada'],
			['hr', 'Croatia'],
			['cy', 'Cyprus'],
			['cz', 'Czechia'],
			['dk', 'Denmark'],
			['ee', 'Estonia'],
			['fi', 'Finland'],
			['fr', 'France'],
			['de', 'Germany'],
			['gr', 'Greece'],
			['hu', 'Hungary'],
			['ie', 'Ireland'],
			['it', 'Italy'],
			['lv', 'Latvia'],
			['lt', 'Lithuania'],
			['lu', 'Luxembourg'],
			['mt', 'Malta'],
			['nl', 'Netherlands'],
			['pl', 'Poland'],
			['pt', 'Portugal'],
			['ro', 'Romania'],
			['sk', 'Slovakia'],
			['si', 'Slovenia'],
			['es', 'Spain'],
			['se', 'Sweden'],
			['us', 'United States of America'],
			['gb', 'United Kingdom']
		].map((entry) => Option(entry[0], entry[1])).toList();
	}

	static List<Option> getCabinClasses() {
		return ['Economy', 'Premium']
			.map((entry) => Option(entry.toLowerCase(), entry))
			.toList();
	}

	static List<Option> getTransportMethods() {
		return ['Ship', 'Train', 'Truck', 'Plane']
			.map((entry) => Option(entry.toLowerCase(), entry))
			.toList();
	}

	static List<Option> getElectricityUnits() {
		return ['MWh', 'kWh']
			.map((entry) => Option(entry.toLowerCase(), entry))
			.toList();
	}

	static List<Option> getDistanceUnits() {
		return ['mi', 'km']
			.map((entry) => Option(entry, entry))
			.toList();
	}

	static List<Option> getWeightUnits() {
		return ['g', 'lb', 'kg', 'mt']
			.map((entry) => Option(entry, entry != 'mt' ? entry : 't'))
			.toList();
	}
}