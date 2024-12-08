import 'dart:convert';
import 'package:shared/models/parking_space.dart';
import 'package:shared/models/vehicle.dart';
import 'package:objectbox/objectbox.dart';

//class for parking
@Entity()
class Parking {

  @Id()
  int id;

  Vehicle? vehicle;

  String get vehicleDb {
    return jsonEncode(vehicle?.toJson());
  }

  set vehicleDb(String json) {
    vehicle = Vehicle.fromJson(jsonDecode(json));  
  }
  
  ParkingSpace? parkingSpace;

  String get parkingSpaceDb {
    return jsonEncode(parkingSpace?.toJson());
  }

  set parkingSpaceDb(String json) {
    parkingSpace = ParkingSpace.fromJson(jsonDecode(json));  
  }

  //@Property(type: PropertyType.dateNano)
  String startTime;
  //@Property(type: PropertyType.dateNano)
  String? endTime;

  Parking({int? id, this.vehicle, this.parkingSpace, required this.startTime, this.endTime}) 
    : id = id ?? -1;

  //get some details for the parking and return a predefined string, including calculated cost
  String get printDetails => "$id ${vehicle?.regId} ${parkingSpace?.address} $startTime $endTime ${getCostForParking()}";

  //deserialize from json
  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json["id"],
      vehicle: Vehicle.fromJson(json["vehicle"]),
      parkingSpace: ParkingSpace.fromJson(json["parkingSpace"]), 
      startTime: json["startTime"],
      endTime:  json["endTime"] 
    );

  }

  //serialize to json
  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle": vehicle?.toJson(),
    "parkingSpace": parkingSpace?.toJson(),
    "startTime": startTime,
    "endTime": endTime
  };

  String getCostForParking() {

    double cost = 0;

    //caclulate differnce in milliseconds from epoch. If parking is not finished we use now() to get the current cost
    int start = DateTime.parse(startTime).millisecondsSinceEpoch;
    int end =  0;
    if(endTime != null) {
      end = DateTime.parse(endTime!).millisecondsSinceEpoch;
    } else {
      end = DateTime.now().millisecondsSinceEpoch;
    }
    //int end = DateTime.tryParse(selectedParking.endTime) != null ? DateTime.parse(endTime!).millisecondsSinceEpoch : ;
    int total = end - start;

    //convert to hours and calculate the cost
    double totalHours = total / 3600000;
    double ratePerHour = parkingSpace!.pricePerHour;
    cost =  totalHours * ratePerHour; //parkingSpace.pricePerHour;

    return cost.toStringAsFixed(2);

  }

  //calculate the price for the parking
  /*
  String getCostForParking() {

    double cost = 0;

    //caclulate differnce in milliseconds from epoch. If parking is not finished we use now() to get the current cost
    int start = DateTime.parse(startTime).millisecondsSinceEpoch;
    int end =  DateTime.tryParse(endTime!) != null ? DateTime.parse(endTime!).millisecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch;
    int total = end - start;

    //convert to hours and calculate the cost
    double totalHours = total / 3600000;
    cost =  totalHours * 19; //parkingSpace.pricePerHour;

    return cost.toStringAsFixed(2);

  }
  */
}