import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum HttpMethod {get, post}

class Api {
	static final String _apiKey = dotenv.env['API_KEY']!;
	static const String _baseUrl = 'https://www.carboninterface.com/api/v1';

	static final Map<String, String> _headers = {
		'Authorization': 'Bearer $_apiKey',
		'Content-Type': 'application/json',
	};

	static Future<dynamic> fetch(HttpMethod method, String function, [Map<String, dynamic>? body]) async {
		final http.Response response;
		final url = Uri.parse('$_baseUrl/$function');

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

	static Future<dynamic> getVehicleModels(String manufacturer) async {
		return await fetch(HttpMethod.get, '/vehicle_makes/$manufacturer/vehicle_models');
	}

	static Future<dynamic> getFuelSources() async {
		return await fetch(HttpMethod.get, '/fuel_sources');
	}

	static Future<dynamic> getFlightEstimate({
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

		return await fetch(HttpMethod.post, '/estimates', body);
	}

	static Future<dynamic> getShippingEstimate({
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

		return await fetch(HttpMethod.post, '/estimates', body);
	}

	static Future<dynamic> getVehicleEstimate({
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

		return await fetch(HttpMethod.post, '/estimates', body);
	}

	static Future<dynamic> getFuelCombustionEstimate({
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

		return await fetch(HttpMethod.post, '/estimates', body);
	}
}