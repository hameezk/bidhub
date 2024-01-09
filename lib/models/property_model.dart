import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PropertyModel {
  String? id;
  List? images;
  String? area;
  String? description;
  String? type;
  String? bedrooms;
  String? ownerId;
  String? startDate;
  String? endDate;
  String? location;
  String? startingBid;
  String? baths;
  String? addedOn;
  List? features;
  List? bids;
  bool? isActive;
  String? winingBid;
  String? inspectionReport;

  PropertyModel({
    required this.id,
    required this.type,
    required this.area,
    required this.images,
    required this.description,
    required this.ownerId,
    required this.bedrooms,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.startingBid,
    required this.baths,
    required this.addedOn,
    required this.features,
    required this.bids,
    required this.isActive,
    required this.winingBid,
    required this.inspectionReport,
  });

  PropertyModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    area = map["area"];
    images = map["images"];
    description = map["description"];
    type = map["type"];
    bedrooms = map["bedrooms"];
    ownerId = map["ownerId"];
    endDate = map["endDate"];
    location = map["location"];
    startingBid = map["startingBid"];
    baths = map["baths"];
    addedOn = map["addedOn"];
    features = map["features"];
    startDate = map["startDate"];
    bids = map["bids"];
    isActive = map["isActive"];
    winingBid = map["winingBid"];
    inspectionReport = map["inspectionReport"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "area": area,
      "images": images,
      "description": description,
      "type": type,
      "bedrooms": bedrooms,
      "ownerId": ownerId,
      "endDate": endDate,
      "startDate": startDate,
      "location": location,
      "startingBid": startingBid,
      "baths": baths,
      "addedOn": addedOn,
      "features": features,
      "bids": bids,
      "isActive": isActive,
      "winingBid": winingBid,
      "inspectionReport": inspectionReport,
    };
  }

  static List demoFeatures = [
    {
      'feature': 'Built in year',
      'icon': 'assets/calendar.png',
      'isavailable': false,
    },
    {
      'feature': 'Parking Spaces',
      'icon': 'assets/parking.png',
      'isavailable': false,
    },
    {
      'feature': 'Double Glazed Windows',
      'icon': 'assets/windowss.png',
      'isavailable': false,
    },
    {
      'feature': 'Centeral Air Conditioning',
      'icon': 'assets/ac.png',
      'isavailable': false,
    },
    {
      'feature': 'Central Heating',
      'icon': 'assets/heater.png',
      'isavailable': false,
    },
    {
      'feature': 'Flooring',
      'icon': 'assets/floor.png',
      'isavailable': false,
    },
    {
      'feature': 'Waste Disposal',
      'icon': 'assets/trash.png',
      'isavailable': false,
    },
    {
      'feature': 'Drawing Room',
      'icon': 'assets/sofa.png',
      'isavailable': false,
    },
    {
      'feature': 'Dining Room',
      'icon': 'assets/dining.png',
      'isavailable': false,
    },
  ];
  static List<PropertyModel> demoBids = [
    PropertyModel(
      id: '1',
      type: 'House',
      area: '375',
      images: [
        'https://media.zameen.com/thumbnails/242860482-800x600.webp',
        'https://media.zameen.com/thumbnails/242860485-800x600.webp',
        'https://media.zameen.com/thumbnails/242860486-800x600.webp',
        'https://media.zameen.com/thumbnails/242860487-800x600.webp',
        'https://media.zameen.com/thumbnails/242860488-800x600.webp',
      ],
      description:
          'Malir cantt Askari 5,  Scetor J, Brigadier House for sale, 5 Bedrooms',
      ownerId: 'VfyKUQ2pBlMwPzGlmkSLz8dWJYB3',
      bedrooms: '2',
      startDate: (DateTime.now().add(const Duration(days: 30))).toString(),
      endDate:
          (DateTime.now().add(const Duration(days: 30, hours: 5))).toString(),
      location:
          'Askari 5 - Sector J, Askari 5, Malir Cantonment, Cantt, Karachi, Sindh',
      startingBid: '60000000',
      baths: '2',
      addedOn: (DateTime.now()).toString(),
      features: demoFeatures,
      bids: [],
      isActive: true,
      winingBid: '',
      inspectionReport:'',
    ),
    PropertyModel(
      id: '3',
      type: 'House',
      area: '375',
      images: [
        'https://media.zameen.com/thumbnails/242860485-800x600.webp',
        'https://media.zameen.com/thumbnails/242860486-800x600.webp',
        'https://media.zameen.com/thumbnails/242860482-800x600.webp',
        'https://media.zameen.com/thumbnails/242860487-800x600.webp',
        'https://media.zameen.com/thumbnails/242860488-800x600.webp',
      ],
      description:
          'Bahria Town - Precinct 10-B House For Sale Sized 152 Square Yards',
      ownerId: 'VfyKUQ2pBlMwPzGlmkSLz8dWJYB3',
      bedrooms: '2',
      startDate: (DateTime.now().add(const Duration(days: 30))).toString(),
      endDate:
          (DateTime.now().add(const Duration(days: 30, hours: 5))).toString(),
      location:
          'Askari 5 - Sector J, Askari 5, Malir Cantonment, Cantt, Karachi, Sindh',
      startingBid: '60000000',
      baths: '2',
      addedOn: (DateTime.now()).toString(),
      features: demoFeatures,
      bids: [],
      isActive: true,
      inspectionReport:'',
      winingBid: '',
    ),
    PropertyModel(
      id: '2',
      type: 'House',
      area: '375',
      images: [
        'https://media.zameen.com/thumbnails/242860487-800x600.webp',
        'https://media.zameen.com/thumbnails/242860488-800x600.webp',
        'https://media.zameen.com/thumbnails/242860482-800x600.webp',
        'https://media.zameen.com/thumbnails/242860485-800x600.webp',
        'https://media.zameen.com/thumbnails/242860486-800x600.webp',
      ],
      description:
          'Gulistan-e-Jauhar - Block 15, Gulistan-e-Jauhar, Karachi, Sindh',
      ownerId: 'VfyKUQ2pBlMwPzGlmkSLz8dWJYB3',
      bedrooms: '2',
      startDate: (DateTime.now().add(const Duration(days: 30))).toString(),
      endDate:
          (DateTime.now().add(const Duration(days: 30, hours: 5))).toString(),
      location:
          'Askari 5 - Sector J, Askari 5, Malir Cantonment, Cantt, Karachi, Sindh',
      startingBid: '60000000',
      baths: '2',
      addedOn: (DateTime.now()).toString(),
      features: demoFeatures,
      bids: [],
      isActive: true,
      inspectionReport:'',
      winingBid: '',
    ),
  ];

  static uploadDemoData(context) async {
    for (var bid in demoBids) {
      await FirebaseFirestore.instance
          .collection("properties")
          .doc(bid.id)
          .set(bid.toMap())
          .then(
        (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.blueGrey,
              duration: Duration(seconds: 1),
              content: Text("demo properties uploaded!"),
            ),
          );
        },
      );
    }
  }
}
