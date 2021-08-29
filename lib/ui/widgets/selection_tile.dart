import 'package:flutter/material.dart';

class SelectionTile extends StatelessWidget {
  final bool value;
  final bool active;
  final Widget title;
  final Widget? subtitle;
  final VoidCallback onTap;
  final Widget? traling;
  SelectionTile(
      {required this.value,
      required this.onTap,
      required this.title,
      this.traling,
      this.subtitle,
      this.active = true});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RadioListTile(
          secondary: traling,
          value: value,
          title: title,
          subtitle: subtitle,
          selected: value,
          groupValue: value ? value : !value,
          onChanged: active ? (v) => onTap() : null,
        ),
        active
            ? SizedBox()
            : Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                right: 0,
                child: Material(
                  color: Colors.white.withOpacity(0.3),
                ),
              )
      ],
    );
  }
}
