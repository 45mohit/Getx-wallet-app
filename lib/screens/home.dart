import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:money_app/controller/transaction_controller.dart';
import 'package:money_app/screens/amount.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isTopup = false;
  //controller for the current Balance
  final controller = Get.put(CurrentMoney());
  //Transaction controller
  final TransactionController transactionController =
      Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    //to make UI responsive for every device
    var actHeight = MediaQuery.of(context).size.height;
    var actWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: actHeight / 3.5,
                  color: Color(0xffC0028A),
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                        "MoneyApp",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                      Padding(
                        padding: EdgeInsets.only(top: 45.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                String.fromCharCodes(new Runes('\u00A3')),
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ),
                            RichText(
                                text: TextSpan(
                                    text: controller.currentMoney.value
                                        .toStringAsFixed(0),
                                    style: GoogleFonts.montserrat(
                                        fontSize: 48, color: Colors.white),
                                    children: [
                                  TextSpan(
                                    text: ".",
                                    style: TextStyle(
                                        fontSize: 48, color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: controller.currentMoney.value
                                        .toStringAsFixed(2)
                                        .split('.')[1]
                                        .substring(0, 2),
                                    style: GoogleFonts.montserrat(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                ])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: SizedBox(height: 10),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Color(0xffF7F7F7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(top: 30.0, left: 25, right: 25),
                            child: Text(
                              "Recent Activity",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                          ),
                          GroupedListView<dynamic, String>(
                              shrinkWrap: true,
                              primary: false,
                              physics: NeverScrollableScrollPhysics(),
                              elements: transactionController.transaction,
                              groupBy: (t) {
                                //Grouping the list by Transaction Date
                                return (DateFormat('d').format(t.date) ==
                                        DateFormat('d').format(DateTime.now())
                                    ? 'TODAY'
                                    : (DateFormat('d').format(t.date) ==
                                            DateFormat('d').format(
                                                DateTime.now().subtract(
                                                    Duration(days: 1)))
                                        ? "YESTERDAY"
                                        : DateFormat('d MMMM').format(t.date)));
                              },
                              groupSeparatorBuilder: (String date) =>
                                  // Text(DateFormat('MMMM d').format(date)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25, top: 20.0, bottom: 4),
                                    child: Text(
                                      date,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                              order: GroupedListOrder.DESC,
                              itemBuilder: (context, element) {
                                return Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xffC0028A)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Icon(
                                          element.title == "Top Up"
                                              ? Icons.add_circle_outlined
                                              : Icons.shopping_bag,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                    title: Text(element.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    trailing: RichText(
                                        text: TextSpan(
                                            text: element.title == "Top Up"
                                                ? "+"
                                                : "",
                                            style: GoogleFonts.montserrat(
                                                color: element.title == "Top Up"
                                                    ? Color(0xffC0028A)
                                                    : Colors.black,
                                                fontSize: 24),
                                            children: [
                                          TextSpan(
                                            text: element.money.split('.')[0],
                                            style: GoogleFonts.montserrat(
                                                fontSize: 24),
                                          ),
                                          TextSpan(
                                            text: ".",
                                            style: TextStyle(),
                                          ),
                                          TextSpan(
                                            text: element.money.split('.')[1],
                                            style: GoogleFonts.montserrat(
                                                fontSize: 14),
                                          ),
                                        ])),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //Center Menu
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: actHeight / 2.5),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: actHeight / 8,
                    width: actWidth / 1.1,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (isTopup == true) {
                              setState(() {
                                isTopup = false;
                              });
                            } else {
                              setState(() {
                                isTopup = false;
                              });
                            }
                            Get.to(() => Amount(isTopup: isTopup));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                child: Image.asset('assets/images/pay.png',
                                    height: 60, fit: BoxFit.contain),
                              ),
                              Text("Pay"),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isTopup == false) {
                              setState(() {
                                isTopup = true;
                              });
                            } else {
                              setState(() {
                                isTopup = true;
                              });
                            }
                            print(isTopup);
                            Get.to(() => Amount(isTopup: isTopup));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                child: Image.asset('assets/images/add.png',
                                    height: 60, fit: BoxFit.contain),
                              ),
                              Text("Top Up"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CurrentMoney extends GetxController {
  var currentMoney = 150.0.obs;

  @override
  void onInit() {
    double? storedBalance = GetStorage().read('currentBalance');
    print("####$storedBalance");

    if (storedBalance != null) {
      currentMoney = storedBalance.obs;
    }
    ever(currentMoney, (_) {
      GetStorage()
          .write('currentBalance', double.parse(currentMoney.toString()));
    });
    super.onInit();
  }
}
