import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';

class Storage {
	static Future<Map<String, Choice>> getSavedUnits() async {
		final preferences = await SharedPreferences.getInstance();
		if (!preferences.containsKey('units')) {
			return getUnits()
				.map((measure, units) => MapEntry(measure, units[0]));
		}
		return Map.from(jsonDecode(preferences.getString('units')!))
			.map((measure, unit) => MapEntry(measure,
				getUnits()[measure]!.firstWhere((choice) => choice.code == unit)
			));
	}

	static Future<void> setSavedUnits(Map<String, String> units) async {
		final saved = (await getSavedUnits())
			.map((measure, unit) => MapEntry(measure, unit.code));
		saved.addAll(units);
		await (await SharedPreferences.getInstance())
			.setString('units', jsonEncode(saved));
	}

	static Map<String, String> getInfos() {
		return {
			'electricity': 'The electricity estimate allows users to obtain an emissions estimate based on a country and the watt hours of consumption. The calculation of the emissions estimate selects the emission factor for the geographic region and multiplies that with the number of units consumed.',
			'flight': 'The flights estimate allows users to obtain an emissions estimate based on flights between airports and the number of passengers. The calculation of the emissions estimate is based on a methodology similar to the one developed by the ICAO.',
			'fuel_combustion': 'The fuel combustion estimate allows users to estimate the C02 emissions from the combustion of a certain quantity of specified fuel. Simply provide the fuel type and the fuel quantity and it will return the amount of C02 emitted from its combustion.',
			'shipping': 'The shipping estimate allows users to estimate the C02 emissions from shipping freight given a method of transportation. Simply provide the weight and distance of the package and the method of transportation and it will return the resulting C02 from that shipment.',
			'vehicles': 'The vehicles estimate allows users to estimate the C02 emissions from a vehicle travelling a specified distance. Simply provide the vehicle model and the distance it is travelling and it will return the amount of C02 emitted from the trip.'
		};
	}

	static Future<List<Choice>> getAirports() async {
		return (jsonDecode(await rootBundle.loadString('assets/airports.json')) as List<dynamic>)
			.map((entry) {
				final name = entry['name']!, municipality = entry['municipality']!, iata = entry['iata_code']!;
				final label = '$name${name.isNotEmpty && municipality.isNotEmpty ? ', ' : ''}$municipality ($iata)';
				return Choice(iata, label);
			})
			.cast<Choice>()
			.toList();
	}

	static List<List<dynamic>> _getFuelSourcesInfo() {
		return [
			['bit', 'Bituminous Coal', ['BTU', 'Short Ton']],
			['dfo', 'Home Heating and\nDiesel Fuel (Distillate)', ['BTU', 'Gallon']],
			['jf', 'Jet Fuel', ['BTU', 'Gallon']],
			['ker', 'Kerosene', ['BTU', 'Gallon']],
			['lig', 'Lignite Coal', ['BTU', 'Short Ton']],
			['msw', 'Municipal Solid\nWaste', ['BTU', 'Short Ton']],
			['ng', 'Natural Gas', ['BTU', 'Thousand\n Cubic Feet']],
			['pc', 'Petroleum Coke', ['BTU', 'Gallon']],
			['pg', 'Propane Gas', ['BTU', 'Gallon']],
			['rfo', 'Residual Fuel Oil', ['BTU', 'Gallon']],
			['sub', 'Subbituminous\nCoal', ['BTU', 'Short Ton']],
			['tdf', 'Tire-Derived Fuel', ['BTU', 'Short Ton']],
			['wo', 'Waste Oil', ['BTU', 'Barrel']]
		];
	}

	static List<Choice> getFuelSources() {
		return _getFuelSourcesInfo()
			.map((entry) => Choice(entry[0], entry[1]))
			.toList();
	}

	static Map<String, List<Choice>> getUnits() {
		return {
			...{
				'electricity': ['kWh', 'MWh'],
				'distance': ['km', 'mi'],
				'weight': ['kg', 'g', 'lb', 'mt'],
				'carbon': ['kg', 'g', 'lb', 'mt']
			}.map((measure, units) => MapEntry(measure, units
				.map((unit) => Choice(unit.toLowerCase(), unit))
				.toList()
			)),

			for (final source in _getFuelSourcesInfo())
				'fuel_${source[0]}': (source[2] as List<String>)
					.map((unit) => Choice(unit.toLowerCase().replaceAll(' ', '_'), unit))
					.toList(),
		};
	}

	static List<Choice> getCountries() {
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
		].map((entry) => Choice(entry[0], entry[1])).toList();
	}

	static List<Choice> getCabinClasses() {
		return ['Economy', 'Premium']
			.map((entry) => Choice(entry.toLowerCase(), entry))
			.toList();
	}

	static List<Choice> getTransportMethods() {
		return ['Ship', 'Train', 'Truck', 'Plane']
			.map((entry) => Choice(entry.toLowerCase(), entry))
			.toList();
	}
}