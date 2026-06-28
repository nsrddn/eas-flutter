import 'package:app/services/user_services.dart';
import 'package:app/widgets/auth/signin.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final services = UserServices();

    void logout() async {
      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);

      final message = await services.logout();
      if (!context.mounted) return;

      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => Signin()),
      );
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }

    return AppBar(
      title: Text("Beranda"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: logout,
            style: IconButton.styleFrom(backgroundColor: Colors.red),
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _services = UserServices();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.green[400],
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 8,
                  offset: Offset(4, 8),
                ),
              ],
            ),
            child: FutureBuilder(
              future: _services.getUserLogin(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat Datang, ${user['name']}",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      Text(
                        "apa kabar hari ini?",
                        style: TextStyle(fontSize: 12, color: Colors.grey[200]),
                      ),
                    ],
                  );
                }

                return Text("Gagal Memuat");
              },
            ),
          ),
        ],
      ),
    );
  }
}
