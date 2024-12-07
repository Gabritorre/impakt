import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class EstimationItemDetailsView extends StatelessWidget {
	const EstimationItemDetailsView({super.key});

	static const routeName = '/sample_item';

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Estimation Details'),
			),
			body: const Center(
				child: Text('Information Here'),
			),
		);
	}
}
