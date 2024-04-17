//import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lab_2/pages/favoritesPage.dart';
import 'package:lab_2/pages/loginPage.dart';
import 'package:lab_2/pages/profilePage.dart';
import '../movieItem.dart';


class MovieDetail extends StatefulWidget {
  final MovieItem movieItem;

  const MovieDetail({super.key, required this.movieItem});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  final String? uid = UserController.user?.uid;
  List<String> imageUrls = [];
  bool isFavorited = false;

  void getImageUrls() async {
    String id = widget.movieItem.id;
    FirebaseStorage storage = FirebaseStorage.instance;



    var refer = storage.ref().child("images/$id");
    ListResult result = await refer.listAll();
    for (Reference ref in result.items) {
      String url = await ref.getDownloadURL();
      setState(() {
        imageUrls.add(url);
      });
    }
  }


  Future<bool> isMovieInFavorites(String movie) async{
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('AuthorizedUsers/$uid/favorites/$movie');//aKBfiovTCtgvtjdTM84irT07fGq2
    DataSnapshot snapshot = await databaseReference.get();
    Object? value = snapshot.value;
    if(value == null){
      return false;
    }
    return true;
  }

  Future<void> addToFavorites(MovieItem movie) async{
    FirebaseDatabase dbRef = FirebaseDatabase.instance;
    String id = movie.id;
    DatabaseReference databaseReference = dbRef.reference().child("AuthorizedUsers/$uid/favorites/$id");
    databaseReference.set(movie.title);
  }

  Future<void> removeFromFavorites(String movie) async{
    FirebaseDatabase dbRef = FirebaseDatabase.instance;
    DatabaseReference databaseReference = dbRef.reference().child("AuthorizedUsers/$uid/favorites/$movie");
    databaseReference.remove();
  }

  @override
  void initState() {
    super.initState();
    getImageUrls();
    if (mounted) {
      isMovieInFavorites(widget.movieItem.id).then((inFavorites) {
        setState(() {
          isFavorited = inFavorites;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.movieItem.title),
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
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CarouselSlider(
            options: CarouselOptions(height: 250.0),
            items: imageUrls.map((url) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child: Image.network(url, fit: BoxFit.cover),
              );
            }).toList(),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            child: Text(
              widget.movieItem.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),

            child: Text(widget.movieItem.description,
              style: TextStyle(fontSize: 16)
            ),
          ),

          ElevatedButton(
              onPressed: () {
                setState(() {
                  isFavorited = !isFavorited;

                  if (isFavorited) {
                    addToFavorites(widget.movieItem);
                  } else {
                    removeFromFavorites(widget.movieItem.id);
                  }
                });
              },

              child: isFavorited ? const Text("Remove from favorites", style: TextStyle(fontSize: 22)) : const Text("Add to favorites", style: TextStyle(fontSize: 22))
          ),
        ],
      ),

    );
  }
}
