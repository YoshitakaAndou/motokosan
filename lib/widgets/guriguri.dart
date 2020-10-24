import 'package:flutter/material.dart';

class GuriGuri {
  static final GuriGuri instance = GuriGuri();

  Widget guriguri(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 230,
      width: MediaQuery.of(context).size.width,
      color: Colors.black87.withOpacity(0.8),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget guriguri2(BuildContext context) {
    return Container(
      color: Colors.black87.withOpacity(0.8),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget guriguri3(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black87.withOpacity(0.8),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
