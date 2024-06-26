import 'package:flutter_ecommerce/models/cart_item.dart';

class Cart {
  List<CartItem> items = [];
  double subTotal;
  double total;

  Cart({required this.items, required this.subTotal, required this.total});

  void _updateSubTotal() {
    subTotal = items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void _updateTotal() {
    total = subTotal;
  }

  void addItem(CartItem newItem) {
    // * Check if item already exists in cart
    var existingItem = items.firstWhere(
      (item) =>
          item.name == newItem.name &&
          item.color == newItem.color &&
          item.size == newItem.size,
      orElse: () => CartItem(
          id: "",
          name: "",
          price: 0,
          quantity: 0,
          imageUrl: "",
          size: "",
          color: ""),
    );

    if (existingItem.name.isNotEmpty) {
      // * If item exists, increase quantity
      existingItem.quantity++;
    } else {
      // * If item does not exist, add it to the cart
      items.add(newItem);
    }

    _updateSubTotal();
    _updateTotal();
  }

  void removeItem(String itemName, String color, String size) {
    items.removeWhere(
      (item) =>
          item.name == itemName && item.color == color && item.size == size,
    );
    _updateSubTotal();
    _updateTotal();
  }

  void addItemQuantity(String itemName, String color, String size) {
    var existingItem = items.firstWhere(
      (item) =>
          item.name == itemName && item.color == color && item.size == size,
      orElse: () => CartItem(
          id: "",
          name: "",
          price: 0,
          quantity: 0,
          imageUrl: "",
          size: "",
          color: ""),
    );

    if (existingItem.name.isNotEmpty) {
      existingItem.quantity++;
      _updateSubTotal();
      _updateTotal();
    }
  }

  void removeItemQuantity(String itemName, String color, String size) {
    var existingItem = items.firstWhere(
      (item) =>
          item.name == itemName && item.color == color && item.size == size,
      orElse: () => CartItem(
          id: "",
          name: "",
          price: 0,
          quantity: 0,
          imageUrl: "",
          size: "",
          color: ""),
    );

    if (existingItem.name.isNotEmpty && existingItem.quantity > 1) {
      existingItem.quantity--;
      _updateSubTotal();
      _updateTotal();
    }
  }

  void updateItemQuantity(String itemId, int newQuantity) {
    var item = items.firstWhere(
      (item) => item.id == itemId,
      orElse: () => CartItem(
          id: "",
          name: "",
          price: 0,
          quantity: 0,
          imageUrl: "",
          size: "",
          color: ""),
    );
    if (item.id.isNotEmpty) {
      item.quantity = newQuantity;
      _updateSubTotal();
      _updateTotal();
    }
  }
}
