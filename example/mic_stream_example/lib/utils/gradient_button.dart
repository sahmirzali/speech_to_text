import 'package:flutter/material.dart';

import '../utils.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const GradientButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    this.height,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(SizeConfig.size16,0,SizeConfig.size16,0),
      width: width,
      height: height,

      decoration: BoxDecoration(
          borderRadius:  BorderRadius.all(Radius.circular(SizeConfig.size25)),

          gradient: gradient, boxShadow: [
        BoxShadow(
          color: Colors.grey[500],
          offset: Offset(0.0, 1.5),
          blurRadius: 1.5,
        ),
      ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}