import 'package:bytesized_news/views/auth/auth.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/keywords_bottom_sheet.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController textEditingController = TextEditingController();
  late AuthStore authStore;

  @override
  void initState() {
    super.initState();
    authStore = context.read<AuthStore>();
    user = auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      auth: auth,
      avatar: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 10),
          Text(user?.email ?? "No Email", style: const TextStyle(fontSize: 20)),
        ],
      ),
      showDeleteConfirmationDialog: true,
      actions: [
        SignedOutAction((context) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const Auth(),
            ),
            (route) => false, // remove all routes
          );
        }),
      ],
      children: [
        Container(
          padding: const EdgeInsets.only(top: 16.0, bottom: 10.0, left: 0.0),
          child: Text(
            "General User Settings",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        KeywordsBottomSheet(
            getKeywords: () {
              return authStore.userInterests;
            },
            title: "News Interests",
            additionCallback: (String text) {
              authStore.userInterests = [
                ...authStore.userInterests,
                text,
              ];
              // Update in firestore
              FirebaseFirestore.instance.doc("/users/${user!.uid}").update({
                "interests": authStore.userInterests,
              });
            },
            removalCallback: (int index) {
              authStore.userInterests = [
                ...authStore.userInterests..removeAt(index),
              ];
              // Update in firestore
              FirebaseFirestore.instance.doc("/users/${user!.uid}").update({
                "interests": authStore.userInterests,
              });
            }),
        const Divider(thickness: 0.5),
      ],
    );
  }
}
