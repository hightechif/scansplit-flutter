import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scansplit/features/receipt/domain/models/receipt.dart';
import 'package:uuid/uuid.dart';

class ReceiptReviewScreen extends StatefulWidget {
  final String imagePath;
  final VoidCallback onRetake;
  final Function(Receipt receipt) onAccept;

  const ReceiptReviewScreen({
    super.key,
    required this.imagePath,
    required this.onRetake,
    required this.onAccept,
  });

  @override
  State<ReceiptReviewScreen> createState() => _ReceiptReviewScreenState();
}

class _ReceiptReviewScreenState extends State<ReceiptReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _merchantController;
  late TextEditingController _totalController;
  late TextEditingController _taxController;
  late TextEditingController _tipController;
  late DateTime _transactionDate;

  @override
  void initState() {
    super.initState();
    _merchantController = TextEditingController();
    _totalController = TextEditingController();
    _taxController = TextEditingController();
    _tipController = TextEditingController();
    _transactionDate = DateTime.now();
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _totalController.dispose();
    _taxController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null && picked != _transactionDate) {
      setState(() {
        _transactionDate = picked;
      });
    }
  }

  void _createReceipt() {
    if (_formKey.currentState!.validate()) {
      // Create a receipt with initial empty items list
      // In a real app, you might want to extract this information from the image
      final receipt = Receipt(
        id: const Uuid().v4(),
        merchantName:
            _merchantController.text.isEmpty ? null : _merchantController.text,
        transactionDate: _transactionDate,
        totalAmount: double.tryParse(_totalController.text) ?? 0.0,
        taxAmount:
            _taxController.text.isEmpty
                ? null
                : double.tryParse(_taxController.text),
        tipAmount:
            _tipController.text.isEmpty
                ? null
                : double.tryParse(_tipController.text),
        imagePath: widget.imagePath,
        items: [
          // Add a default item - in a real app you'd use OCR to extract items
          ReceiptItem(
            id: const Uuid().v4(),
            name: "Receipt Total",
            price: double.tryParse(_totalController.text) ?? 0.0,
          ),
        ],
      );

      widget.onAccept(receipt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Receipt'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => back(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image preview (smaller now to make room for form)
              SizedBox(
                height: 200,
                child: Center(
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Receipt information form
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Receipt Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Merchant name
                    TextFormField(
                      controller: _merchantController,
                      decoration: const InputDecoration(
                        labelText: 'Merchant Name (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.storefront),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date picker
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${_transactionDate.day}/${_transactionDate.month}/${_transactionDate.year}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Total amount
                    TextFormField(
                      controller: _totalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Total Amount',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter total amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Optional fields
                    Row(
                      children: [
                        // Tax amount
                        Expanded(
                          child: TextFormField(
                            controller: _taxController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Tax (Optional)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.receipt),
                            ),
                            validator: (value) {
                              if (value != null &&
                                  value.isNotEmpty &&
                                  double.tryParse(value) == null) {
                                return 'Invalid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Tip amount
                        Expanded(
                          child: TextFormField(
                            controller: _tipController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Tip (Optional)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.volunteer_activism),
                            ),
                            validator: (value) {
                              if (value != null &&
                                  value.isNotEmpty &&
                                  double.tryParse(value) == null) {
                                return 'Invalid number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Retake button
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retake'),
                        onPressed: widget.onRetake,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Use this receipt button
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('Create Receipt'),
                        onPressed: _createReceipt,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void back() {
    if (context.canPop()) {
      context.pop();
    } else {
      // Handle case where there's nothing to pop
      context.go('/home');
    }
  }

}
