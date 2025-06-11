import 'package:sqflite/sqlite_api.dart';

import './../database/app_database.dart';
import './../models/models.dart';

class CartProductsLocalRepository {
  Future<void> saveCartProduct(int cartId, int productId, int quantity) async {
    final db = await AppDatabase().database;
    await db.insert(
      'cart_products',
      {
        'cartId': cartId,
        'productId': productId,
        'quantity': quantity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CartProductModel>> getCartProducts(int cartId) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'cart_products',
      where: 'cartId = ?',
      whereArgs: [cartId],
    );

    // Convertendo cada Map para CartProductModel
    return maps.map((map) => CartProductModel.fromJson(map)).toList();
  }

  Future<void> deleteCartProducts(int cartId) async {
    final db = await AppDatabase().database;
    await db.delete(
      'cart_products',
      where: 'cartId = ?',
      whereArgs: [cartId],
    );
  }
}
