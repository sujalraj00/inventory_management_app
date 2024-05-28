import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_statocart/models/product_model.dart';


class SoldDataScreen extends StatelessWidget {
  final SoldItem? soldItem;

  const SoldDataScreen({super.key, this.soldItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sold Product Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: soldItem != null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Name: ${soldItem!.productName}'),
            Text('SKU: ${soldItem!.sku}'),
            Text('Sale Price: ${soldItem!.salePrice}'),
            Text('Quantity Sold: ${soldItem!.quantitySold}'),
            Text('Date: ${soldItem!.dateTime.toLocal().toString().split(' ')[0]}'),
            Text('Time: ${soldItem!.dateTime.toLocal().toString().split(' ')[1]}'),
          ],
        )
            : const Center(
          child: Text('No sold item data available'),
        ),
      ),
    );
  }
}