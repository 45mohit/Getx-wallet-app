import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_app/model/transaction_model.dart';

class TransactionController extends GetxController {
  //list of transactions
  var transaction = <Transaction>[].obs;

  @override
  void onInit() {
    List? storedTransactions = GetStorage().read<List>('transaction');

    if (storedTransactions != null) {
      transaction =
          storedTransactions.map((e) => Transaction.fromJson(e)).toList().obs;
      print(transaction);
    }
    ever(transaction, (_) {
      GetStorage().write('transaction', transaction.toList());
    });
    super.onInit();
  }
}
