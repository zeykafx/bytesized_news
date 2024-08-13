import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  @observable
  FirebaseAuth auth = FirebaseAuth.instance;

  @observable
  User? user;

  _AuthStore() {
    user = auth.currentUser;
    print("User: $user");
  }
}
