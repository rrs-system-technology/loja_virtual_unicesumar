import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shimmer/shimmer.dart';

import './../../../controllers/controllers.dart';
import './../../../models/models.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap; // ação ao clicar no card
  final double imageAspectRatio; // permite personalizar no Grid ou List

  final CartController carrinhoController = Get.find<CartController>();
  final AuthController usuarioController = Get.find<AuthController>();
  final FavoritosController favoritosController = Get.find<FavoritosController>();

  ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.imageAspectRatio = 0.75, // padrão para Grid
  });

  bool get isLogado => usuarioController.logado.value;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Imagem com clique
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                  fadeInDuration: const Duration(milliseconds: 500),
                ),
              ),
            ),
          ),

          /// Footer com fundo + conteúdo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Column(
              children: [
                /// Nome do produto
                Text(
                  product.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),

                /// Ícones e preço
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    /// Favoritar
                    Obx(() {
                      final isFavorito = favoritosController.isFavorito(product.id);
                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          if (!isLogado) {
                            Get.snackbar(
                              'Acesso negado',
                              'Faça login para favoritar produtos.',
                              colorText: Colors.white,
                              backgroundColor: Theme.of(context).primaryColor,
                              snackPosition: SnackPosition.TOP,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12,
                              icon: const Icon(Icons.lock_outline, color: Colors.white),
                              duration: const Duration(seconds: 3),
                            );
                            return;
                          }
                          favoritosController.toggleFavorito(product.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            isFavorito ? Icons.favorite : Icons.favorite_border,
                            color: isFavorito ? Colors.red : Colors.white,
                            size: 18,
                          ),
                        ),
                      );
                    }),

                    /// Preço
                    Text(
                      'R\$ ${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    /// Adicionar ao carrinho
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        carrinhoController.addProductToCart(product.id, 1);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.orange,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
