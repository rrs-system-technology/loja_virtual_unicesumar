class CartProductModel {
  final int productId;
  final int quantity;

  CartProductModel({required this.productId, required this.quantity});

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(productId: json['productId'], quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity};
  }
}
