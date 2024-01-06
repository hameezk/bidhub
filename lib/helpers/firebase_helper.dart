import 'package:bidhub/models/auction_model.dart';
import 'package:bidhub/models/property_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;

    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docsnap.data() != null) {
      userModel = UserModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return userModel;
  }
  

  static Future<AuctionModel?> getCarAuctoionModelById(String id) async {
    AuctionModel? auctionModel;

    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("auction").doc(id).get();

    if (docsnap.data() != null) {
      auctionModel = AuctionModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return auctionModel;
  }
  static Future<PropertyModel?> getPropertyAuctoionModelById(String id) async {
    PropertyModel? propertyModel;

    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("properties").doc(id).get();

    if (docsnap.data() != null) {
      propertyModel = PropertyModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return propertyModel;
  }
  
}