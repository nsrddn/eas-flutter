import 'package:app/services/product_services.dart';
import 'package:app/widgets/product_details.dart';
import 'package:flutter/material.dart';

class ProductsAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ProductsAppbar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text("Produk"));
  }
}

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final _services = ProductServices();
  List _products = [];
  List _filteredProducts = [];
  Set _categories = {};

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final data = await _services.getProducts();
    setState(() {
      _products = data;
      _filteredProducts = data;
      _categories = data.map((item) => item['category']).toSet();
      _categories = {'all', ..._categories};
    });
  }

  void _changeCategory({String category = 'all'}) {
    setState(() {
      if (category == 'all') {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products
            .where(
              (product) =>
                  product['category'].toString().toLowerCase() ==
                  category.toLowerCase(),
            )
            .toList();
      }
    });
  }

  void _search(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products
            .where(
              (product) => product['title'].toString().toLowerCase().contains(
                keyword.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          TextField(
            onChanged: _search,
            decoration: InputDecoration(
              hintText: "Cari",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
              suffixIconColor: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: _categories
                  .map(
                    (category) => TextButton(
                      style: TextButton.styleFrom(
                        side: BorderSide(color: Colors.grey),
                      ),
                      onPressed: () => _changeCategory(category: category),
                      child: Text(category),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              itemCount: _filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisExtent: 250,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) => Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(),
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetails(id: _filteredProducts[index]['id']),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        _filteredProducts[index]['image'],
                        height: 140,
                        width: double.infinity,
                      ),
                      SizedBox(height: 10),
                      Text(
                        _filteredProducts[index]['title'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _filteredProducts[index]['category'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "\$${_filteredProducts[index]['price']}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
