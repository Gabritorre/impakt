import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';

import '../api/api.dart';
import '../api/storage.dart';

class VehicleEstimationView extends StatefulWidget  {
	const VehicleEstimationView({super.key});
	static const routeName = '/vehicle_estimation';
	
	@override
	State<VehicleEstimationView> createState() => _VehicleEstimationViewState();
}

class _VehicleEstimationViewState extends State<VehicleEstimationView> {
	String? estimate;
	String? error;

	final _formKey = GlobalKey<FormState>();
	final ValueNotifier<List<Option>> filteredManufacturerOptions = ValueNotifier<List<Option>>([]);
	final ValueNotifier<List<Option>> filteredModelOptions = ValueNotifier<List<Option>>([]);
	double? selectedDistance;
	String? selectedManufacturer;
	String? selectedModel;
	final TextEditingController manufacturerController = TextEditingController();
	final TextEditingController modelController = TextEditingController();
	

	void estimateVehicle(distance, vehicleId) {
		print('Estimating vehicle trip with $vehicleId over $distance');
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			try {
				final vehicleEstimate = await Broker.getVehicleEstimate(
					distanceValue: distance,
					veichleModelId: vehicleId
				);
				setState(() => estimate = vehicleEstimate);
			} catch (error) {
				setState(() => this.error = 'Error: $error');
			}
		});
	}

	@override
	void initState() {
		super.initState();
		manufacturerController.addListener(() => _filterOptions('manufacturer'));
		modelController.addListener(() => _filterOptions('model'));
	}

	@override
	void dispose() {
		manufacturerController.removeListener(() => _filterOptions('departure'));
		modelController.removeListener(() => _filterOptions('destination'));
		manufacturerController.dispose();
		modelController.dispose();
		filteredManufacturerOptions.dispose();
		filteredModelOptions.dispose();
		super.dispose();
	}

	void _filterOptions(String type) async {
		if (type == 'manufacturer') {
			String query = manufacturerController.text;
			if (query.isNotEmpty) {
				final List<Option> options = await Broker.getVehicleManufacturers();
				filteredManufacturerOptions.value = options.where((option) => option.label.toLowerCase().contains(query.toLowerCase())).toList();
			}
			else {
				filteredManufacturerOptions.value = [];
			}
		}
		else {
			String query = modelController.text;
			if (query.isNotEmpty && selectedManufacturer != null) {
				final List<Option> options = await Broker.getVehicleModels(selectedManufacturer!);
				filteredModelOptions.value = options.where((option) => option.label.toLowerCase().contains(query.toLowerCase())).toList();
			}
			else {
				filteredModelOptions.value = [];
			}
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Flight estimation'),
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
										child: ValueListenableBuilder<List<Option>>(
											valueListenable: filteredManufacturerOptions,
											builder: (context, options, child) {
												return SelectorField(
													controller: manufacturerController,
													label: const Text('Vehicle manufacturer'),
													onSelected: (String? manufacturer) {
														selectedManufacturer = manufacturer;
													},
													dropdownMenuEntries: options.map(Option.asDropdownMenuEntry).toList(),
												);
											},
										),
									),
									const SizedBox(height: 20),
									Padding(
										padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
										child: ValueListenableBuilder<List<Option>>(
											valueListenable: filteredModelOptions,
											builder: (context, options, child) {
												return SelectorField(
													controller: modelController,
													label: const Text('Vehicle model'),
													onSelected: (String? model) {
														selectedModel = model;
													},
													dropdownMenuEntries: options.map(Option.asDropdownMenuEntry).toList(),
												);
											},
										),
									),
									const SizedBox(height: 20),
									Padding(
										padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
										child: DistanceField(
											validator: (value) {
												if (value == null || value.isEmpty) {
													return 'Field required';
												}
												selectedDistance = double.tryParse(value);
												return null;
											},
										),
									),
									const SizedBox(height: 20),
									Padding(
										padding: const EdgeInsets.symmetric(vertical: 15),
										child: ElevatedButton(
											style: ElevatedButton.styleFrom(
												backgroundColor: const Color.fromARGB(255, 61, 61, 61),
												foregroundColor: const Color.fromARGB(255, 223, 223, 223),
												padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
											),
											onPressed: () {
												if ((_formKey.currentState != null && !_formKey.currentState!.validate()) || selectedDistance == null || selectedManufacturer == null || selectedModel == null) {
													ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid form')));
												}
												else {
													setState(() {
														estimate = null;
														error = null;
													});
													estimateVehicle(selectedDistance, selectedModel);
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
										child:Text(
											'$estimate ${snapshot.data?['carbon']} of CO2',
											textAlign: TextAlign.center,
											style: const TextStyle(
												fontSize: 23,
												fontWeight: FontWeight.bold,
												color: Color.fromARGB(255, 212, 212, 212),
											),
										),
									);
								}
								// if not all the fileds have been filled
								else if (estimate == null && selectedDistance == null && selectedManufacturer == null && selectedModel == null) {
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
				),
			),
		);
	}
}


class DistanceField extends StatelessWidget {
	const DistanceField({super.key, this.validator});
	final FormFieldValidator<String>? validator;

	@override
	Widget build(BuildContext context) {
		return TextFormField(
			keyboardType: TextInputType.number,
			decoration: const InputDecoration(
				labelText: 'Travel distance',
				border: UnderlineInputBorder(),
				suffix : Text(
					"km",
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