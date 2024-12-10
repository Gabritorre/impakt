import 'package:impakt/src/api/storage.dart';

import 'api.dart';

class Broker {
	static final Map<String, String> _vehicleManufacturers = {};

	static Future<Map<String, String>?> getVehicleManufacturers() async {
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

		String electricityUnit = 'mwh';	// TODO: Read from memory

		final Map<String, dynamic> body = {
			'type': type,
			'electricity_value': electricityValue,
			'country': country,
			if (electricityUnit != null) 'electricity_unit': electricityUnit,
		};

		final response = await Api.fetch(HttpMethod.post, '/estimates', body);
		final estimate = response['data']['attributes']['carbon_${Storage.getCarbonUnit()}'];
		return estimate.toString();
	}
}