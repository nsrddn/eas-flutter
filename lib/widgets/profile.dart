import 'package:app/services/user_services.dart';
import 'package:app/widgets/auth/signin.dart';
import 'package:flutter/material.dart';

class ProfileAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppbar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text("Profil"));
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _services = UserServices();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _user = {};

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
  }

  void _getProfile() async {
    final user = await _services.getUserLogin();

    setState(() {
      _user = user;
      _nameController.text = user['name'];
      _emailController.text = user['email'];
    });
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final messenger = ScaffoldMessenger.of(context);
      final message = await _services.saveProfile(user: {'id': _user['id'], 'name': _nameController.text, 'email': _emailController.text});

      if (!mounted) return;

      messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _logout() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final message = await _services.logout();
    if (!context.mounted) return;

    navigator.pushReplacement(
      MaterialPageRoute(builder: (context) => Signin()),
    );
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Column(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(50),
              child: Image.asset('profile.jpg', width: 80),
            ),
          ),
          SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }

                    if (value.length < 3) {
                      return 'Nama minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 1),
                TextButton.icon(
                  onPressed: _saveProfile,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                    fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
                    backgroundColor: Colors.blue,
                  ),
                  icon: Icon(Icons.save, color: Colors.white),
                  label: Text(
                    "Save Profile",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                TextButton.icon(
                  onPressed: _logout,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                    fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
                    backgroundColor: Colors.redAccent,
                  ),
                  icon: Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    "Keluar",
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
