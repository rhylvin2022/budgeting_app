part of swagger.api;

class LogItem {
  bool? expense;
  String? date;
  String? category;
  String? title;
  String? currency;
  String? remarks;
  int? amount;

  LogItem();

  @override
  String toString() {
    return 'LogItem[expense=$expense, date=$date, category=$category, title=$title, currency=$currency, remarks=$remarks, amount=$amount]';
  }

  LogItem.fromJson(Map<String, dynamic> json) {
    expense = json['expense'];
    date = json['date'];
    category = json['category'];
    title = json['title'];
    currency = json['currency'];
    remarks = json['remarks'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    return {
      'expense': expense,
      'date': date,
      'category': category,
      'title': title,
      'currency': currency,
      'remarks': remarks,
      'amount': amount
    };
  }

  static List<LogItem> listFromJson(List<dynamic> json) {
    return json == null
        ? <LogItem>[]
        : json.map((value) => LogItem.fromJson(value)).toList();
  }

  static Map<String, LogItem> mapFromJson(
      Map<String, Map<String, dynamic>> json) {
    var map = <String, LogItem>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((String key, Map<String, dynamic> value) =>
          map[key] = LogItem.fromJson(value));
    }
    return map;
  }
}
