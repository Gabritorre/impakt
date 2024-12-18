import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';

import '../api/api.dart';
import '../api/storage.dart';
import '../settings/settings_controller.dart';

class ShippingEstimationView extends StatefulWidget  {
	const ShippingEstimationView({super.key, required this.controller});
	static const routeName = '/shipping_estimation';

	final SettingsController controller;

	@override
	State<ShippingEstimationView> createState() => _ShippingEstimationViewState();
}

class _ShippingEstimationViewState extends State<ShippingEstimationView> {
	String? estimate;
	String? error;

	final _formKey = GlobalKey<FormState>();
	double? selectedWeight;
	double? selectedDistance;
	String? selectedTransportMethod;

	final TextEditingController trasportMethodController = TextEditingController();


	void estimateShipping(weight, distance, transportMethod) {
		print('Estimating shipping with weight $weight and distance $distance using $transportMethod');
		WidgetsBinding.instance.addPostFrameCallback((_) async{
			try {
				final shippingEstimate = await Broker.getShippingEstimate(
					weightValue: weight,
					distanceValue: distance,
					transportMethod: transportMethod
				);
				setState(() => estimate = shippingEstimate);
			} catch (error) {
				setState(() => this.error = 'Error: ${error.toString()}');
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Shipping estimation'),
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
													child: ShippingInfoField(
														validator: (value) {
														if (value == null || value.isEmpty) {
																return 'Field required';
															}
															selectedWeight = double.tryParse(value);
															return null;
														},
														unit: widget.controller.units['weight']!.label,
														labelText: 'Weight',
													),
												),
												const SizedBox(height: 10),
												Padding(
													padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
													child: ShippingInfoField(
														validator: (value) {
														if (value == null || value.isEmpty) {
																return 'Field required';
															}
															selectedDistance = double.tryParse(value);
															return null;
														},
														unit: widget.controller.units['distance']!.label,
														labelText: 'Distance',
													),
												),
												const SizedBox(height: 10),
												Padding(
													padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
													child: SelectorField(
														controller: trasportMethodController,
														label: const Text('Transport method'),
														onSelected: (String? transportMethod) {
															selectedTransportMethod = transportMethod;
														},
														dropdownMenuEntries: Storage.getTransportMethods().map(Choice.asDropdownMenuEntry).toList(),
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
															if ((_formKey.currentState != null && !_formKey.currentState!.validate()) || selectedWeight == null || selectedDistance == null || selectedTransportMethod == null) {
																ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all the input fields')));
															}
															else {
																setState(() {
																	estimate = null;
																});
																estimateShipping(selectedWeight, selectedDistance, selectedTransportMethod);
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
											// if not all the fileds have been filled
											else if (estimate == null && selectedWeight == null && selectedDistance == null && selectedTransportMethod == null) {
												return const SizedBox(height: 0);
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
						}
					),
				),
			),
		);
	}
}

class ShippingInfoField extends StatelessWidget {
	const ShippingInfoField({super.key, this.validator, required this.unit, this.labelText});
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
			menuHeight: null,
			enableFilter: true,
			enableSearch: false,
			requestFocusOnTap: true,
			label: label,
			onSelected: onSelected,
			dropdownMenuEntries: dropdownMenuEntries,
		);
	}
}