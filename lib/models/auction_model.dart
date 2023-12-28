import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuctionModel {
  String? id;
  String? carName;
  List? images;
  String? description;
  String? category;
  String? carMake;
  String? ownerId;
  String? startDate;
  String? endDate;
  String? location;
  String? startingBid;
  String? model;
  String? milage;
  String? enginetype;
  String? transmissionType;
  String? regsteredIn;
  String? color;
  String? engineCapacity;
  String? bodytype;
  String? addedOn;
  List? features;
  List? bids;
  bool? isActive;
  String? winingBid;

  AuctionModel({
    required this.id,
    required this.category,
    required this.carName,
    required this.images,
    required this.description,
    required this.ownerId,
    required this.carMake,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.startingBid,
    required this.model,
    required this.milage,
    required this.enginetype,
    required this.transmissionType,
    required this.regsteredIn,
    required this.color,
    required this.engineCapacity,
    required this.bodytype,
    required this.addedOn,
    required this.features,
    required this.bids,
    required this.isActive,
    required this.winingBid,
  });

  AuctionModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    carName = map["carName"];
    images = map["images"];
    description = map["description"];
    category = map["category"];
    carMake = map["carMake"];
    ownerId = map["ownerId"];
    endDate = map["endDate"];
    location = map["location"];
    startingBid = map["startingBid"];
    model = map["model"];
    milage = map["milage"];
    enginetype = map["enginetype"];
    transmissionType = map["transmissionType"];
    regsteredIn = map["regsteredIn"];
    color = map["color"];
    engineCapacity = map["engineCapacity"];
    bodytype = map["bodytype"];
    addedOn = map["addedOn"];
    // features = map["features"];
    startDate = map["startDate"];
    bids = map["bids"];
    isActive = map["isActive"];
    winingBid = map["winingBid"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "carName": carName,
      "images": images,
      "description": description,
      "category": category,
      "carMake": carMake,
      "ownerId": ownerId,
      "endDate": endDate,
      "startDate": startDate,
      "location": location,
      "startingBid": startingBid,
      "model": model,
      "milage": milage,
      "enginetype": enginetype,
      "transmissionType": transmissionType,
      "regsteredIn": regsteredIn,
      "color": color,
      "engineCapacity": engineCapacity,
      "bodytype": bodytype,
      "addedOn": addedOn,
      // "features": features,
      "bids": bids,
      "isActive": isActive,
      "winingBid": winingBid,
    };
  }

  static List demoFeatures = [
    {
      'feature': 'ABS',
      'icon': '',
      'isavailable': true,
    },
    {
      'feature': 'AM/FM Radio',
      'icon': '',
      'isavailable': true,
    },
    {
      'feature': 'Air Bags',
      'icon': '',
      'isavailable': true,
    },
    {
      'feature': 'Air Conditioning',
      'icon': '',
      'isavailable': true,
    },
    {
      'feature': 'Alloy Rims',
      'icon': '',
      'isavailable': true,
    },
    {
      'feature': 'CD Player',
      'icon': '',
      'isavailable': true,
    },
    {
      'feature': 'Cruise Control',
      'icon': '',
      'isavailable': true,
    },
    {
      'feature': 'Immobilizer Key',
      'icon': '',
      'isavailable': true,
    },
    {
      'feature': 'Keyless Entry',
      'icon': '',
      'isavailable': true,
    },
    {
      'feature': 'Power Locks',
      'icon': '',
      'isavailable': true,
    },
    {
      'feature': 'Power Mirrors',
      'icon': '',
      'isavailable': true,
    },
    {
      'feature': 'Power Windows',
      'icon': '',
      'isavailable': true,
    },
    {
      'feature': 'Sun Roof',
      'icon': '',
      'isavailable': true,
    },
  ];
  static List<AuctionModel> demoBids = [
    AuctionModel(
      id: '1',
      category: 'Sedan/Non accidented',
      carName: 'Honda Civic Oriel 1.8 i-VTEC CVT 2020',
      images: [
        'https://cache4.pakwheels.com/ad_pictures/9385/honda-civic-oriel-1-8-i-vtec-cvt-2020-93859536.webp',
        'https://cache2.pakwheels.com/ad_pictures/9385/honda-civic-oriel-1-8-i-vtec-cvt-2020-93859535.webp',
        'https://cache2.pakwheels.com/ad_pictures/9385/honda-civic-oriel-1-8-i-vtec-cvt-2020-93859533.webp'
      ],
      description:
          'Total Genuine First Owner As good as a brand new car. All taxes paid. Location is Lahore Cantt',
      ownerId: 'VfyKUQ2pBlMwPzGlmkSLz8dWJYB3',
      carMake: 'Honda',
      startDate: (DateTime.now().add(const Duration(days: 1))).toString(),
      endDate:
          (DateTime.now().add(const Duration(days: 1, hours: 5))).toString(),
      location: 'Islamabad',
      startingBid: '6000000',
      model: '2020',
      milage: '87000',
      enginetype: 'Petrol',
      transmissionType: 'Automatic',
      regsteredIn: 'Islamabad',
      color: 'Taffeta White',
      engineCapacity: '1800',
      bodytype: 'Sedan',
      addedOn: (DateTime.now()).toString(),
      features: demoFeatures,
      bids: [],
      isActive: true,
      winingBid: '',
    ),
    AuctionModel(
      id: '2',
      category: 'Sedan/Accidented',
      carName: 'Mitsubishi Lancer GLX 1.3 2008',
      images: [
        'https://cache4.pakwheels.com/ad_pictures/9385/honda-civic-oriel-1-8-i-vtec-cvt-2020-93859536.webp',
        'https://cache2.pakwheels.com/ad_pictures/9385/honda-civic-oriel-1-8-i-vtec-cvt-2020-93859535.webp',
        'https://cache2.pakwheels.com/ad_pictures/9385/honda-civic-oriel-1-8-i-vtec-cvt-2020-93859533.webp'
      ],
      description:
          'Total Genuine First Owner As good as a brand new car. All taxes paid. Location is Lahore Cantt',
      ownerId: 'VfyKUQ2pBlMwPzGlmkSLz8dWJYB3',
      carMake: 'Honda',
      startDate: (DateTime.now().add(const Duration(days: 1))).toString(),
      endDate:
          (DateTime.now().add(const Duration(days: 1, hours: 5))).toString(),
      location: 'Islamabad',
      startingBid: '6000000',
      model: '2020',
      milage: '87000',
      enginetype: 'Petrol',
      transmissionType: 'Automatic',
      regsteredIn: 'Islamabad',
      color: 'Taffeta White',
      engineCapacity: '1800',
      bodytype: 'Sedan',
      addedOn: (DateTime.now()).toString(),
      features: demoFeatures,
      bids: [],
      isActive: true,
      winingBid: '',
    ),
    AuctionModel(
      id: '3',
      category: 'Sedan/Non accidented',
      carName: 'Honda Civic Oriel 1.8 i-VTEC CVT 2020',
      images: [
        'https://cache4.pakwheels.com/ad_pictures/9385/honda-civic-oriel-1-8-i-vtec-cvt-2020-93859536.webp',
        'https://cache2.pakwheels.com/ad_pictures/9385/honda-civic-oriel-1-8-i-vtec-cvt-2020-93859535.webp',
        'https://cache2.pakwheels.com/ad_pictures/9385/honda-civic-oriel-1-8-i-vtec-cvt-2020-93859533.webp'
      ],
      description:
          'Total Genuine First Owner As good as a brand new car. All taxes paid. Location is Lahore Cantt',
      ownerId: 'VfyKUQ2pBlMwPzGlmkSLz8dWJYB3',
      carMake: 'Honda',
      startDate: (DateTime.now().add(const Duration(days: 1))).toString(),
      endDate:
          (DateTime.now().add(const Duration(days: 1, hours: 5))).toString(),
      location: 'Islamabad',
      startingBid: '6000000',
      model: '2020',
      milage: '87000',
      enginetype: 'Petrol',
      transmissionType: 'Automatic',
      regsteredIn: 'Islamabad',
      color: 'Taffeta White',
      engineCapacity: '1800',
      bodytype: 'Sedan',
      addedOn: (DateTime.now()).toString(),
      features: demoFeatures,
      bids: [],
      isActive: true,
      winingBid: '',
    ),
  ];

  static uploadDemoData(context) async {
    for (var bid in demoBids) {
      await FirebaseFirestore.instance
          .collection("auction")
          .doc(bid.id)
          .set(bid.toMap())
          .then(
        (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.blueGrey,
              duration: Duration(seconds: 1),
              content: Text("demo bids uploaded!"),
            ),
          );
        },
      );
    }
  }
}
