import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum HttpMethod {get, post}

class Choice {
	final String code, label;
	Choice(this.code, this.label);
	static DropdownMenuEntry<String> asDropdownMenuEntry(Choice option) => DropdownMenuEntry(value: option.code, label: option.label);
	@override String toString() => '<$label#$code>';
}

class ApiException implements Exception {
	final HttpMethod? requestMethod;
	final int? statusCode;
	final Map<String, dynamic>? responseBody;
	final String message;

	ApiException({
		this.requestMethod,
		this.statusCode,
		this.responseBody,
		required this.message,
	});

	@override
	String toString() {
		return message;
	}
}

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

		final Future<http.Response> Function() fetcher;
		if (method == HttpMethod.get) {
			fetcher = () async => await http.get(url, headers: _headers);
		} else if (method == HttpMethod.post && body != null) {
			fetcher = () async => await http.post(url, headers: _headers, body: jsonEncode(body));
		} else {
			throw ApiException(
				requestMethod: method,
				message: 'Malformed request'
			);
		}

		try {
			response = await fetcher();
		} catch (error) {
			throw ApiException(
				requestMethod: method,
				message: 'Connection failed'
			);
		}

		// Accept only strings in the format of "2xx" (successful responses)
		if (RegExp(r'^2\d{2}$').hasMatch(response.statusCode.toString())) {
			return jsonDecode(response.body);
		} else {
			throw ApiException(
				requestMethod: method,
				statusCode: response.statusCode,
				responseBody: jsonDecode(response.body),
				message: 'Response gave an error'
			);
		}
	}
}