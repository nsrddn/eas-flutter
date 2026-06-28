import 'package:app/services/product_services.dart';
import 'package:app/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final services = ProductServices();

    return Scaffold(
      appBar: AppBar(title: Text("Detail Produk")),
      body: FutureBuilder(
        future: services.getProductByid(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Expanded(child: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.hasData) {
            final product = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    product['image'],
                    height: 240,
                    width: double.infinity,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            product['category'],
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, color: Colors.yellow),
                                  Text(
                                    "${product['rating']['rate']} (${product['rating']['count']} reviews)",
                                  ),
                                ],
                              ),
                              Text(
                                "\$${product['price']}",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Deskripsi Produk",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            product['description'],
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      context.read<CartNotif>().saveToCart({
                        'id': product['id'],
                        'image': product['image'],
                        'title': product['title'],
                        'price': product['price'],
                        'qty': 1,
                      });

                      if (!context.mounted) return;

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(Icons.check, color: Colors.white),
                              ),
                              Text(
                                "Berhasil ditambahkan",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Oke"),
                            ),
                          ],
                        ),
                      );
                    },
                    label: Text(
                      "Tambah Ke Keranjang",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                  SizedBox(height: 18),
                ],
              ),
            );
          }

          return Text("Gagal Memuat");
        },
      ),
    );
  }
}
