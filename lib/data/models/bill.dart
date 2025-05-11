class Bill {
  final String id;
  final String title;
  final double totalAmount;
  final DateTime date;
  final String imageUrl;
  final List<BillItem> items;
  final List<BillSplit> splits;

  Bill({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.date,
    required this.imageUrl,
    required this.items,
    required this.splits,
  });
}

class BillItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  BillItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class BillSplit {
  final String userId;
  final String userName;
  final double amount;
  final bool isPaid;

  BillSplit({
    required this.userId,
    required this.userName,
    required this.amount,
    this.isPaid = false,
  });
}