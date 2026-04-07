import 'package:flutter/material.dart';

class OrderDetailsSheet extends StatelessWidget {
  final dynamic order;
  const OrderDetailsSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final product = order.products.isNotEmpty ? order.products.first : null;
    final imageUrl = product != null &&
            product.images.isNotEmpty &&
            product.images.first.image.isNotEmpty
        ? product.images.first.image
        : null;

    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.85,
      initialChildSize: 0.6,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 45,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageUrl != null
                    ? Image.network(imageUrl, height: 160, fit: BoxFit.cover)
                    : Container(
                        height: 160,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image),
                      ),
              ),

              const SizedBox(height: 12),

              // PRODUCT NAME
              Text(
                product?.name ?? "Product",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "Category: ${product?.category ?? ''}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order ID:", style: TextStyle(color: Colors.black54)),
                  Text(order.orderId),
                ],
              ),
              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Price:", style: TextStyle(color: Colors.black54)),
                  Text("₹${order.price}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Status:", style: TextStyle(color: Colors.black54)),
                  Text(order.status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      )),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Items",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              ...order.products.map<Widget>((p) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: p.images.isNotEmpty
                        ? Image.network(
                            p.images.first.image,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 55,
                            height: 55,
                            color: Colors.grey.shade300,
                            child: Icon(Icons.image),
                          ),
                  ),
                  title: Text(p.name),
                  subtitle: Text("Qty: ${p.quantity}"),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
