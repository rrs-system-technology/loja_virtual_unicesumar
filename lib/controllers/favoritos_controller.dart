import 'package:get/get.dart';

import '../repository/repository.dart';

class FavoritosController extends GetxController {
  final FavoritosRepository favoritosRepository;

  FavoritosController({required this.favoritosRepository});

  final RxList<int> favoritos = <int>[].obs;

  int userId = 1; // ajustar para pegar do UserController se precisar

  @override
  void onInit() {
    super.onInit();
    _loadFavoritos();
  }

  Future<void> _loadFavoritos() async {
    final favoritosData = await favoritosRepository.getFavoritosByUserId(userId);
    favoritos.assignAll(favoritosData.map((fav) => fav['product_id'] as int));
  }

  Future<void> toggleFavorito(int productId) async {
    if (favoritos.contains(productId)) {
      await favoritosRepository.removeFavorito(userId, productId);
      favoritos.remove(productId);
    } else {
      await favoritosRepository.addFavorito(
        userId,
        productId,
        DateTime.now().toIso8601String(),
      );
      favoritos.add(productId);
    }
  }

  bool isFavorito(int productId) {
    return favoritos.contains(productId);
  }

  bool isFavoritoSync(int productId) {
    return favoritos.contains(productId);
  }
}
