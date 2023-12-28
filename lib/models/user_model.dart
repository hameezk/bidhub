class UserModel {
  String? id;
  String? name;
  String? email;
  String? phoneno;
  String? image;
  List? recentBids;
  String? role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneno,
    required this.recentBids,
    required this.image,
    required this.role,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    email = map["email"];
    phoneno = map["phoneno"];
    image = map["image"];
    recentBids = map["recentBids"];
    role = map["role"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phoneno": phoneno,
      "image": image,
      "recentBids": recentBids,
      "role": role,

    };
  }

  static UserModel? loggedinUser;
  static String defaultImage = '';
}
