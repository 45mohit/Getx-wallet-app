class Transaction {
  String title;
  String money;
  DateTime date;

  Transaction({required this.title, required this.money, required this.date});

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
      title: json['title'],
      money: json['money'],
      date: DateTime.parse(json['date']));

  Map<String, dynamic> toJson() =>
      {'title': title, 'money': money, 'date': date.toIso8601String()};
}
