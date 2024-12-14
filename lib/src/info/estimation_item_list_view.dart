import 'package:flutter/material.dart';

import 'estimation_item.dart';
import 'estimation_item_details_view.dart';

/// Displays a list of SampleItems.
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

			// To work with lists that may contain a large number of items, it’s best
			// to use the ListView.builder constructor.
			//
			// In contrast to the default ListView constructor, which requires
			// building all Widgets up front, the ListView.builder constructor lazily
			// builds Widgets as they’re scrolled into view.
			body: ListView.builder(
				// Providing a restorationId allows the ListView to restore the
				// scroll position when a user leaves and returns to the app after it
				// has been killed while running in the background.
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
