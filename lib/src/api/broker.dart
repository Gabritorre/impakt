import 'package:impakt/src/api/storage.dart';

import 'api.dart';

class Broker {
	static final Map<String, String> _vehicleManufacturers = {};

	static Future<Map<String, String>> getVehicleManufacturers() async {
		if (_vehicleManufacturers.isEmpty) {
			final response = await Api.fetch(HttpMethod.get, '/vehicle_makes');
			for (final manufacturer in response) {
				final data = manufacturer['data'];
				_vehicleManufacturers[data['id']] = data['attributes']['name'];
			}
		}
		return _vehicleManufacturers;
	}

	static Future<dynamic> getVehicleModels(String manufacturer) async {
		return await Api.fetch(HttpMethod.get, '/vehicle_makes/$manufacturer/vehicle_models');
	}

	static Future<dynamic> getFuelSources() async {
		return await Api.fetch(HttpMethod.get, '/fuel_sources');
	}

	// --------------- Estimates ---------------

	static Future<String> getElectricityEstimate({
		required double electricityValue,
		required String country
	}) async {
		const type = 'electricity';
		final carbonUnit = Storage.getSavedUnits()['carbon'];
		final electricityUnit = Storage.getSavedUnits()['electricity'];

		final Map<String, dynamic> body = {
			'type': type,
			'electricity_value': electricityValue,
			'country': country,
			if (electricityUnit != null) 'electricity_unit': electricityUnit,
		};

		final response = await Api.fetch(HttpMethod.post, '/estimates', body);
		final estimate = response['data']['attributes']['carbon_$carbonUnit'];
		return estimate.toString();
	}

	static Future<String> getFlightEstimate({
		required int passengers,
		required String departureAirport,
		required String destinationAirport,
		String? cabinClass
	}) async {
		const type = 'flight';
		final carbonUnit = Storage.getSavedUnits()['carbon'];
		final distanceUnit = Storage.getSavedUnits()['distance'];

		final Map<String, dynamic> body = {
			'type': type,
			'passengers': passengers,
			'legs': [
				{
					'departure_airport': departureAirport,
					'destination_airport': destinationAirport,
					if (cabinClass != null) 'cabin_class': cabinClass,
				}
			],
			if (distanceUnit != null) 'distance_unit': distanceUnit
		};

		final response = await Api.fetch(HttpMethod.post, '/estimates', body);
		final estimate = response['data']['attributes']['carbon_$carbonUnit'];
		return estimate.toString();
	}

	static Future<String> getShippingEstimate({
		required double weightValue,
		required double distanceValue,
		required String transportMethod
	}) async {
		const type = 'shipping';
		final carbonUnit = Storage.getSavedUnits()['carbon'];
		final weightUnit = Storage.getSavedUnits()['weight'];
		final distanceUnit = Storage.getSavedUnits()['distance'];

		final Map<String, dynamic> body = {
			'type': type,
			'weight_unit': weightUnit,
			'weight_value': weightValue,
			'distance_unit': distanceUnit,
			'distance_value': distanceValue,
			'transport_method': transportMethod
		};

		final response = await Api.fetch(HttpMethod.post, '/estimates', body);
		final estimate = response['data']['attributes']['carbon_$carbonUnit'];
		return estimate.toString();
	}

	static Future<dynamic> getVehicleEstimate({
		required double distanceValue,
		required String veichleModelId
	}) async {
		const type = 'vehicle';
		final carbonUnit = Storage.getSavedUnits()['carbon'];
		final distanceUnit = Storage.getSavedUnits()['distance'];

		final Map<String, dynamic> body = {
			'type': type,
			'distance_unit': distanceUnit,
			'distance_value': distanceValue,
			'vehicle_model_id': veichleModelId
		};

		final response = await Api.fetch(HttpMethod.post, '/estimates', body);
		final estimate = response['data']['attributes']['carbon_$carbonUnit'];
		return estimate.toString();
	}

	static Future<dynamic> getFuelCombustionEstimate({
		required String fuelSourceType,
		required double fuelSourceValue
	}) async {
		const type = 'fuel_combustion';
		final carbonUnit = Storage.getSavedUnits()['carbon'];
		final fuelSourceUnit = Storage.getSavedUnits()['fuel_source'];

		final Map<String, dynamic> body = {
			'type': type,
			'fuel_source_type': fuelSourceType,
			'fuel_source_unit': fuelSourceUnit,
			'fuel_source_value': fuelSourceValue
		};

		final response = await Api.fetch(HttpMethod.post, '/estimates', body);
		final estimate = response['data']['attributes']['carbon_$carbonUnit'];
		return estimate.toString();
	}
}