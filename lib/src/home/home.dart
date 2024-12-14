import 'package:flutter/material.dart';

import '../estimate/electricity.dart';
import '../estimate/flight.dart';
import '../estimate/fuel_combustion.dart';
import '../estimate/shipping.dart';
import '../estimate/vehicle.dart';


class HomePage extends StatelessWidget {
	const HomePage({super.key});

	static const routeName = '/home';

	@override
	Widget build(BuildContext context) {
		double screenWidth = MediaQuery.of(context).size.width;
		
		Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

		HSLColor hslbackgroundColor = HSLColor.fromColor(backgroundColor);
		Color lighterBackgroundColor;
		if (hslbackgroundColor.lightness > 0.8) {
			lighterBackgroundColor = hslbackgroundColor.toColor();
		}
		else {
			lighterBackgroundColor = hslbackgroundColor.withLightness(hslbackgroundColor.lightness + 0.2).toColor();
		}
		
		return Scaffold(
			appBar: AppBar(
				title: const Text('Home page'),
			),
			body: Container(
				decoration: BoxDecoration(
					gradient: RadialGradient(
						colors: [lighterBackgroundColor, backgroundColor],
						center: Alignment.center,
						radius: screenWidth / (2 * screenWidth) + 0.15,
					)
				),
					child: Center(
							child: Column(
								mainAxisSize: MainAxisSize.min,
								children:[
									Row(
										mainAxisAlignment: MainAxisAlignment.spaceEvenly,
										children: [
											CustomButton(
												icon: Icons.electric_bolt,
												route: ElectricityEstimationView.routeName,
											),
											CustomButton(
												icon: Icons.flight,
												route: FlightEstimationView.routeName,
											),
										],
									),
									SizedBox(height: 20),
									Row(
										mainAxisAlignment: MainAxisAlignment.spaceEvenly,
										children: [
											CustomButton(
												icon: Icons.oil_barrel,
												route: FuelCombustionEstimationView.routeName,
											),
											Text(
												'Impakt',
												style: TextStyle(
													fontSize: 30,
													fontWeight: FontWeight.bold,
												),
											),
											CustomButton(
												icon: Icons.local_shipping,
												route: ShippingEstimationView.routeName,
											),
										],
									),
									SizedBox(height: 20),
									CustomButton(
										icon: Icons.directions_car,
										route: VehicleEstimationView.routeName,
									),
								]
							)
						),
					),
		);
	}
}

class CustomButton extends StatelessWidget {
	const CustomButton({super.key, required this.icon, required this.route});
	final String route;
	final IconData icon;
	@override
	Widget build(BuildContext context) {
		return ElevatedButton(
			onPressed: () {
				Navigator.pushNamed(context, route);
			},
			style: ElevatedButton.styleFrom(
				padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding personalizzato
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(20.0), // Curvatura dei bordi
				),
			),
			child: Icon(icon, size: 70.0),
		);
	}
}

