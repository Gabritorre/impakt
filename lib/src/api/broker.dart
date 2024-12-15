import 'package:impakt/src/api/storage.dart';

import 'api.dart';

class Broker {
	static final List<Choice> _vehicleManufacturers = [];

	static Future<List<Choice>> getVehicleManufacturers() async {
		if (_vehicleManufacturers.isEmpty) {
			final response = await Api.fetch(HttpMethod.get, '/vehicle_makes');
			for (final manufacturer in response) {
				final data = manufacturer['data'];
				_vehicleManufacturers.add(Choice(data['id'], data['attributes']['name']));
			}
		}
		return _vehicleManufacturers;
	}

	static Future<List<Choice>> getVehicleModels(String manufacturer) async {
		final response = await Api.fetch(HttpMethod.get, '/vehicle_makes/$manufacturer/vehicle_models');
		Set<String> labels = {};
		List<Choice> options = [];
		for (final model in response) {
			final data = model['data'];
			final attributes = data['attributes'];
			final option = Choice(data['id'], '${attributes['name']} (${attributes['year']})');
			if (!labels.contains(option.label)) {
				options.add(option);
				labels.add(option.label);
			}
		}
		return options;
	}

	// --------------- Estimates ---------------

	static Future<String> getElectricityEstimate({
		required double electricityValue,
		required String country
	}) async {
		const type = 'electricity';
		final units = await Storage.getSavedUnits();
		final carbonUnit = units['carbon']!.code;
		final electricityUnit = units['electricity']!.code;

		final Map<String, dynamic> body = {
			'type': type,
			'electricity_value': electricityValue,
			'country': country,
			'electricity_unit': electricityUnit,
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
		final units = await Storage.getSavedUnits();
		final carbonUnit = units['carbon']!.code;
		final distanceUnit = units['distance']!.code;

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
			'distance_unit': distanceUnit
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
		final units = await Storage.getSavedUnits();
		final carbonUnit = units['carbon']!.code;
		final weightUnit = units['weight']!.code;
		final distanceUnit = units['distance']!.code;

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

	static Future<String> getVehicleEstimate({
		required double distanceValue,
		required String veichleModelId
	}) async {
		const type = 'vehicle';
		final units = await Storage.getSavedUnits();
		final carbonUnit = units['carbon']!.code;
		final distanceUnit = units['distance']!.code;

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

	static Future<String> getFuelCombustionEstimate({
		required String fuelSourceType,
		required double fuelSourceValue
	}) async {
		const type = 'fuel_combustion';
		final units = await Storage.getSavedUnits();
		final carbonUnit = units['carbon']!.code;
		final fuelSourceUnit = units['fuel_$fuelSourceType']!.code;

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