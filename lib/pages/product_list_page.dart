import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart_model.dart';
import 'cart_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String selectedCategory = 'All';
  String searchQuery = '';

  final List<Map<String, dynamic>> products = [
    {
      "product": Product(
        id: '1',
        name: 'Chocolate Cake',
        price: 35000,
        emoji: '🍫',
        description: 'Kue coklat lembut premium',
      ),
      "category": "Cake",
    },
    {
      "product": Product(
        id: '2',
        name: 'Strawberry Cheesecake',
        price: 42000,
        emoji: '🍓',
        description: 'Cheesecake dengan topping strawberry',
      ),
      "category": "Cake",
    },
    {
      "product": Product(
        id: '3',
        name: 'Glazed Donut',
        price: 12000,
        emoji: '🍩',
        description: 'Donat manis dengan glaze gula',
      ),
      "category": "Donut",
    },
    {
      "product": Product(
        id: '4',
        name: 'Vanilla Ice Cream',
        price: 15000,
        emoji: '🍦',
        description: 'Es krim vanilla dingin dan lembut',
      ),
      "category": "Ice Cream",
    },
    {
      "product": Product(
        id: '5',
        name: 'Cupcake Rainbow',
        price: 18000,
        emoji: '🧁',
        description: 'Cupcake warna-warni lembut',
      ),
      "category": "Cake",
    },
    {
      "product": Product(
        id: '6',
        name: 'Honey Pancake',
        price: 22000,
        emoji: '🥞',
        description: 'Pancake empuk dengan madu',
      ),
      "category": "Others",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Cake', 'Donut', 'Ice Cream', 'Others'];

    final filteredProducts = products.where((item) {
      final product = item["product"] as Product;
      final category = item["category"] as String;

      final matchesCategory =
          selectedCategory == 'All' || category == selectedCategory;

      final matchesSearch = product.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD6E7),
        foregroundColor: Colors.brown,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Sweet Dessert Shop 🍰',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6F91),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search dessert...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFFFEEF3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),
          ),

          // CATEGORY
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFFB6C1),
                    backgroundColor: const Color(0xFFFFEEF3),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.brown,
                      fontWeight: FontWeight.w500,
                    ),
                    onSelected: (_) {
                      setState(() => selectedCategory = category);
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // PRODUCT LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index]["product"] as Product;

                return Card(
                  color: const Color(0xFFFFEEF3),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD6E7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      title: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.description),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          context.read<CartModel>().addItem(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} ditambahkan!'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
