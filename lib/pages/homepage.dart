import 'package:fakestrore_api/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc
import 'package:fakestrore_api/bloc/product_bloc.dart'; // Import ProductBloc Events dan States

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Hapus list products ini karena data akan datang dari ProductSucceed State
  // final List<Product> products = [];

  @override
  void initState() {
    super.initState();
    // <<< INI PENTING: Memicu Event GET saat halaman pertama kali dimuat
    context.read<ProductBloc>().add(GetProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test API")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ProductBloc>().add(GetProductEvent());
        },
        child: const Text("+", style: TextStyle(fontSize: 36)),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial) {
            return const Center(child: Text("Tekan '+' untuk memuat data."));
          } else if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductSucceed) {
            final products = state.products;

            if (products.isEmpty) {
              return const Center(child: Text("Tidak ada produk ditemukan."));
            }

            return Column(
              children: [

                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final title = product.title;
                      final desc = product.description;
                      final imageUrl = product.images.isNotEmpty ? product.images[0] : '';

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (imageUrl.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Image.network(
                                  imageUrl,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 50, color: Colors.white), // Handle error gambar
                                ),
                              ),
                            Text(
                              title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              desc,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Price: \$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.lightGreenAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          // TODO: Tambahkan ProductError State jika Anda sudah mendefinisikannya
          // else if (state is ProductError) {
          //   return Center(child: Text("Error: ${state.message}"));
          // }
          return const Center(child: Text("Status tidak dikenal."));
        },
      ),
    );
  }
}