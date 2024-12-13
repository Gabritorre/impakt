import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';

class Storage {
	static Future<Map<String, String>> getSavedUnits() async {
		final preferences = await SharedPreferences.getInstance();
		if (!preferences.containsKey('units')) {
			return {
				'electricity': 'kwh',
				'distance': 'km',
				'weight': 'kg',
				'fuel_source': 'btu',
				'carbon': 'kg'
			};
		}
		return Map.from(jsonDecode(preferences.getString('units')!));
	}

	static Future<void> setSavedUnits(Map<String, String> units) async {
		final saved = await getSavedUnits();
		saved.addAll(units);
		await (await SharedPreferences.getInstance()).setString('units', jsonEncode(saved));
	}

	static Map<String, Map<String, String>> getInfos() {
		return {
			'electricity': {
				'title': 'Electricity',
				'description': 'The electricity estimate allows users to obtain an emissions estimate based on a country and the watt hours of consumption. The calculation of the emissions estimate selects the emission factor for the geographic region and multiplies that with the number of units consumed.'
			},
			'flight': {
				'title': 'Flight',
				'description': 'The flights estimate allows users to obtain an emissions estimate based on flights between airports and the number of passengers. The calculation of the emissions estimate is based on a methodology similar to the one developed by the ICAO.'
			},
			'fuel_combustion': {
				'title': 'Fuel combustion',
				'description': 'The fuel combustion estimate allows users to estimate the C02 emissions from the combustion of a certain quantity of specified fuel. Simply provide the fuel type and the fuel quantity and it will return the amount of C02 emitted from its combustion.'
			},
			'shipping': {
				'title': 'Shipping',
				'description': 'The shipping estimate allows users to estimate the C02 emissions from shipping freight given a method of transportation. Simply provide the weight and distance of the package and the method of transportation and it will return the resulting C02 from that shipment.'
			},
			'vehicles': {
				'title': 'Vehicles',
				'description': 'The vehicles estimate allows users to estimate the C02 emissions from a vehicle travelling a specified distance. Simply provide the vehicle model and the distance it is travelling and it will return the amount of C02 emitted from the trip.'
			}
		};
	}

	static Future<List<Option>> getAirports() async {
		return (jsonDecode(await rootBundle.loadString('assets/airports.json')) as List<dynamic>)
			.map((entry) {
				final name = entry['name']!, municipality = entry['municipality']!, iata = entry['iata_code']!;
				final label = '$name${name.isNotEmpty && municipality.isNotEmpty ? ', ' : ''}$municipality ($iata)';
				return Option(iata, label);
			})
			.cast<Option>()
			.toList();
	}

	static Map<String, Map<String, dynamic>> getFuelSources() {
		return {
			'bit': {
				'label': 'Bituminous Coal',
				'units': ['Short Ton', 'BTU']
			},
			'dfo': {
				'label': 'Home Heating and Diesel Fuel (Distillate)',
				'units': ['Gallon', 'BTU']
			},
			'jf': {
				'label': 'Jet Fuel',
				'units': ['Gallon', 'BTU']
			},
			'ker': {
				'label': 'Kerosene',
				'units': ['Gallon', 'BTU']
			},
			'lig': {
				'label': 'Lignite Coal',
				'units': ['Short Ton', 'BTU']
			},
			'msw': {
				'label': 'Municipal Solid Waste',
				'units': ['Short Ton', 'BTU']
			},
			'ng': {
				'label': 'Natural Gas',
				'units': ['Thousand Cubic Feet', 'BTU']
			},
			'pc': {
				'label': 'Petroleum Coke',
				'units': ['Gallon', 'BTU']
			},
			'pg': {
				'label': 'Propane Gas',
				'units': ['Gallon', 'BTU']
			},
			'rfo': {
				'label': 'Residual Fuel Oil',
				'units': ['Gallon', 'BTU']
			},
			'sub': {
				'label': 'Subbituminous Coal',
				'units': ['Short Ton', 'BTU']
			},
			'tdf': {
				'label': 'Tire-Derived Fuel',
				'units': ['Short Ton', 'BTU']
			},
			'wo': {
				'label': 'Waste Oil',
				'units': ['Barrel', 'BTU']
			}
		};
	}

	static List<Option> getFuelSourcesLabels() {
		return getFuelSources()
			.entries.map((entry) => Option(entry.key, entry.value['label']))
			.toList();
	}

	static List<Option> getFuelSourcesUnits(String code) {
		return (getFuelSources()[code]!['units'] as List<String>)
			.map((unit) => Option(unit.toLowerCase().replaceAll(' ', '_'), unit))
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