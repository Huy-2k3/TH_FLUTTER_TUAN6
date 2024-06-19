import 'dart:convert';
import 'dart:ui';

class Product_Model {
  int? id;
  String? name;
  int? price;
  String? img;
  String? des;
  int? catId;
  //constructor
  Product_Model({this.id, this.name, this.price, this.img, this.des, this.catId});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'des': des,
      'price': price,
      'img': img,
      'catid': catId
    };
  }

  factory Product_Model.fromMap(Map<String, dynamic> map) {
    return Product_Model(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      des: map['des'] ?? '',
      price: map['price']?.toInt() ?? 0,
      img: map['img'] ?? '',
      catId: map['catid']?.toInt() ?? 0
    );
  }




  String toJson() => json.encode(toMap());
  factory Product_Model.fromJson(String source) =>
      Product_Model.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'Product(id: $id, name: $name, desc: $des, price: $price, img: $img, catId: $catId)';

}
