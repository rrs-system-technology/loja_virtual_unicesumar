import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/controllers.dart';
import '../../widgets/widgets.dart';
import '../../views/views.dart';

class HomePage extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  final CartController cartController = Get.find<CartController>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja Online'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Get.toNamed('/cart');
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Obx(() => cartController.cartProducts.isEmpty
                    ? const SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cartController.totalQuantity.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (homeController.errorMessage.isNotEmpty) {
          return Center(child: Text(homeController.errorMessage.value));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Banners
              BannerCarousel(banners: homeController.banners),

              const SizedBox(height: 16),

              /// Categorias
              const Text(
                'Categorias',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeController.categories.length,
                  itemBuilder: (context, index) {
                    final categoria = homeController.categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CategoryTile(
                        category: categoria,
                        onTap: () {
                          //Get.to(() => CategoryPage());
                          Get.toNamed('/category/${Uri.encodeComponent(categoria)}');
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// Produtos em destaque
              const Text(
                'Produtos em destaque',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: homeController.featuredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = homeController.featuredProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Get.to(() => ProductDetailPage(product: product));
                    },
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
