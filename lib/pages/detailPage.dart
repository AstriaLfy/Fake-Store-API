import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fakestrore_api/models/product_model.dart';

class DetailPage extends StatefulWidget {
  final int productID;
  const DetailPage({super.key, required this.productID});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Product? _product;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProductDetail();
  }

  Future<void> _fetchProductDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse("https://api.escuelajs.co/api/v1/products/${widget.productID}"),
      );

      if (response.statusCode == 200) {
        final productJson = productSingleFromJson(response.body);
        setState(() {
          _product = productJson as Product?;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Gagal memuat detail produk: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Terjadi kesalahan jaringan: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              )
            else if (_product != null)
                Column(
                  children: [
                    Text(
                      _product!.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Harga: \$${_product!.price.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.green),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        _product!.description,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                )
              else
                const Text(
                  "Tidak ada data produk yang ditemukan.",
                  textAlign: TextAlign.center,
                ),
          ],
        ),
      ),
    );
  }
}