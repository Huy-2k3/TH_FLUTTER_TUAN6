import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:tuan6/data/model/product.dart';

import '../../data/helper/db_helper.dart';

class ProductAdd extends StatefulWidget {
  final bool isUpdate;
  final Product_Model? productModel;
  const ProductAdd({super.key, this.isUpdate = false, this.productModel});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _filePath = ''; // Đường dẫn của hình ảnh đã chọn
  String _imageBase64 = ''; // Dữ liệu của hình ảnh dạng base64
  String titleText = "";
  final DatabaseHelper _databaseService = DatabaseHelper();

  //////Chọn Hình từ thư viện ảnh
  ///
  ///
  ///
  ///
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _filePath = file.path ?? '';
      });

      // Đọc và chuyển đổi hình ảnh sang base64
      if (_filePath.isNotEmpty) {
        File imageFile = File(_filePath);
        List<int> imageBytes = await imageFile.readAsBytes();
        setState(() {
          _imageBase64 = base64Encode(imageBytes);
        });
      }
    }
  }

  Future<void> _onSave() async {
    final name = _nameController.text;
    final description = _desController.text;
    int price = int.tryParse(_priceController.text) ?? 0;
    await _databaseService
        .insertProduct(Product_Model(name: name, des: description, price: price, img: _imageBase64));
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> _onUpdate() async {
    final name = _nameController.text;
    final description = _desController.text;
    int price = int.tryParse(_priceController.text) ?? 0;

    await _databaseService.updateProduct(Product_Model(
        name: name, des: description, id: widget.productModel!.id, price: price, img: _imageBase64));

    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.productModel!= null && widget.isUpdate) {
      _nameController.text = widget.productModel!.name!;
      _desController.text = widget.productModel!.des!;
      _priceController.text = widget.productModel!.price.toString();
      _imageBase64 = widget.productModel!.img ?? '';

    }
    if (widget.isUpdate) {
      titleText = "Update Product";
    } else
      titleText = "Add New Product";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _desController,
              // maxLines: 7,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter description',
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(height: 12.0),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter price',
              ),
            ),
            SizedBox(height: 12.0),
            _imageBase64.isNotEmpty || _filePath.isNotEmpty
                ? Image.memory(
                    base64Decode(_imageBase64),
                    height: 200.0,
                    fit: BoxFit.cover,
                  )
                : 
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: () {
                  widget.isUpdate ? _onUpdate() : _onSave();
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
