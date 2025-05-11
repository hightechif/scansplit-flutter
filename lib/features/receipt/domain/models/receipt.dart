// lib/features/receipt/domain/models/receipt.dart
class Receipt {
  final String id;
  final String? merchantName;
  final DateTime transactionDate;
  final double totalAmount;
  final double? taxAmount;
  final double? tipAmount;
  final String imagePath;
  final List<ReceiptItem> items;
  final String? userId; // Null for local-only receipts

  Receipt({
    required this.id,
    this.merchantName,
    required this.transactionDate,
    required this.totalAmount,
    this.taxAmount,
    this.tipAmount,
    required this.imagePath,
    required this.items,
    this.userId,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      merchantName: json['merchantName'],
      transactionDate: DateTime.parse(json['transactionDate']),
      totalAmount: json['totalAmount'],
      taxAmount: json['taxAmount'],
      tipAmount: json['tipAmount'],
      imagePath: json['imagePath'],
      items: (json['items'] as List)
          .map((item) => ReceiptItem.fromJson(item))
          .toList(),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantName': merchantName,
      'transactionDate': transactionDate.toIso8601String(),
      'totalAmount': totalAmount,
      'taxAmount': taxAmount,
      'tipAmount': tipAmount,
      'imagePath': imagePath,
      'items': items.map((item) => item.toJson()).toList(),
      'userId': userId,
    };
  }
}

class ReceiptItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? category;

  ReceiptItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.category,
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'] ?? 1,
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'category': category,
    };
  }
}