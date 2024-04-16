import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lab_2/pages/homePage.dart';
import 'package:lab_2/pages/loginPage.dart';
import 'package:lab_2/pages/profilePage.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final String? uid = UserController.user?.uid;
  List<String> movieItems = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('AuthorizedUsers/$uid/favorites');
      DataSnapshot snapshot = await databaseReference.get();
      Map<dynamic, dynamic>? values = snapshot.value as Map?;

      List<String> items = [];
      values?.forEach((key, value) {
        items.add(value);
      });
      setState(() {
        movieItems = items;
      });
    } catch (e) {
      print('Error loading card items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.purple,
        leading: IconButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
        },
        icon: const Icon(
          Icons.arrow_back_ios,
        ),
      ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 'logout') {
                await UserController.signOut();
                if (mounted) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ));
                }
              } else if (value == 'profile') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ));
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child:Column(
            children: [
              Expanded(
                child: ListView(
                  children: movieItems
                      .where((movieItem) => movieItem.toLowerCase().contains(searchText.toLowerCase()))
                      .map((movieItem) {
                    return buildMovieItem(movieItem);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMovieItem(String movieItem) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          movieItem,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}