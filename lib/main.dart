import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lab_2/pages/homePage.dart';
import 'package:lab_2/pages/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'lab_2',
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      routes: {
        //'/': (context) => const FirebaseStream(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
      },

      initialRoute: UserController.user != null ? '/home' : '/login',
    );
  }
}
/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MovieListPage(),
    );
  }
}

class MovieListPage extends StatelessWidget {
  final databaseReference = FirebaseDatabase.instance.reference().child('Movies');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
      ),
      body: FutureBuilder(
        future: databaseReference.once(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          databaseReference.once().then((DataSnapshot snapshot) {
            if (snapshot.value != null) {
              Map<dynamic, dynamic> values = snapshot.value;
              values.forEach((key, value) {
                String movieTitle = value['title'];
                String movieDescription = value['description'];
                print('Movie Title: $movieTitle');
                print('Description: $movieDescription');
              });
            } else {
              print('No data available');
            }
          } as FutureOr Function(DatabaseEvent value));

          List movies = [];
          Map<dynamic, dynamic> values = snapshot.data!.value;
          values.forEach((key, value) {
            movies.add({
              'title': value['title'],
              'description': value['description'],
            });
          });

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(movies[index]['name']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MovieDetailPage(movie: movies[index])),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class MovieDetailPage extends StatelessWidget {
  final Map<String, String> movie;
  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Movie Title: ${movie['title']}'),
            Text('Description: ${movie['description']}'),
            // Добавьте здесь другие детали о фильме
          ],
        ),
      ),
    );
  }
}
*/
