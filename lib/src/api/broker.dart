import 'package:impakt/src/api/storage.dart';

import 'api.dart';

class Broker {
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