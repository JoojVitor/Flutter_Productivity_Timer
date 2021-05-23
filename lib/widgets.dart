import 'package:flutter/material.dart';
typedef CallbackSetting = void Function(String, int);
class ProductivityButton extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final VoidCallback onPressed;

  ProductivityButton(
      {@required this.color,
      @required this.text,
      @required this.onPressed,
      this.size});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(text, style: TextStyle(color: Colors.white)),
      onPressed: onPressed,
      color: color,
      minWidth: (size != null)
          ? size
          : 0,
    );
  }
}

class SettingsButton extends StatelessWidget {
  final Color color;
  final String text;
  final int value;
  final String setting;
  final CallbackSetting callback;
  SettingsButton(this.color, this.text, this.value, this.setting, this.callback);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(text, style: TextStyle(color: Colors.white)),
      onPressed: () => callback(setting, value),
      color: color,
    );
  }
}
