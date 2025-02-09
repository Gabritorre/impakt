import 'package:flutter/material.dart';
import 'package:impakt/src/api/broker.dart';

import '../api/api.dart';
import '../api/storage.dart';

class FlightEstimationView extends StatefulWidget  {
	const FlightEstimationView({super.key});
	static const routeName = '/flight_estimation';
	
	@override
	State<FlightEstimationView> createState() => _FlightEstimationViewState();
}

class _FlightEstimationViewState extends State<FlightEstimationView> {
	String? estimate;
	String? error;
	bool validForm = false;
	
	final _formKey = GlobalKey<FormState>();
	final ValueNotifier<List<Choice>> filteredDepartureOptions = ValueNotifier<List<Choice>>([]);
	final ValueNotifier<List<Choice>> filteredDestinationOptions = ValueNotifier<List<Choice>>([]);
	String? selectedDepartureAirport;
	String? selectedDestinationAirport;
	int? passengers;
	String? cabinClass;
	final TextEditingController departureController = TextEditingController();
	final TextEditingController destinationController = TextEditingController();
	final TextEditingController classCabinController = TextEditingController();
	

	void estimateFlight(selectedDepartureAirport, selectedDestinationAirport, passengers, cabinClass) {
		print('Estimating flight from $selectedDepartureAirport to $selectedDestinationAirport ($passengers passengers, $cabinClass class)');
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			try {
				final flightEstimate = await Broker.getFlightEstimate(
					passengers: passengers,
					departureAirport: selectedDepartureAirport,
					destinationAirport: selectedDestinationAirport,
					cabinClass: cabinClass
				);
				setState(() => estimate = flightEstimate);
			} catch (error) {
				setState(() => this.error = 'Error: ${error.toString()}');
			}
		});
	}

	@override
	void initState() {
		super.initState();
		departureController.addListener(() => _filterOptions('departure'));
		destinationController.addListener(() => _filterOptions('destination'));
	}

	@override
	void dispose() {
		departureController.removeListener(() => _filterOptions('departure'));
		destinationController.removeListener(() => _filterOptions('destination'));
		departureController.dispose();
		destinationController.dispose();
		filteredDepartureOptions.dispose();
		filteredDestinationOptions.dispose();
		super.dispose();
	}

	void _filterOptions(String type) async {
		if (type == 'departure') {
			String query = departureController.text;
			if (query.length >= 3) {
				final List<Choice> options = await Storage.getAirports();
				filteredDepartureOptions.value = options.where((option) => option.label.toLowerCase().contains(query.toLowerCase())).toList();
			}
			else {
				filteredDepartureOptions.value = [];
			}
		}
		else {
			String query = destinationController.text;
			if (query.length >= 3) {
				final List<Choice> options = await Storage.getAirports();
				filteredDestinationOptions.value = options.where((option) => option.label.toLowerCase().contains(query.toLowerCase())).toList();
			}
			else {
				filteredDestinationOptions.value = [];
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
				child: SingleChildScrollView(
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
											child: ValueListenableBuilder<List<Choice>>(
												valueListenable: filteredDepartureOptions,
												builder: (context, options, child) {
													return SelectorField(
														controller: departureController,
														label: const Text('Departure airport'),
														onSelected: (String? airport) {
															selectedDepartureAirport = airport;
														},
														dropdownMenuEntries: options.map(Choice.asDropdownMenuEntry).toList(),
													);
												},
											),
										),
										const SizedBox(height: 10),
										Padding(
											padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
											child: ValueListenableBuilder<List<Choice>>(
												valueListenable: filteredDestinationOptions,
												builder: (context, options, child) {
													return SelectorField(
														controller: destinationController,
														label: const Text('Destination airport'),
														onSelected: (String? airport) {
															selectedDestinationAirport = airport;
														},
														dropdownMenuEntries: options.map(Choice.asDropdownMenuEntry).toList(),
													);
												},
											),
										),
										const SizedBox(height: 10),
										Padding(
											padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
											child: PassengersField(
												validator: (value) {
													if (value == null || value.isEmpty) {
														return 'Field required';
													}
													passengers = int.tryParse(value);
													return null;
												},
											),
										),
										const SizedBox(height: 10),
										Padding(
											padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
											child: SelectorField(
												controller: classCabinController,
												label: const Text('Cabin class'),
												onSelected: (String? classType) {
													cabinClass = classType;
												},
												dropdownMenuEntries: Storage.getCabinClasses().map(Choice.asDropdownMenuEntry).toList(),
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
													if ((_formKey.currentState != null && !_formKey.currentState!.validate()) || selectedDepartureAirport == null || selectedDestinationAirport == null || cabinClass == null) {
														validForm = false;
														ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all the input fields')));
													}
													else if (passengers == null || passengers! <= 0) {
														validForm = false;
														ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Number of passengers must be a positive integer number')));
													}
													else {
														validForm = true;
														estimateFlight(selectedDepartureAirport, selectedDestinationAirport, passengers, cabinClass);
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
											child:Text(
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
					),
				),
			),
		);
	}
}


class PassengersField extends StatelessWidget {
	const PassengersField({super.key, this.validator});
	final FormFieldValidator<String>? validator;

	@override
	Widget build(BuildContext context) {
		return TextFormField(
			keyboardType: TextInputType.number,
			decoration: const InputDecoration(
				labelText: 'Number of passengers',
				border: UnderlineInputBorder(),
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