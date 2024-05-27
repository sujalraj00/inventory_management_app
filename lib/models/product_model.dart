import 'dart:convert';
import 'package:http/http.dart' as http;

class SheetData {
  final String sku;
  final String productName;
  final int salePrice;
  final int quantity;

  SheetData({required this.sku, required this.productName, required this.salePrice, required this.quantity});

  factory SheetData.fromJson(Map<String, dynamic> json) {
    return SheetData(
      sku: json['SKU'],
      productName: json['PRODUCT_NAME'],
      salePrice: json['SALE_PRICE'],
      quantity: json['QUANTITY']
    );
  }
}

class SheetApi {
  final String apiUrl = 'https://script.google.com/macros/s/AKfycbxLA_GRsXvWYzVR_ud-93Y18Na4WvHvTV5ZHyAqUjVCN56OqXTThgtSim8GM6YKP4_X/exec'; // replace with your actual API URL

  Future<List<SheetData>> fetchSheetData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => SheetData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
