import 'package:flutter/material.dart';

enum PriceSortType {
  lowToHigh,
  highToLow,
}

class PriceSortWidget extends StatefulWidget {
  final ValueChanged<PriceSortType> onSortSelected;

  const PriceSortWidget({super.key, required this.onSortSelected});

  @override
  State<PriceSortWidget> createState() => _PriceSortWidgetState();
}

class _PriceSortWidgetState extends State<PriceSortWidget> {
  PriceSortType? selectedSort;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<PriceSortType>(
                value: selectedSort,
                hint: const Text("Select Price Order"),
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: PriceSortType.lowToHigh,
                    child: Text('Price: Low to High'),
                  ),
                  DropdownMenuItem(
                    value: PriceSortType.highToLow,
                    child: Text('Price: High to Low'),
                  ),
                ],
                onChanged: (PriceSortType? newValue) {
                  setState(() {
                    selectedSort = newValue;
                  });
                  if (newValue != null) {
                    widget.onSortSelected(newValue);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
