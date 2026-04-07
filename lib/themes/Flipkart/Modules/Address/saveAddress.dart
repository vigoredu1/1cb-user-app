class SavedAddress {
  final String label;
  final String name;
  final String mobile;
  final String email;
  final String country;
  final String state;
  final String city;
  final String zip;
  final String street;

  SavedAddress({
    required this.label,
    required this.name,
    required this.mobile,
    required this.email,
    required this.country,
    required this.state,
    required this.city,
    required this.zip,
    required this.street,
  });

  Map<String, dynamic> toJson() => {
        "label": label,
        "name": name,
        "mobile": mobile,
        "email": email,
        "country": country,
        "state": state,
        "city": city,
        "zip": zip,
        "street": street,
      };

  factory SavedAddress.fromJson(Map<String, dynamic> json) {
    return SavedAddress(
      label: json["label"],
      name: json["name"],
      mobile: json["mobile"],
      email: json["email"],
      country: json["country"],
      state: json["state"],
      city: json["city"],
      zip: json["zip"],
      street: json["street"],
    );
  }
}
