import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import './../repository/repository.dart';
import './../models/models.dart';

class CartController extends GetxController {
  final CartRepository cartRepository;

  CartController({required this.cartRepository});

  // Carrinho observável
  final Rx<CartModel?> cart = Rx<CartModel?>(null);

  // Produtos do carrinho observáveis
  final RxList<CartProductModel> cartProducts = <CartProductModel>[].obs;

  // Carregar carrinho + produtos
  Future<void> fetchCart(int cartId) async {
    try {
      final fetchedCart = await cartRepository.getCartById(cartId);
      cart.value = fetchedCart;

      if (fetchedCart != null) {
        final products = await cartRepository.getCartProducts(fetchedCart.id);
        cartProducts.assignAll(products);
      } else {
        cartProducts.clear();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar carrinho: $e');
      }
    }
  }

  // Adicionar produto ao carrinho
  Future<void> addProductToCart(int productId, int quantity) async {
    if (cart.value == null) {
      // Criar carrinho novo
      final newCartId = await cartRepository.saveCart(1, DateTime.now().toIso8601String());
      cart.value = CartModel(id: newCartId, userId: 1, date: DateTime.now(), products: []);
    }

    await cartRepository.saveCartProduct(cart.value!.id, productId, quantity);

    // Atualizar lista de produtos
    final products = await cartRepository.getCartProducts(cart.value!.id);
    cartProducts.assignAll(products);
  }

  // Atualizar quantidade de produto
  Future<void> updateProductQuantity(int productId, int newQuantity) async {
    if (cart.value == null) return;

    // Simples: salva o produto novamente com a nova quantidade
    await cartRepository.saveCartProduct(cart.value!.id, productId, newQuantity);

    // Atualizar lista de produtos
    final products = await cartRepository.getCartProducts(cart.value!.id);
    cartProducts.assignAll(products);
  }

  // Excluir carrinho
  Future<void> deleteCart() async {
    if (cart.value == null) return;

    await cartRepository.deleteCart(cart.value!.id);

    // Resetar estado
    cart.value = null;
    cartProducts.clear();
  }

  // Total de itens no carrinho
  int get totalQuantity {
    return cartProducts.fold(0, (sum, item) => sum + item.quantity);
  }
}
