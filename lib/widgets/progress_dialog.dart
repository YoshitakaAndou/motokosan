import 'package:flutter/material.dart';

// showDialog(
//   barrierDismissible: false,
//   context: context,
//   builder: (BuildContext context) => ProgressDialog(
//   status: "読み込み中",),
// );

class ProgressDialog extends StatelessWidget {
  final String status;
  ProgressDialog({this.status});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.deepOrange)),
              SizedBox(width: 25.0),
              Text(
                status,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
