import 'package:flutter/material.dart';

class Receipt extends StatelessWidget {
  const Receipt({super.key, required this.order});

  final Map<String, dynamic> order;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final List items = order['items'];

    return Scaffold(
      appBar: AppBar(title: Text("Receipt")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(
              "Toko Jokowi",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Tanggal: "), Text("$now")],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey),
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: Column(
                spacing: 12,
                children: items
                    .map(
                      (item) => Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Text("x${item['qty']}"),
                          Text("\$${item['price'] * item['qty']}"),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Subtotal"), Text("\$${order['subtotal']}")],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Discount"), Text("${order['discount']}%")],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Total"), Text("\$${order['total'].toStringAsFixed(2)}")],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Bayar"), Text("\$${order['bayar'].toStringAsFixed(2)}")],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Kembalian"), Text("\$${(order['total'] - order['bayar']).toStringAsFixed(2)}")],
            ),
          ],
        ),
      ),
    );
  }
}
