import 'package:flutter/material.dart';

class SelectionTile extends StatelessWidget {
  final bool value;
  final bool active;
  final Widget title;
  final Widget? subtitle;
  final VoidCallback onTap;
  SelectionTile(
      {required this.value,
      required this.onTap,
      required this.title,
      this.subtitle,
      this.active = true});
  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      value: value,
      title: title,
      subtitle: subtitle,
      selected: value,
      groupValue: value ? value : !value,
      onChanged: active ? (v) => onTap() : null,
    );
  }
}
