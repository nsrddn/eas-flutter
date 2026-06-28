import 'package:app/widgets/layout.dart';
import 'package:app/widgets/receipt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CartAppbar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text("Keranjang"));
  }
}

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<StatefulWidget> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int _discount = 0;
  double _bayar = 0;

  @override
  Widget build(BuildContext context) {
    final cartNotif = context.watch<CartNotif>();
    final items = cartNotif.items;
    double subtotal = cartNotif.length > 0
        ? items
              .map((item) => item['price'] * item['qty'])
              .reduce((a, b) => a + b)
        : 0;

    double total = (subtotal - (subtotal * (_discount / 100)));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Image.network(
                        items[index]['image'],
                        height: 80,
                        width: 80,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[index]['title'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(height: 6),
                            Text(
                              "\$${items[index]['price']}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: true,
                            ),
                            SizedBox(height: 6),
                            Row(
                              spacing: 10,
                              children: [
                                IconButton(
                                  onPressed: () => context
                                      .read<CartNotif>()
                                      .incrementAndDecrement(
                                        items[index]['id'],
                                        'decrement',
                                      ),
                                  style: IconButton.styleFrom(
                                    fixedSize: Size(4, 4),
                                    backgroundColor: Colors.blue,
                                  ),
                                  icon: Icon(
                                    Icons.remove,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                Text("${items[index]['qty']}"),
                                IconButton(
                                  onPressed: () => context
                                      .read<CartNotif>()
                                      .incrementAndDecrement(
                                        items[index]['id'],
                                        'increment',
                                      ),
                                  style: IconButton.styleFrom(
                                    fixedSize: Size(4, 4),
                                    backgroundColor: Colors.blue,
                                  ),
                                  icon: Icon(
                                    Icons.add,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<CartNotif>().removeFromCart(
                            items[index]['id'],
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Berhasil menghapus item")),
                          );
                        },
                        icon: Icon(Icons.cancel, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Subtotal"),
                Text("\$${subtotal.toStringAsFixed(2)}"),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Discount"),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _discount = int.parse(value);
                      });
                    },
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                Text("%"),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Total"), Text("\$${total.toStringAsFixed(2)}")],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Column(
              spacing: 18,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _bayar = double.parse(value);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "\$0.00",
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: Icon(Icons.money, color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (total > _bayar || items.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Nominal Kurang")));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Receipt(
                            order: {
                              'items': items,
                              'discount': _discount,
                              'subtotal': subtotal,
                              'total': total,
                              'bayar': _bayar,
                            },
                          ),
                        ),
                      );
                      context.read<CartNotif>().removeFromCart(0);
                      setState(() {
                        _bayar = 0;
                        _discount = 0;
                      });
                    }
                  },
                  style: TextButton.styleFrom(
                    fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    "Bayar",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
