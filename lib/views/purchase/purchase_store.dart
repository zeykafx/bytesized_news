import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'purchase_store.g.dart';

class PurchaseStore = _PurchaseStore with _$PurchaseStore;

abstract class _PurchaseStore with Store {
  @observable
  late AuthStore authStore;

  @observable
  bool loading = false;

  @observable
  bool hasAlert = false;

  @observable
  String alertMessage = "";

  @action
  Future<void> initIAP(AuthStore aStore) async {
    authStore = aStore;
  }

  @action
  Future<void> restorePurchase(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("In-app purchases are not available in this version.")),
    );
  }
}
