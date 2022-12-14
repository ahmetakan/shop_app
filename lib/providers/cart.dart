import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, cart) {
      total += cart.price * cart.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existItem) {
        return CartItem(
          id: existItem.id,
          title: existItem.title,
          quantity: existItem.quantity + 1,
          price: existItem.price,
        );
      });
    } else {
      _items.putIfAbsent(productId, () {
        return CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        );
      });
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items.update(
          productId,
          (existingProduct) {
            return CartItem(
              id: existingProduct.id,
              title: existingProduct.title,
              price: existingProduct.price,
              quantity: existingProduct.quantity - 1,
            );
          },
        );
      } else {
        _items.remove(productId);
      }

      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
