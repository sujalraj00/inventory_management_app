import 'dart:convert';
import 'package:http/http.dart' as http;

class SheetData {
  final String sku;
  final String productName;
  final int salePrice;
  final int quantity;

  SheetData({
    required this.sku,
    required this.productName,
    required this.salePrice,
    required this.quantity,
  });

  factory SheetData.fromJson(Map<String, dynamic> json) {
    return SheetData(
      sku: json['SKU'],
      productName: json['PRODUCT_NAME'],
      salePrice: json['SALE_PRICE'],
      quantity: json['QUANTITY'],
    );
  }
}

class SoldItem {
  final String sku;
  final String productName;
  final int salePrice;
  final int quantitySold;
  final DateTime dateTime;

  SoldItem({
    required this.sku,
    required this.productName,
    required this.salePrice,
    required this.quantitySold,
    required this.dateTime,
  });
}

class SheetApi {
  final String apiUrl = 'https://script.google.com/macros/s/AKfycbzSIKw5Vjx_dKSngqW91x1MFxjOTyItUKl9-m5XShiufMQ_-cRekey7CFPeooXxolEp/exec';

  Future<List<SheetData>> fetchSheetData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          return jsonData.map<SheetData>((json) => SheetData.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> logSale(SoldItem soldItem) async {
    try {
      final dateStr = soldItem.dateTime.toLocal().toString().split(' ')[0];
      final sheetName = '${soldItem.sku.startsWith('sc') ? 'SC' : 'PC'}_$dateStr';

      final body = jsonEncode({
        'sheetName': sheetName,
        'data': {
          'SKU': soldItem.sku,
          'PRODUCT_NAME': soldItem.productName,
          'SALE_PRICE': soldItem.salePrice,
          'QUANTITY_SOLD': soldItem.quantitySold,
          'DATE': soldItem.dateTime.toLocal().toString().split(' ')[0],
          'TIME': soldItem.dateTime.toLocal().toString().split(' ')[1],
        },
      });

      print('Sending POST request with body: $body');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        print('Sale logged successfully.');
      } else {
        throw Exception('Failed to log sale: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error logging sale: $e');
      throw Exception('Failed to log sale: $e');
    }
  }
}
