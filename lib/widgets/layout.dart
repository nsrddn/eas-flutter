import 'package:app/widgets/cart.dart';
import 'package:app/widgets/home.dart';
import 'package:app/widgets/products.dart';
import 'package:app/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartNotif with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  int get length => _items.length;
  List<Map<String, dynamic>> get items => _items;

  void saveToCart(Map<String, dynamic> data) {
    final index = _items.indexWhere((item) => item['id'] == data['id']);

    index == -1 ? _items.add(data) : _items[index]['qty']++;

    notifyListeners();
  }

  void removeFromCart(int id) {
    _items = _items.where((item) => item['id'] != id).toList();
    if(id == 0) {
      _items = [];
    }
    notifyListeners();
  }

  void incrementAndDecrement(int id, String action) {
    _items = _items.map((item) {
      if (item['id'] == id) {
        if (item['qty'] > 1 && action == 'decrement') {
          item['qty']--;
        } else if (action == 'increment') {
          item['qty']++;
        }
      }

      return item;
    }).toList();
    notifyListeners();
  }
}

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _viewIndex = 0;

  final List<Map<String, dynamic>> _views = [
    {'appbar': const HomeAppBar(), 'body': const Home()},
    {'appbar': const ProductsAppbar(), 'body': const Products()},
    {'appbar': const CartAppbar(), 'body': const Cart()},
    {'appbar': const ProfileAppbar(), 'body': const Profile()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _views[_viewIndex]['appbar'],
      body: _views[_viewIndex]['body'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _viewIndex = value;
          });
        },
        currentIndex: _viewIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Produk"),
          BottomNavigationBarItem(
            icon: context.watch<CartNotif>().length > 0
                ? Badge(
                    label: Text("${context.watch<CartNotif>().length}"),
                    child: Icon(Icons.shopping_cart),
                  )
                : Icon(Icons.shopping_cart),
            label: "Keranjang",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
