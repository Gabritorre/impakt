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
}