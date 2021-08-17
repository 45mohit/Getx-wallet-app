import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_app/controller/transaction_controller.dart';
import 'package:money_app/model/transaction_model.dart';
import 'package:money_app/screens/home.dart';

class Subject extends StatefulWidget {
  final TextEditingController subjectController;
  final String amt;
  const Subject({Key? key, required this.subjectController, required this.amt})
      : super(key: key);

  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  final TransactionController transactionController = Get.find();
  final CurrentMoney controller = Get.find<CurrentMoney>();
  @override
  Widget build(BuildContext context) {
    var actWidth = MediaQuery.of(context).size.width;
    var actHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffC0028A),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: actWidth - 30),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Icon(
                          Icons.close_rounded,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                  Center(
                      child: Text(
                    "MoneyApp",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: actHeight / 8),
                child: Text(
                  "To Who?",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 45.0),
                  child: SizedBox(
                    width: actWidth / 1.5,
                    child: TextField(
                        controller: widget.subjectController,
                        autofocus: true,
                        style: TextStyle(color: Colors.white, fontSize: 30),
                        textAlign: TextAlign.center,
                        cursorHeight: 36,
                        cursorColor: Colors.white,
                        maxLength: 15,
                        decoration: InputDecoration(
                          counterText: "",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        )),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: SizedBox(
                  width: actWidth / 2,
                  child: ElevatedButton(
                      onPressed: () {
                        if (widget.subjectController.text != '') {
                          transactionController.transaction.add(Transaction(
                              title: widget.subjectController.text,
                              money: widget.amt,
                              date: DateTime.now()));

                          setState(() {
                            controller.currentMoney.value =
                                controller.currentMoney.value -
                                    double.parse(widget.amt);
                          });

                          Get.offAll(() => HomePage());
                        } else {
                          Get.snackbar("Transaction Name = Null",
                              "Name of the Transaction must be provided.");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xffDB7CC0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        "Pay",
                        style: TextStyle(fontSize: 16),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
