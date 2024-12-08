import 'dart:convert';
import 'package:http/http.dart' as http;

class CarbonEstimateBroker {
	static const String API_KEY = '';
	final Uri url;

	final Map<String, String> headers = {
		'Authorization': 'Bearer $API_KEY',
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

	Future<Map<String, dynamic>> fetchElectricityEstimates({required double electricityValue, required String country, String? electricityUnit, String? state}) async {
		const type = 'electricity';

    	final Map<String, dynamic> body = {
			'type': type,
			'electricity_value': electricityValue,
			'country': country,
			if (electricityUnit != null) 'electricity_unit': electricityUnit,
			if (state != null) 'state': state,
    	};

		return _fetch(body);
	}
}