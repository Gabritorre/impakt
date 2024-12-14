import 'package:flutter/material.dart';
import 'package:impakt/src/api/storage.dart';
import 'package:impakt/src/info/estimation_item_list_view.dart';

class EstimationItemDetailsView extends StatelessWidget {
	final String type;
	const EstimationItemDetailsView({super.key, required this.type});

	static const routeName = '/item_details';

	String _getDescriptionForEstimation(String type) {
		final infos = Storage.getInfos();

		switch (type) {
			case 'Electricity':
				return infos['electricity']!['description']!;
			case 'Flight':
				return infos['flight']!['description']!;
			case 'Fuel Combustion':
				return infos['fuel_combustion']!['description']!;
			case 'Shipping':
				return infos['shipping']!['description']!;
			case 'Vehicle':
				return infos['vehicles']!['description']!;
			default:
				return 'default';
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('$type Estimation Details'),
			),
			body: Center(
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						EstimationListView.getAvatarForEstimation(type),
						const SizedBox(height: 16),
						const Divider(),
						const SizedBox(height: 16),
						Text(
							_getDescriptionForEstimation(type),
							style: const TextStyle(
								fontSize: 16,
								fontWeight: FontWeight.bold
							),
							textAlign: TextAlign.center
						),
						const SizedBox(height: 16),
						const Divider(),
					]
				)
			),
		);
	}
}
