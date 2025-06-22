import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import './../repository/repository.dart';
import './../models/models.dart';
import 'controllers.dart';

class HomeController extends GetxController {
  final BannerRepository bannerRepository;
  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;

  HomeController({
    required this.bannerRepository,
    required this.categoryRepository,
    required this.productRepository,
  });

  final banners = <BannerModel>[].obs;
  final categories = <String>[].obs;
  final featuredProducts = <ProductModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final box = GetStorage();
    final userJson = box.read('usuario');

    if (userJson != null) {
      final user = UserModel.fromJson(jsonDecode(userJson));
      final userCtrl = Get.find<UserController>();
      userCtrl.user.value = user;
      Get.find<AuthController>().logado.value = true;

      Get.find<FavoritosController>().loadFavoritosForUser(user.id);
      Get.find<CartController>().loadCartForUser(user.id);
      Get.find<OrderController>().fetchOrdersForUser(user.id);
    }
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      /// Banners
      final bannersApi = await bannerRepository.getBanners();
      banners.assignAll(bannersApi);

      /// Categories
      final categoriesApi = await categoryRepository.fetchCategories();
      categories.assignAll(categoriesApi);

      /// Featured Products
      final productsApi = await productRepository.fetchProducts();
      featuredProducts.assignAll(productsApi.take(30).toList());
    } catch (e) {
      errorMessage.value = 'Erro ao carregar a Home: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
