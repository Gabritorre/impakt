import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum HttpMethod {get, post}

class Api {
	static final String _apiKey = dotenv.env['API_KEY']!;
	static const String _baseUrl = 'https://www.carboninterface.com/api/v1';
	
	final Map<String, String> _headers = {
		'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
    };

	Future<Map<String, dynamic>> _fetch(HttpMethod method, Uri url, Map<String, dynamic>? body) async {
		final http.Response response;
		
		try {

			if (method == HttpMethod.get) {
				response = await http.get(url, headers: _headers);
			} else if (method == HttpMethod.post && body != null) {
				response = await http.post(url, headers: _headers, body: jsonEncode(body));
			} else {
				throw Exception('Invalid HTTP call for method: "$method" with body: "$body"');
			}

			// Accept only strings in the format of "2xx" (successful responses)
			if (RegExp(r'^2\d{2}$').hasMatch(response.statusCode.toString())) {
				return jsonDecode(response.body);
			} else {
				throw Exception('$url\n');
			}

		} catch (e) {
			throw Exception('Error while making $method request: $e\n');
		}
	}

	Future<Map<String, dynamic>> getManifacturers() async {
		return _fetch(HttpMethod.get, Uri.parse('$_baseUrl/vehicle_makes'), null);
	}

	Future<Map<String, dynamic>> getVehicleModels(String manifacturer) async {
		return _fetch(HttpMethod.get, Uri.parse('$_baseUrl/vehicle_makes/$manifacturer/vehicle_models'), null);
	}

	Future<Map<String, dynamic>> getFuelSources() async {
		return _fetch(HttpMethod.get, Uri.parse('$_baseUrl/fuel_sources'), null);
	}

	Future<Map<String, dynamic>> fetchElectricityEstimates({
		required double electricityValue,
		required String country,
		String? electricityUnit,
	}) async {
		const type = 'electricity';

    	final Map<String, dynamic> body = {
			'type': type,
			'electricity_value': electricityValue,
			'country': country,
			if (electricityUnit != null) 'electricity_unit': electricityUnit,
    	};

		return _fetch(HttpMethod.post, Uri.parse('$_baseUrl/estimates'), body);
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

		return _fetch(HttpMethod.post, Uri.parse('$_baseUrl/estimates'), body);
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

		return _fetch(HttpMethod.post, Uri.parse('$_baseUrl/estimates'), body);
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

		return _fetch(HttpMethod.post, Uri.parse('$_baseUrl/estimates'), body);
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

		return _fetch(HttpMethod.post, Uri.parse('$_baseUrl/estimates'), body);
	}
}