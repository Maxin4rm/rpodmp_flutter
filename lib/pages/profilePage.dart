import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lab_2/pages/favoritesPage.dart';
import 'package:lab_2/pages/homePage.dart';
import 'package:lab_2/pages/loginPage.dart';

import '../user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addInfoController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final String? uid = UserController.user?.uid;

  @override
  void initState() {
    super.initState();
    loadProfileInfo();
  }

  Future<void> saveProfileInfo(String? key, String? value) async {
    FirebaseDatabase dbRef = FirebaseDatabase.instance;
    DatabaseReference databaseReference = dbRef.reference().child("AuthorizedUsers/$uid/$key");
    databaseReference.set(value);
  }

  Future<void> loadProfileInfo() async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('AuthorizedUsers/$uid');//aKBfiovTCtgvtjdTM84irT07fGq2
      DataSnapshot snapshot = await databaseReference.get();
      Map<dynamic, dynamic>? values = snapshot.value as Map?;

      User user = User(
          name: UserController.user?.displayName,
          nickname: values?['NickName'],
          email: UserController.user?.email,
          phoneNumber: values?['PhoneNumber'],
          addInfo: values?['AddInfo'],
          birthDate: values?['BirthDate'],
      );
      setState(() {
        nameController.text = (user.name == null) ? "" : user.name as String;
        nicknameController.text = (user.nickname == null) ? "" : user.nickname as String;
        emailController.text = (user.email == null) ? "" : user.email as String;
        phoneNumberController.text = (user.phoneNumber == null) ? "" : user.phoneNumber as String;
        addInfoController.text = (user.addInfo == null) ? "" : user.addInfo as String;
        birthDateController.text = (user.birthDate == null) ? "" : user.birthDate as String;

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
        title: const Text('Profile'),
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
              if (value == 'logout') {
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


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  readOnly: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
            child: Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: nicknameController,
                  decoration: const InputDecoration(
                    labelText: 'Nickname',
                  ),
                  readOnly: false,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
            child: Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  readOnly: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
            child: Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                  ),
                  readOnly: false,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
            child: Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: addInfoController,
                  decoration: const InputDecoration(
                    labelText: 'Additional information',
                  ),
                  readOnly: false,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
            child: Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: birthDateController,
                  decoration: const InputDecoration(
                    labelText: 'Birth date',
                  ),
                  readOnly: false,
                ),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                ),
                onPressed: () {
                  saveProfileInfo('NickName', nicknameController.text);
                  saveProfileInfo('PhoneNumber', phoneNumberController.text);
                  saveProfileInfo('AddInfo', addInfoController.text);
                  saveProfileInfo('BirthDate', birthDateController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Information saved successfully!'),
                      duration: Duration(seconds: 4),
                    ),
                  );
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ),
        ],
      ),
    );
  }
}
