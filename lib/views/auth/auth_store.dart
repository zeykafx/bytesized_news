import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

enum Tier { free, premium }

abstract class _AuthStore with Store {
  @observable
  FirebaseAuth auth = FirebaseAuth.instance;

  @observable
  bool initialized = false;

  @observable
  User? user;

  @observable
  Tier userTier = Tier.free;

  @observable
  List<String> userInterests = defaultUserInterests;

  _AuthStore() {
    user = auth.currentUser;
  }

  Future<void> init() async {
    if (user == null) {
      initialized = true;
      return;
    }
    var userData =
        await FirebaseFirestore.instance.doc("/users/${user!.uid}").get();
    if (userData["tier"] != null) {
      if (userData["tier"] == "premium") {
        userTier = Tier.premium;
      }
    }

    if (userData["interests"] != null) {
      List<String> interests = [];
      for (String interest in userData["interests"]) {
        interests.add(interest);
      }
      userInterests = interests;
    }

    initialized = true;
  }

  static const defaultUserInterests = [
    "Technology",
    "Politics",
  ];
}
