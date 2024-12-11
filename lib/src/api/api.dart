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
		final url = Uri.parse('$_baseUrl$function');

		try {

			if (method == HttpMethod.get) {
				response = await http.get(url, headers: _headers);
			} else if (method == HttpMethod.post && body != null) {
				response = await http.post(url, headers: _headers, body: jsonEncode(body));
			} else {
				throw Exception('Invalid HTTP call for method: "$method" with body:\n"$body"');
			}

			// Accept only strings in the format of "2xx" (successful responses)
			if (RegExp(r'^2\d{2}$').hasMatch(response.statusCode.toString())) {
				return jsonDecode(response.body);
			} else {
				throw Exception('${response.statusCode.toString()} status code');
			}

		} catch (e) {
			throw Exception('$method request returned: $e with the following url:\n$url');
		}
	}
}