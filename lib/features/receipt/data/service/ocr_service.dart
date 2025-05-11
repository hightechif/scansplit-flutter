// import 'dart:io';
//
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:scansplit/features/receipt/domain/models/receipt.dart';
// import 'package:uuid/uuid.dart';
//
// // lib/features/receipt/data/services/ocr_service.dart
// class OCRService {
//   final _textRecognizer = TextRecognizer();
//   final _uuid = Uuid();
//
//   Future<Receipt> processImage(File imageFile) async {
//     final inputImage = InputImage.fromFile(imageFile);
//     final recognizedText = await _textRecognizer.processImage(inputImage);
//
//     final items = <ReceiptItem>[];
//     double total = 0;
//
//     for (final block in recognizedText.blocks) {
//       for (final line in block.lines) {
//         final text = line.text;
//         final possiblePrice = _extractPrice(text);
//
//         if (possiblePrice != null) {
//           items.add(
//             ReceiptItem(
//               id: _uuid.v4(),
//               name: text.replaceAll(possiblePrice.toString(), '').trim(),
//               price: possiblePrice,
//             ),
//           );
//           total += possiblePrice;
//         }
//       }
//     }
//
//     return Receipt(
//       id: _uuid.v4(),
//       items: items,
//       totalAmount: total,
//       transactionDate: DateTime.now(),
//       imagePath: imageFile.path,
//     );
//   }
//
//   double? _extractPrice(String text) {
//     final regExp = RegExp(r'(\d+\.\d{2})');
//     final match = regExp.firstMatch(text);
//     return match != null ? double.parse(match.group(1)!) : null;
//   }
//
//   void dispose() => _textRecognizer.close();
// }
