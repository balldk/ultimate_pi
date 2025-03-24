import 'package:flutter/material.dart';

class PadButton extends StatelessWidget {
  final void Function(String) onPress;
  final String textValue;
  final bool useSecondColor;
  final bool disabled;

  const PadButton({
    required this.onPress,
    required this.textValue,
    this.useSecondColor = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ButtonTheme(
        height: 100.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor:
                disabled ? const Color.fromRGBO(33, 33, 33, 1.0) : Colors.black,
            foregroundColor: Colors.white, // Text/icon color
            textStyle: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w400,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
          ),
          onPressed:
              disabled
                  ? null // Automatically disables button when null
                  : () => onPress(textValue),
          child: Text(textValue),
        ),
      ),
    );
  }
}

class Pad extends StatelessWidget {
  final void Function(String) onPress;
  final bool disableClear;
  const Pad({required this.onPress, required this.disableClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                PadButton(onPress: onPress, textValue: '7'),
                PadButton(onPress: onPress, textValue: '8'),
                PadButton(onPress: onPress, textValue: '9'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                PadButton(onPress: onPress, textValue: '4'),
                PadButton(onPress: onPress, textValue: '5'),
                PadButton(onPress: onPress, textValue: '6'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                PadButton(onPress: onPress, textValue: '1'),
                PadButton(onPress: onPress, textValue: '2'),
                PadButton(onPress: onPress, textValue: '3'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                PadButton(onPress: this.onPress, textValue: '0'),
                PadButton(
                  onPress: this.onPress,
                  textValue: 'CLEAR',
                  useSecondColor: true,
                  disabled: disableClear,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
