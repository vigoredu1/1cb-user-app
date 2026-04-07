import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IndiaStateCityDropdown extends StatefulWidget {
  final TextEditingController countryController;
  final TextEditingController stateController;
  final TextEditingController cityController;

  const IndiaStateCityDropdown({
    super.key,
    required this.countryController,
    required this.stateController,
    required this.cityController,
  });

  @override
  State<IndiaStateCityDropdown> createState() => _IndiaStateCityDropdownState();
}

class _IndiaStateCityDropdownState extends State<IndiaStateCityDropdown> {
  Map<String, dynamic> data = {};
  List<String> states = [];
  List<String> cities = [];
  String selectedState = '';
  String selectedCity = '';

  @override
  void initState() {
    super.initState();
    widget.countryController.text = 'India';
    _loadJson();
  }

  Future<void> _loadJson() async {
    final raw = await rootBundle.loadString('assets/india/Indian_Cities_In_States_JSON');
    final jsonMap = json.decode(raw) as Map<String, dynamic>;
    setState(() {
      data = jsonMap;
      states = data.keys.toList();
    });
  }

  void onStateChange(String? val) {
    if (val == null) return;
    setState(() {
      selectedState = val;
      widget.stateController.text = val;
      cities = List<String>.from(data[val] ?? []);
      selectedCity = '';
      widget.cityController.clear();
    });
  }

  void onCityChange(String? val) {
    if (val == null) return;
    setState(() {
      selectedCity = val;
      widget.cityController.text = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Country: India'),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Select State'),
          value: selectedState.isEmpty ? null : selectedState,
          items: states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: onStateChange,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Select City'),
          value: selectedCity.isEmpty ? null : selectedCity,
          items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: selectedState.isNotEmpty ? onCityChange : null,
        ),
      ],
    );
  }
}
