import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';

//placeholder list of countries
List<String> countries = [
	'Italy',
	'USA',
	'Germany',
	'Canada',
	'Australia',
	'China',
	'Japan',
	'Brazil',
	'Russia',
	'South Africa',
	'Mexico',
	'Argentina',
	'France',
	'United Kingdom',
	'Republic of Korea',
	'Saudi Arabia',
	'India'
];


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
	

	// On first widget's render
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			final broker = CarbonEstimateBroker();
			broker.fetchElectricityEstimates(
				electricityValue: 42.0,
				country: 'us',
				electricityUnit: 'mwh',
				state: 'fl',
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
						const MyForm(),
						Builder(
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
					],
				),
			),
		);
	}
}



class MyForm extends StatefulWidget {
	const MyForm({super.key});

	@override
	State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
	final _formKey = GlobalKey<FormState>();
	String? _selectedCountry;
	int? electricityValue;
	final TextEditingController countryController = TextEditingController();

	@override
	Widget build(BuildContext context) {
		return Form(
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
								electricityValue = int.tryParse(value);
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
								_selectedCountry = country;
							},
							dropdownMenuEntries: countries.map<DropdownMenuEntry<String>>(
								(String country) {
									return DropdownMenuEntry<String>(
										value: country,
										label: country,
									);
								},
							).toList(),
						),
					),
					ElevatedButton(
						onPressed: () {
							if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
								ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid form')));
							}
						},
						child: const Text('Estimate'),
					),
				],
			),
		);
	}
}
