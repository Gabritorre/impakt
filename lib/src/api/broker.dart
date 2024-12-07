import 'dart:convert';
import 'package:http/http.dart' as http;

class CarbonEstimateBroker {
	final String baseUrl = 'https://www.carboninterface.com/api/v1/estimates';
	static const String API_KEY = '';

	final Map<String, String> headers = {
		'Authorization': 'Bearer $API_KEY',
        'Content-Type': 'application/json',
    };

	CarbonEstimateBroker();

	Future<Map<String, dynamic>> fetchElectricityEstimates({required String country, required String state, required String electricityUnit, required double electricityValue}) async {
    	final Uri url = Uri.parse(baseUrl);
		const type = 'electricity';

    	final Map<String, dynamic> body = {
			'type': type,
			'country': country,
			'state': state,
			'electricity_unit': electricityUnit,
			'electricity_value': electricityValue,
    	};

		try {
			final http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));

			if (response.statusCode == 201) {
				return jsonDecode(response.body);
			} else {
				throw Exception('Response gave: ${response.statusCode} status code:\n${response.body}');
			}
		} catch (e) {
			throw Exception('Error while making POST request: $e');
		}
	}
}