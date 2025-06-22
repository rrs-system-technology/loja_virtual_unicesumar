import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/controllers.dart';
import '../models/models.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      final box = GetStorage();
      final userJson = box.read('usuario');

      if (userJson != null) {
        final user = UserModel.fromJson(jsonDecode(userJson));
        Get.find<UserController>().user.value = user;
        Get.find<AuthController>().logado.value = true;

        Get.find<FavoritosController>().loadFavoritosForUser(user.id);
        Get.find<CartController>().loadCartForUser(user.id);
        Get.find<OrderController>().fetchOrdersForUser(user.id);

        Get.offAllNamed('/'); // navega para a MainNavigationPage
      } else {
        Get.offAllNamed('/login');
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
