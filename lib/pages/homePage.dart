import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lab_2/pages/favoritesPage.dart';
import 'package:lab_2/pages/loginPage.dart';
import 'package:lab_2/pages/movieDetail.dart';
import 'package:lab_2/pages/profilePage.dart';

import '../movieItem.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MovieItem> movieItems = [];
  String searchText = '';


  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('Movies');
      DataSnapshot snapshot = await databaseReference.get();

      List<MovieItem> items = [];
      Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(snapshot.value as dynamic);
      values.forEach((key, value) {
        items.add(MovieItem(
          id: key.toString(),
          title: value['title'],
          description: value['description'],
        ));
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
    //final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Movies list'),
        backgroundColor: Colors.purple,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem(
                  value: 'favorites',
                  child: Text('Favorites'),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 'profile') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ));
              } else if (value == 'logout') {
                await UserController.signOut();
                if (mounted) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ));
                }
              } else if (value == 'favorites') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const FavoritesPage(),
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
                      .where((movieItem) => movieItem.title.toLowerCase().contains(searchText.toLowerCase()))
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

  Widget buildMovieItem(MovieItem movieItem) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => MovieDetail(movieItem: movieItem)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          movieItem.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}