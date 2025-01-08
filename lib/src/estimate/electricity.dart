import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';

import '../api/api.dart';
import '../api/storage.dart';
import '../settings/settings_controller.dart';

class ElectricityEstimationView extends StatefulWidget  {
	const ElectricityEstimationView({super.key, required this.controller});
	static const routeName = '/electricity_estimation';

	final SettingsController controller;

	@override
	State<ElectricityEstimationView> createState() => _ElectricityEstimationViewState();
}

class _ElectricityEstimationViewState extends State<ElectricityEstimationView> {
	String? estimate;
	String? error;
	bool validForm = false;

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
				setState(() => this.error = 'Error: ${error.toString()}');
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Electricity estimation'),
			),
			body: Align(
				alignment: Alignment.topCenter,
				child: SingleChildScrollView(
					child: ListenableBuilder(
						listenable: widget.controller,
						builder: (BuildContext context, Widget? child) {
							return Column(
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
														controller: widget.controller,
													),
												),
												const SizedBox(height: 10),
												Padding(
													padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
													child: CountrySelectorField(
														controller: countryController,
														onSelected: (String? country) {
															selectedCountry = country;
														},
													)
												),
												const SizedBox(height: 10),
												Padding(
													padding: const EdgeInsets.symmetric(vertical: 15),
													child: ElevatedButton(
														style: ElevatedButton.styleFrom(
															backgroundColor: const Color.fromARGB(255, 61, 61, 61),
															foregroundColor: const Color.fromARGB(255, 223, 223, 223),
															padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
														),
														onPressed: () {
															FocusScope.of(context).unfocus();	//close keyboard
															setState(() {
																estimate = null;
																error = null;
															});
															if ((_formKey.currentState != null && !_formKey.currentState!.validate()) || selectedCountry == null ) {
																validForm = false;
																ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all the input fields')));
															}
															else if (electricityValue == null || electricityValue! <= 0) {
																validForm = false;
																ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Electricity consumption must be a positive number')));
															}
															else {
																validForm = true;
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
									FutureBuilder(
										future: Storage.getSavedUnits(),
										builder: (context, snapshot) {
											if (error != null) {
												return Text(error!);
											}
											// if not all the fileds have been filled
											else if (validForm == false) {
												return const SizedBox(height: 0);
											}
											// if the estimation has been calculated and the estimation measure unit has been loaded from the storage
											else if (estimate != null && snapshot.connectionState == ConnectionState.done) {
												return Padding(
													padding: const EdgeInsets.symmetric(vertical: 15),
													child: Text(
														'$estimate ${snapshot.data?['carbon']!.label} of CO2',
														textAlign: TextAlign.center,
														style: const TextStyle(
															fontSize: 23,
															fontWeight: FontWeight.bold,
														),
													),
												);
											}
											// if the estimation is being calculated
											else {
												return const Padding(
													padding: EdgeInsets.symmetric(vertical: 15),
													child: CircularProgressIndicator()
												);
											}
										},
									),
								],
							);
						},
					),
				),
			),
		);
	}
}

class ElectricityConsumptionField extends StatelessWidget {
	const ElectricityConsumptionField({super.key, this.validator, required this.controller});
	final FormFieldValidator<String>? validator;
	final SettingsController controller;

	@override
	Widget build(BuildContext context) {
		return TextFormField(
			keyboardType: TextInputType.number,
			decoration: InputDecoration(
				labelText: 'Electricity consumption',
				border: const UnderlineInputBorder(),
				suffix : Text(
					controller.units['electricity']!.label,
					textAlign: TextAlign.center,
					style: const TextStyle(
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
			dropdownMenuEntries: Storage.getCountries().map(Choice.asDropdownMenuEntry).toList(),
		);
	}
}
