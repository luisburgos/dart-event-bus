import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';

import 'constants.dart';

class Footer extends StatelessWidget {
  const Footer({
    Key? key,
    required this.titleA,
    required this.titleB,
    required this.onFireATap,
    required this.onFireBTap,
  }) : super(key: key);

  final String titleA;
  final String titleB;
  final Function() onFireATap;
  final Function() onFireBTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: FooterButton(
            title: titleA,
            onTapUp: onFireATap,
          ),
        ),
        Expanded(
          child: FooterButton(
            title: titleB,
            onTapUp: onFireBTap,
          ),
        ),
      ],
    );
  }
}

class FooterButton extends StatelessWidget {
  const FooterButton({
    Key? key,
    required this.title,
    required this.onTapUp,
  }) : super(key: key);

  final String title;
  final Function() onTapUp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: NeoPopButton(
        color: const Color.fromRGBO(0, 0, 0, 1),
        border: const Border.fromBorderSide(
          BorderSide(color: kBorderColorWhite, width: kButtonBorderWidth,),
        ),
        onTapUp: onTapUp,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 15.0,
            ),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
