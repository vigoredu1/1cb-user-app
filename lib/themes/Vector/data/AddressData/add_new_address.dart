import 'package:flutter/material.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  _AddNewAddressScreenState createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  String addressType = "Home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Address", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Name", "Enter your Name"),
              _buildTextField("Phone Number", "Enter your Phone Number",
                  keyboardType: TextInputType.phone),
              _buildTextField("Street Address", "Enter Street Address"),
              _buildTextField("Landmark", "Enter Landmark"),
              Row(
                children: [
                  Expanded(child: _buildTextField("City", "Enter City")),
                  SizedBox(width: 10),
                  Expanded(
                      child: _buildTextField("Zip Code", "Enter Zip Code",
                          keyboardType: TextInputType.number)),
                ],
              ),
              SizedBox(height: 16),
              Text("Address Type",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 10),
              Row(
                children: [
                  _buildAddressTypeOption("Home"),
                  _buildAddressTypeOption("Office"),
                  _buildAddressTypeOption("Other"),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey),
                ),
                child: Text("Cancel",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // handle add address logic here
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text("Add", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? "Please enter $label" : null,
      ),
    );
  }

  Widget _buildAddressTypeOption(String type) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            addressType = type;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: addressType == type ? Colors.black : Colors.grey),
            color: addressType == type ? Colors.black.withOpacity(0.05) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<String>(
                value: type,
                groupValue: addressType,
                activeColor: Colors.black,
                onChanged: (val) {
                  setState(() {
                    addressType = val!;
                  });
                },
              ),
              Text(type,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color:
                      addressType == type ? Colors.black : Colors.grey[700])),
            ],
          ),
        ),
      ),
    );
  }
}
