import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:loja_virtual_unicesumar/controllers/controllers.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({super.key});

  final favoritosController = Get.find<FavoritosController>();
  final usuarioController = Get.find<UserController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: Obx(() {
        final favoritos = favoritosController.favoritos;

        // *** aqui usamos diretamente authController.logado.value ***
        if (!authController.logado.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 100,
                    color: theme.primaryColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Você não está logado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Faça login para visualizar seus produtos favoritos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: const Text(
                        'Fazer Login',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        Future.microtask(() {
                          Get.toNamed('/login');
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Logado mas sem favoritos
        if (favoritos.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: theme.primaryColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Nenhum favorito encontrado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Adicione produtos aos seus favoritos\npara visualizá-los aqui.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      label: const Text(
                        'Continuar comprando',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        Future.microtask(() {
                          Get.offAllNamed('/');
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Logado com favoritos (com fade-in + fontes)
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: favoritos.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final produtoId = favoritos[index];
            final produto = Get.find<ProductController>().getProdutoById(produtoId);

            if (produto == null) {
              return ListTile(
                leading: const Icon(Icons.warning, color: Colors.orange),
                title: Text('Produto ID: $produtoId não encontrado'),
              );
            }

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    produto.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  produto.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'R\$ ${produto.price.toStringAsFixed(2)}',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline, color: theme.primaryColor),
                  onPressed: () {
                    favoritosController.toggleFavorito(produtoId);

                    Get.snackbar(
                      'Removido',
                      '${produto.title} removido dos favoritos.',
                      colorText: Colors.white,
                      backgroundColor: theme.primaryColor,
                      snackPosition: SnackPosition.TOP,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                      icon: const Icon(Icons.favorite_border, color: Colors.white),
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
