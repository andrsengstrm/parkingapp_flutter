import 'package:objectbox/objectbox.dart';

//class for parking space
@Entity()
class ParkingSpace {

  @Id()
  int id;
  String address;
  double pricePerHour;

  //constructor with optional id, if not supplied we create an uid
  ParkingSpace({int? id, required this.address, required this.pricePerHour}) : id = id ?? -1;

  //deserialize from json
  ParkingSpace.fromJson(Map<String, dynamic> json)
    : id = json["id"] as int,
      address = json["address"] as String,
      pricePerHour = json["pricePerHour"] as double;

  //serialize to json
  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "pricePerHour": pricePerHour
  };

  //return some predefined details
  String get printDetails => "$id $address ${pricePerHour.toStringAsFixed(2)}";

}