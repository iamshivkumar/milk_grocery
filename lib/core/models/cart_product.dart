class CartProduct {
  final String id;
  int optionIndex;
  int qt;

  CartProduct({
    required this.id,
    required this.qt,
    required this.optionIndex,
  });

  factory CartProduct.fromMap(Map<String, dynamic> data) {
    return CartProduct(
      id: data['id'],
      qt: data['qt'],
      optionIndex: data['optionIndex']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'qt': qt,
      'optionIndex':optionIndex
    };
  }
}
