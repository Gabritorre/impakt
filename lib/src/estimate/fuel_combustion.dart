import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';
import 'package:impakt/src/api/storage.dart';

import '../api/api.dart';
import '../settings/settings_controller.dart';

class FuelCombustionEstimationView extends StatefulWidget {
	const FuelCombustionEstimationView({super.key, required this.controller});
	static const routeName = '/fuel_estimation';

	final SettingsController controller;
	
	@override
	State<FuelCombustionEstimationView> createState() => _FuelCombustionEstimationViewState();
}

class _FuelCombustionEstimationViewState extends State<FuelCombustionEstimationView> {
	String? estimate;
	String? error;
	bool validForm = false;

	final _formKey = GlobalKey<FormState>();
	String? selectedFuelType;
	double? selectedFuelValue;
	final TextEditingController fuelTypeController = TextEditingController();


	void estimateFuelCombustion(fuelType, fuelValue) {
		print('Estimating fuel combustion with $fuelValue of $fuelType');
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			try {
				final fuelCombustionEstimate = await Broker.getFuelCombustionEstimate(
					fuelSourceType: fuelType,
					fuelSourceValue: fuelValue
				);
				setState(() => estimate = fuelCombustionEstimate);
			} catch (error) {
				setState(() => this.error = 'Error: ${error.toString()}');
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Fuel combustion estimation'),
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
													child: SelectorField(
														controller: fuelTypeController,
														label: const Text('Fuel type'),
														onSelected: (String? fuelType) {
															setState(() {
																selectedFuelType = fuelType;
															});
														},
														dropdownMenuEntries: Storage.getFuelSources().map(Choice.asDropdownMenuEntry).toList(),
													)
												),
												const SizedBox(height: 10),
												Padding(
													padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
													child: FuelValueField(
														validator: (value) {
														if (value == null || value.isEmpty) {
																return 'Field required';
															}
															selectedFuelValue = double.tryParse(value);
															return null;
														},
														unit: widget.controller.units['fuel_$selectedFuelType']?.label ?? 'BTU',
														labelText: 'Fuel value',
													),
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
															if ((_formKey.currentState != null && !_formKey.currentState!.validate()) || selectedFuelType == null) {
																validForm = false;
																ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all the input fields')));
															}
															else if (selectedFuelValue == null || selectedFuelValue! <= 0) {
																validForm = false;
																ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fuel value must be a positive number')));
															}
															else {
																validForm = true;
																estimateFuelCombustion(selectedFuelType, selectedFuelValue);
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

class FuelValueField extends StatelessWidget {
	const FuelValueField({super.key, this.validator, required this.unit, this.labelText});
	final FormFieldValidator<String>? validator;
	final String unit;
	final String? labelText;

	@override
	Widget build(BuildContext context) {
		return TextFormField(
			keyboardType: TextInputType.number,
			decoration: InputDecoration(
				labelText: labelText,
				border: UnderlineInputBorder(),
				suffix : Text(
					unit,
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

class SelectorField extends StatelessWidget{
	const SelectorField({super.key, this.controller, this.onSelected, this.label, required this.dropdownMenuEntries});
	final TextEditingController? controller;
	final ValueChanged<String?>? onSelected;
	final Widget? label;
	final List<DropdownMenuEntry<String>> dropdownMenuEntries;

	@override
	Widget build(BuildContext context) {
		return DropdownMenu(
			controller: controller,
			width: double.infinity,
			menuHeight: 200,
			enableFilter: true,
			enableSearch: false,
			requestFocusOnTap: true,
			label: label,
			onSelected: onSelected,
			dropdownMenuEntries: dropdownMenuEntries,
		);
	}
}