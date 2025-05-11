import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scansplit/features/receipt/domain/models/receipt.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  final Receipt receipt;

  const ReceiptDetailsScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receipt.merchantName ?? 'Receipt Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Receipt image
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.file(File(receipt.imagePath), fit: BoxFit.contain),
            ),

            // Receipt details card
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderRow(
                      'Date',
                      _formatDate(receipt.transactionDate),
                    ),
                    const Divider(),
                    _buildHeaderRow(
                      'Merchant',
                      receipt.merchantName ?? 'Not specified',
                    ),
                    const Divider(),
                    _buildHeaderRow(
                      'Total Amount',
                      '\${receipt.totalAmount.toStringAsFixed(2)}',
                    ),
                    if (receipt.taxAmount != null) ...[
                      const Divider(),
                      _buildHeaderRow(
                        'Tax',
                        '\${receipt.taxAmount!.toStringAsFixed(2)}',
                      ),
                    ],
                    if (receipt.tipAmount != null) ...[
                      const Divider(),
                      _buildHeaderRow(
                        'Tip',
                        '\${receipt.tipAmount!.toStringAsFixed(2)}',
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Items section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Items list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: receipt.items.length,
                    itemBuilder: (context, index) {
                      final item = receipt.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle:
                              item.category != null
                                  ? Text('Category: ${item.category}')
                                  : null,
                          trailing: Text(
                            '\${item.price.toStringAsFixed(2)} ${item.quantity > 1 ? '× ${item.quantity}' : ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Split bill button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _splitBill(context),
                  icon: const Icon(Icons.group_add),
                  label: const Text('Split This Bill'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _splitBill(BuildContext context) {
    // Navigate to bill splitting screen
    // This is where you would implement your bill splitting logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Split bill functionality coming soon!')),
    );
  }
}
