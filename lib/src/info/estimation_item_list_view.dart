import 'package:flutter/material.dart';

import 'estimation_item.dart';
import 'estimation_item_details_view.dart';

class EstimationListView extends StatelessWidget {
	const EstimationListView({
		super.key,
		this.items = const [EstimationItem('Electricity'), EstimationItem('Flight'), EstimationItem('Fuel Combustion'), EstimationItem('Shipping'), EstimationItem('Vehicle')],
	});

	static const routeName = '/estimation_list';
	final List<EstimationItem> items;

	static CircleAvatar getAvatarForEstimation(String type) {
		IconData icon;
		
		switch (type) {
			case 'Electricity':
				icon = Icons.electric_bolt;
			case 'Flight':
				icon = Icons.flight;
			case 'Fuel Combustion':
				icon = Icons.oil_barrel;
			case 'Shipping':
				icon = Icons.local_shipping;
			case 'Vehicle':
				icon = Icons.directions_car;
			default:
				icon = Icons.info;
		}

		return CircleAvatar(
			child: Icon(icon),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Estimation Info'),
			),

			body: ListView.builder(
				restorationId: 'sampleItemListView',
				itemCount: items.length,
				itemBuilder: (BuildContext context, int index) {
					final item = items[index];

					return ListTile(
						title: Text('${item.type} estimation'),
						leading: getAvatarForEstimation(item.type),
						onTap: () {
							Navigator.pushNamed(
								context,
								EstimationItemDetailsView.routeName,
								arguments: {'type': item.type},
							);
						}
					);
				},
			),
		);
	}
}
