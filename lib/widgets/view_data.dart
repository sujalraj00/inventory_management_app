// import 'package:flutter/material.dart';
// import 'package:inventory_statocart/models/product_model.dart';
//
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Google Sheets API Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const SheetDataScreen(),
//     );
//   }
// }
//
// class SheetDataScreen extends StatefulWidget {
//   const SheetDataScreen({super.key});
//
//   @override
//   State<SheetDataScreen> createState() => _SheetDataScreenState();
// }
//
// class _SheetDataScreenState extends State<SheetDataScreen> {
//   late Future<List<SheetData>> futureSheetData;
//   List<SheetData> sheetData = [];
//   List<SheetData> filteredData = [];
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     futureSheetData = SheetApi().fetchSheetData();
//     futureSheetData.then((data) {
//       setState(() {
//         sheetData = data;
//         filteredData = data;
//       });
//     }).catchError((error) {
//       // Display the error message in the UI
//       setState(() {
//         sheetData = [];
//         filteredData = [];
//       });
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Error'),
//           content: Text(error.toString()),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   void filterSearchResults(String query) {
//     List<SheetData> dummySearchList = [];
//     dummySearchList.addAll(sheetData);
//     if (query.isNotEmpty) {
//       List<SheetData> dummyListData = [];
//       dummySearchList.forEach((item) {
//         if (item.sku.contains(query) || item.productName.toLowerCase().contains(query.toLowerCase())) {
//           dummyListData.add(item);
//         }
//       });
//       setState(() {
//         filteredData.clear();
//         filteredData.addAll(dummyListData);
//       });
//       return;
//     } else {
//       setState(() {
//         filteredData.clear();
//         filteredData.addAll(sheetData);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Google Sheets Data'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: (value) {
//                 filterSearchResults(value);
//               },
//               controller: searchController,
//               decoration: const InputDecoration(
//                 labelText: "Search",
//                 hintText: "Search by SKU or Product Name",
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<SheetData>>(
//               future: futureSheetData,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No data found'));
//                 } else {
//                   return ListView.builder(
//                     itemCount: filteredData.length,
//                     itemBuilder: (context, index) {
//                       final item = filteredData[index];
//                       return ListTile(
//                         title: Text(item.productName),
//                         subtitle: Text('SKU: ${item.sku} \nPrice: ${item.salePrice}'),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:inventory_statocart/models/product_model.dart';


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
                      // return ListTile(
                      //   title: Text(item.productName),
                      //   subtitle: Text('SKU: ${item.sku} \nPrice: ${item.salePrice}'),
                      // );
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
                          Text('Quantity: ${item.quantity}' )
                        ],
                      )
                      // Assuming you have a stock field
                      // Add more fields as necessary
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