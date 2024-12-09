import 'package:flutter/material.dart';
import 'package:impakt/src/api/api.dart';

class VehicleEstimationView extends StatefulWidget  {
	const VehicleEstimationView({super.key});
	static const routeName = '/vehicle_estimation';
	
	@override
	State<VehicleEstimationView> createState() => _VehicleEstimationViewState();
}

class _VehicleEstimationViewState extends State<VehicleEstimationView> {
	String? estimate;
	String? error;
	String carbonUnit = 'kg';

	// On first widget's render
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			Api.fetchVehicleEstimates(
				distanceUnit: 'mi',
				distanceValue: 1000.0,
				veichleModelId: 'f46c68e5-4b0d-4136-a8cd-ed103cc202d1'
			).then((response) {
				setState(() {
					String measure = 'carbon_$carbonUnit';
					estimate = response['data']['attributes'][measure].toString();
				});
			}).catchError((error){
				setState(() {
					this.error = 'Error: $error';
				});
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Vehicle Estimation'),
			),
			body: Center(
				child: Builder(
					builder: (context) {
						if (error != null) {
							return Text(error!);
						} else if (estimate != null) {
							return Text('$estimate $carbonUnit');
						} else {
							return const CircularProgressIndicator();
						}
					},
				),
			),
		);
	}
}