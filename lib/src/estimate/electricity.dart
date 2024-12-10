import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';

import '../api/storage.dart';

class ElectricityEstimationView extends StatefulWidget  {
	const ElectricityEstimationView({super.key});
	static const routeName = '/electricity_estimation';
	
	@override
	State<ElectricityEstimationView> createState() => _ElectricityEstimationViewState();
}

class _ElectricityEstimationViewState extends State<ElectricityEstimationView> {
	String? estimate;
	String? error;

	final _formKey = GlobalKey<FormState>();
	String? selectedCountry;
	double? electricityValue;
	final TextEditingController countryController = TextEditingController();

	void estimateElectricity(electricityValue, country) {
		print('Estimating electricity $electricityValue kWh in $country');
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			try {
				final electricityEstimate = await Broker.getElectricityEstimate(
					electricityValue: electricityValue,
					country: country
				);
				setState(() => estimate = electricityEstimate);
			} catch (error) {
				setState(() => this.error = 'Error: $error');
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Electricity Estimation'),
			),
			body: Align(
				alignment: Alignment.topCenter,
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Form(
							key: _formKey,
							child: Column(
								children: [
									const SizedBox(height: 10),
									Padding(
										padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
										child: ElectricityConsumptionField(
											validator: (value) {
											if (value == null || value.isEmpty) {
													return 'Field required';
												}
												electricityValue = double.tryParse(value);
												return null;
											},
										),
									),
									const SizedBox(height: 20),
									Padding(
										padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
										child: CountrySelectorField(
											controller: countryController,
											onSelected: (String? country) {
												selectedCountry = country;
											},
										)
									),
									Padding(
										padding: const EdgeInsets.symmetric(vertical: 15),
										child: ElevatedButton(
											style: ElevatedButton.styleFrom(
												backgroundColor: const Color.fromARGB(255, 61, 61, 61), // Colore di sfondo
												foregroundColor: const Color.fromARGB(255, 223, 223, 223), // Colore del testo
												padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0), // Personalizza il padding
											),
											onPressed: () {
												if ((_formKey.currentState != null && !_formKey.currentState!.validate()) || selectedCountry == null ) {
													ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid form')));
												}
												else {
													setState(() {
														estimate = null;
													});
													estimateElectricity(electricityValue, selectedCountry);
												}
											},
											child: const Text(
												'Estimate',
												textAlign: TextAlign.center,
												style: TextStyle(
													fontSize: 18,
													fontWeight: FontWeight.bold,
												),
											),
										),
									),
								],
							),
						),
						Builder(
							builder: (context) {
								if (error != null) {
									return Text(error!);
								}
								else if (estimate != null) {
									return Padding(
										padding: const EdgeInsets.symmetric(vertical: 15),
										child:Text(
											'$estimate ${Storage.getCarbonUnit()} of CO2',
											textAlign: TextAlign.center,
											style: const TextStyle(
												fontSize: 23,
												fontWeight: FontWeight.bold,
												color: Color.fromARGB(255, 212, 212, 212),
											),
										),
									);
								} 
								else if (estimate == null && selectedCountry == null && electricityValue == null) {
									return const SizedBox(height: 0);
								}
								else {
									return const Padding(
										padding: EdgeInsets.symmetric(vertical: 15),
										child: CircularProgressIndicator()
									);
								}
							},
						),
					],
				),
			),
		);
	}
}

class ElectricityConsumptionField extends StatelessWidget {
	const ElectricityConsumptionField({super.key, this.validator});
	final FormFieldValidator<String>? validator;

	@override
	Widget build(BuildContext context) {
				return TextFormField(
			keyboardType: TextInputType.number,
			decoration: const InputDecoration(
				labelText: 'Electricity consumption',
				border: UnderlineInputBorder(),
				suffix : Text(
					'kWh',
					textAlign: TextAlign.center,
					style: TextStyle(
						fontSize: 18,
						fontWeight: FontWeight.bold,
						color: Color.fromARGB(255, 155, 155, 155),
					),
				),
			),
			validator: validator,
		);
	}
}

class CountrySelectorField extends StatelessWidget{
	const CountrySelectorField({super.key, this.controller, this.onSelected});
	final TextEditingController? controller;
	final ValueChanged<String?>? onSelected;
	@override
	Widget build(BuildContext context) {
		return DropdownMenu(
			controller: controller,
			width: double.infinity,
			menuHeight: 200,
			enableFilter: true,
			enableSearch: false,
			requestFocusOnTap: true,
			label: const Text('Country'),
			onSelected: onSelected,
			dropdownMenuEntries: Storage.getCountries().map(Option.asDropdownMenuEntry).toList(),
		);
	}
}
