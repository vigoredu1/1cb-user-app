class ShiprocketOrderResponse {
  final ShiprocketOrderData data;

  ShiprocketOrderResponse({required this.data});

  factory ShiprocketOrderResponse.fromJson(Map<String, dynamic> json) {
    return ShiprocketOrderResponse(
      data: ShiprocketOrderData.fromJson(json['data']),
    );
  }
}

class ShiprocketOrderData {
  final List<ShiprocketItem> items;

  ShiprocketOrderData({required this.items});

  factory ShiprocketOrderData.fromJson(Map<String, dynamic> json) {
    return ShiprocketOrderData(
      items: (json['items'] as List)
          .map((e) => ShiprocketItem.fromJson(e))
          .toList(),
    );
  }

  /// 🔥 GROUP BY PRODUCT ID → Qty count
  Map<String, List<ShiprocketItem>> get groupedItems {
    final map = <String, List<ShiprocketItem>>{};
    for (final item in items) {
      map.putIfAbsent(item.productId, () => []).add(item);
    }
    return map;
  }
}

class ShiprocketItem {
  final String productId;
  final String productImageId;

  ShiprocketItem({
    required this.productId,
    required this.productImageId,
  });

  factory ShiprocketItem.fromJson(Map<String, dynamic> json) {
    return ShiprocketItem(
      productId: json['product_id'],
      productImageId: json['productImageId'],
    );
  }
}
