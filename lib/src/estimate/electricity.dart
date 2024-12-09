import 'package:flutter/material.dart';
import 'package:impakt/src/api/api.dart';
import 'package:impakt/src/api/broker.dart';

Map<String, String> countries = Broker.getCountries();

class ElectricityEstimationView extends StatefulWidget  {
	const ElectricityEstimationView({super.key});
	static const routeName = '/electricity_estimation';
	
	@override
	State<ElectricityEstimationView> createState() => _ElectricityEstimationViewState();
}

class _ElectricityEstimationViewState extends State<ElectricityEstimationView> {
	String? estimate;
	String? error;
	String carbonUnit = 'kg';

	final _formKey = GlobalKey<FormState>();
	String? selectedCountry;
	double? electricityValue;
	final TextEditingController countryController = TextEditingController();

	void estimateElectricity(electricityValue, country) {
		WidgetsBinding.instance.addPostFrameCallback((_) {
			Api.fetchElectricityEstimates(
				electricityValue: electricityValue,
				country: country,
				electricityUnit: 'mwh',
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
										padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
										child: TextFormField(
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
										padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
										child: DropdownMenu(
											controller: countryController,
											width: double.infinity,
											enableFilter: true,
											enableSearch: false,
											requestFocusOnTap: true,
											label: const Text('Country'),
											onSelected: (String? country) {
												selectedCountry = country;
											},
											dropdownMenuEntries: countries.entries.map<DropdownMenuEntry<String>>(
												(MapEntry<String, String> country) {
													return DropdownMenuEntry<String>(
														value: country.key,
														label: country.value,
													);
												},
											).toList(),
										),
									),
									ElevatedButton(
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
										child: const Text('Estimate'),
									),
								],
							),
						),
						Builder(
							builder: (context) {
								if (error != null) {
									return Text(error!);
								} else if (estimate != null) {
									return Text('$estimate $carbonUnit');
								} 
								else if (estimate == null && selectedCountry == null && electricityValue == null) {
									return const SizedBox(height: 0);
								}
								else {
									return const CircularProgressIndicator();
								}
							},
						),
					],
				),
			),
		);
	}
}
