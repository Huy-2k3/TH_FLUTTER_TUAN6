import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tuan6/data/model/product.dart';
import '../../data/helper/db_helper.dart';

import 'product_add.dart';

class ProductBuilder extends StatefulWidget {
  const ProductBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductBuilder> createState() => _ProductBuilderState();
}

class _ProductBuilderState extends State<ProductBuilder> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Product_Model>> _getProducts() async {
    // thêm vào 1 dòng dữ liệu nếu getdata không có hoặc chưa có database
    return await _databaseHelper.products();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product_Model>>(
      future: _getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No products found'),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length ,
            itemBuilder: (context, index) {
              final itemCat = snapshot.data![index];
              return _buildProduct(itemCat, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildProduct(Product_Model breed, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              alignment: Alignment.center,
              child: breed.img!.isNotEmpty
                  ? Image.memory(
                      base64Decode(breed.img!),
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.image, size: 40, color: Colors.grey),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breed.name!,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(breed.price.toString()),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    DatabaseHelper().deleteProduct(breed.id!);
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => ProductAdd(
                              isUpdate: true,
                              productModel: breed,
                            ),
                            fullscreenDialog: true,
                          ),
                        )
                        .then((_) => setState(() {}));
                  });
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.yellow.shade800,
                ))
          ],
        ),
      ),
    );
  }
}
