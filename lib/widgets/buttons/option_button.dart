import 'package:flutter/material.dart';

@immutable
class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key, 
    this.onPressed, 
    required this.icon, 
    required this.tag
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final Object tag;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: tag,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      onPressed: onPressed,
      child: icon
    );
  }
}
