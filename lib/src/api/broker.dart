import 'dart:convert';
import 'package:http/http.dart' as http;

class CarbonEstimateBroker {
	static const String apiKey = '';
	final Uri url;

	final Map<String, String> headers = {
		'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
    };

	CarbonEstimateBroker() : url = Uri.parse('https://www.carboninterface.com/api/v1/estimates');

	Future<Map<String, dynamic>> _fetch(Map<String, dynamic> body) async {
		try {
			final http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));

			// Accept only strings in the format of "2xx" (successful responses)
			if (RegExp(r'^2\d{2}$').hasMatch(response.statusCode.toString())) {
				return jsonDecode(response.body);
			} else {
				throw Exception('Response gave: ${response.statusCode} status code: ${response.body}\n');
			}
		} catch (e) {
			throw Exception('Error while making POST request: $e\n');
		}
	}

	Future<Map<String, dynamic>> fetchElectricityEstimates({
		required double electricityValue,
		required String country,
		String? electricityUnit,
		String? state
	}) async {
		const type = 'electricity';

    	final Map<String, dynamic> body = {
			'type': type,
			'electricity_value': electricityValue,
			'country': country,
			if (electricityUnit != null) 'electricity_unit': electricityUnit,
			'state': state,
    	};

		return _fetch(body);
	}

	Future<Map<String, dynamic>> fetchFlightEstimates({
		required int passengers,
		required String departureAirport,
		required String destinationAirport,
		String? distanceUnit,
		String? cabinClass
	}) async {
		const type = 'flight';

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

		return _fetch(body);
	}

	Future<Map<String, dynamic>> fetchShippingEstimates({
		required String weightUnit,
		required double weightValue,
		required String distanceUnit,
		required double distanceValue,
		required String transportMethod
	}) async {
		const type = 'shipping';

    	final Map<String, dynamic> body = {
			'type': type,
			'weight_unit': weightUnit,
			'weight_value': weightValue,
			'distance_unit': distanceUnit,
			'distance_value': distanceValue,
			'transport_method': transportMethod
    	};

		return _fetch(body);
	}

	Future<Map<String, dynamic>> fetchVehicleEstimates({
		required String distanceUnit,
		required double distanceValue,
		required String veichleModelId
	}) async {
		const type = 'vehicle';

    	final Map<String, dynamic> body = {
			'type': type,
			'distance_unit': distanceUnit,
			'distance_value': distanceValue,
			'vehicle_model_id': veichleModelId
    	};

		return _fetch(body);
	}

	Future<Map<String, dynamic>> fetchFuelCombustionEstimates({
		required String fuelSourceType,
		required String fuelSourceUnit,
		required double fuelSourceValue
	}) async {
		const type = 'fuel_combustion';

    	final Map<String, dynamic> body = {
			'type': type,
			'fuel_source_type': fuelSourceType,
			'fuel_source_unit': fuelSourceUnit,
			'fuel_source_value': fuelSourceValue
    	};

		return _fetch(body);
	}
}