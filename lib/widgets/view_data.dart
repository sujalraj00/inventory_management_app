import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_statocart/models/product_model.dart';
import 'package:inventory_statocart/navigation_bar.dart';
import 'package:inventory_statocart/widgets/today_sale.dart';

class SheetDataScreen extends StatefulWidget {
  const SheetDataScreen({super.key});

  @override
  State<SheetDataScreen> createState() => _SheetDataScreenState();
}

class _SheetDataScreenState extends State<SheetDataScreen> {
  late Future<List<SheetData>> futureSheetData;
  List<SheetData> sheetData = [];
  List<SheetData> filteredData = [];
  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    futureSheetData = SheetApi().fetchSheetData();
    futureSheetData.then((data) {
      setState(() {
        sheetData = data;
        filteredData = data;
      });
    }).catchError((error) {
      setState(() {
        sheetData = [];
        filteredData = [];
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<SheetData> dummyListData = [];
      sheetData.forEach((item) {
        if (item.sku.contains(query) || item.productName.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredData = dummyListData;
      });
    } else {
      setState(() {
        filteredData = sheetData;
      });
    }
  }

  void handleSale(SheetData item, String quantitySold) {
    print('handleSale called with quantity: $quantitySold');
    if (quantitySold.isNotEmpty && int.tryParse(quantitySold) != null) {
      final int soldQuantity = int.parse(quantitySold);
      final now = DateTime.now();
      final soldItem = SoldItem(
        productName: item.productName,
        sku: item.sku,
        salePrice: item.salePrice,
        quantitySold: soldQuantity,
        dateTime: now,
      );

      print('SoldItem created: $soldItem');

      final navigationController = Get.find<NavigationController>();
      navigationController.navigateToSoldDataScreen(soldItem);

      final sheetApi = Get.find<SheetApi>();
      sheetApi.logSale(soldItem).then((_) {
        print('Sale logged successfully');
      }).catchError((error) {
        print('Error logging sale: $error');
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please enter a valid quantity.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sheets Data'),
      ),
      body: FutureBuilder<List<SheetData>>(
        future: futureSheetData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: "Search",
                      hintText: "Search by SKU or Product Name",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
                       final quantityController = TextEditingController();

                      return Card(
                        margin: const EdgeInsets.all(7.0),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text('SKU: ${item.sku}'),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Text('Sale Price: ${item.salePrice}'),
                                  const SizedBox(width: 12),
                                  Text('Quantity: ${item.quantity}'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Quantity Sold',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 5),
                              ElevatedButton(
                                onPressed: () {
                                  handleSale(item, quantityController.text);
                                },
                                child: const Text('Log Sale'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}


