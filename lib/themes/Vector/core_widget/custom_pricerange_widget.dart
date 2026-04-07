import 'package:flutter/material.dart';

class PriceRangeSelector extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final ValueChanged<RangeValues> onChanged;

  const PriceRangeSelector({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  });

  @override
  State<PriceRangeSelector> createState() => _PriceRangeSelectorState();
}

class _PriceRangeSelectorState extends State<PriceRangeSelector> {
  late RangeValues currentRange;

  @override
  void initState() {
    super.initState();
    currentRange = RangeValues(widget.minValue, widget.maxValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.black87,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: Colors.white,
            overlayColor: Colors.green.withOpacity(0.2),
            valueIndicatorColor: Colors.green,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          ),
          child: RangeSlider(
            values: currentRange,
            min: widget.minValue,
            max: widget.maxValue,
            divisions: ((widget.maxValue - widget.minValue) ~/ 100).toInt(),
            labels: RangeLabels(
              '₹${currentRange.start.toInt()}',
              '₹${currentRange.end.toInt()}',
            ),
            onChanged: (RangeValues newRange) {
              setState(() {
                currentRange = newRange;
              });
              widget.onChanged(newRange);
            },
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Min price: ₹${currentRange.start.toInt()}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                'Max price: ₹${currentRange.end.toInt()}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
