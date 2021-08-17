import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_app/controller/transaction_controller.dart';
import 'package:money_app/model/transaction_model.dart';
import 'package:money_app/screens/home.dart';
import 'package:money_app/screens/subject.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';

class Amount extends StatefulWidget {
  final bool isTopup;
  const Amount({Key? key, required this.isTopup}) : super(key: key);

  @override
  _AmountState createState() => _AmountState();
}

class _AmountState extends State<Amount> {
  //Controllers for preserving the state
  final TransactionController transactionController = Get.find();
  final CurrentMoney controller = Get.find<CurrentMoney>();
  String amt = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      if (amt == '') amt = '0';
    });
  }

  onKeyTap(String val) {
    setState(() {
      amt = amt + val;
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController subjectController = TextEditingController();
    var actWidth = MediaQuery.of(context).size.width;
    var actHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffC0028A),
      body: SafeArea(
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
                "How Much?",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 45.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      String.fromCharCodes(new Runes('\u00A3 ')),
                      style: TextStyle(fontSize: 28, color: Colors.white),
                    ),
                  ),
                  Text(
                    amt,
                    style: TextStyle(color: Colors.white, fontSize: 54),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: actHeight / 9.5),
              child: NumericKeyboard(
                  onKeyboardTap: onKeyTap,
                  textColor: Colors.white,
                  rightButtonFn: () {
                    setState(() {
                      amt = amt.substring(0, amt.length - 1);
                    });
                  },
                  rightIcon: Icon(
                    Icons.backspace,
                    color: Colors.white,
                  ),
                  leftButtonFn: () {
                    amt = amt + ".";
                  },
                  leftIcon: Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 5,
                  ),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween),
            ),
            SizedBox(
              width: actWidth / 2,
              child: ElevatedButton(
                  onPressed: () {
                    //checking the conditions and values for Pay or Top Up
                    if (widget.isTopup) {
                      if (isNumeric(amt) && double.parse(amt) > 0) {
                        double amount = double.parse(amt);
                        amt = amount.toStringAsFixed(2);
                        transactionController.transaction.add(Transaction(
                            title: "Top Up", money: amt, date: DateTime.now()));

                        setState(() {
                          controller.currentMoney.value =
                              controller.currentMoney.value + double.parse(amt);
                        });

                        Get.offAll(() => HomePage());
                      } else {
                        Get.snackbar(
                            "Invalid Input", "Please Enter a valid Input");
                      }
                    } else {
                      if (isNumeric(amt) && double.parse(amt) > 0) {
                        double amount = double.parse(amt);
                        amt = amount.toStringAsFixed(2);
                        // print(amt);
                        if (amount <= controller.currentMoney.value) {
                          Get.to(() => Subject(
                                amt: amt,
                                subjectController: subjectController,
                              ));
                        } else {
                          Get.snackbar("Insufficent Balance",
                              "Please Refill your wallet to continue the payment");
                        }
                      } else {
                        Get.snackbar(
                            "Invalid Input", "Please Enter a valid Input");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xffDB7CC0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: Text(
                    widget.isTopup ? "Top Up" : "Next",
                    style: TextStyle(fontSize: 16),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
