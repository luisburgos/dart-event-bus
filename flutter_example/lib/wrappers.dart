import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'package:neopop/utils/color_utils.dart';

import 'constants.dart';

class NeoPopElevatedStrokesButtonWrapper extends StatelessWidget {
  const NeoPopElevatedStrokesButtonWrapper({
    Key? key,
    required this.title,
    required this.color,
    required this.onTapUp,
  }) : super(key: key);

  final String title;
  final Color color;
  final Function() onTapUp;

  @override
  Widget build(BuildContext context) {
    return NeoPopButton(
      color: kSecondaryButtonLightColor,
      bottomShadowColor: ColorUtils.getVerticalShadow(color).toColor(),
      rightShadowColor: ColorUtils.getHorizontalShadow(color).toColor(),
      animationDuration: kButtonAnimationDuration,
      depth: kButtonDepth,
      onTapUp: onTapUp,
      border: Border.all(
        color: color,
        width: kButtonBorderWidth,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
