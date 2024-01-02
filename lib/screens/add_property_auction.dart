import 'dart:io';
import 'package:bidhub/config/bottombar.dart';
import 'package:bidhub/config/loading_dialoge.dart';
import 'package:bidhub/config/size.dart';
import 'package:bidhub/config/snackbar.dart';
import 'package:bidhub/config/theme.dart';
import 'package:bidhub/models/user_model.dart';
import 'package:bidhub/screens/add_car_auction.dart';
import 'package:bidhub/screens/home_screen_seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';

import '../config/colors.dart';
import '../models/property_model.dart';

class AddAuctionProperty extends StatefulWidget {
  const AddAuctionProperty({super.key});

  @override
  State<AddAuctionProperty> createState() => _AddAuctionPropertyState();
}

class _AddAuctionPropertyState extends State<AddAuctionProperty> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController areaController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController bedroomController = TextEditingController();
  TextEditingController bathsController = TextEditingController();
  TextEditingController startingBidController = TextEditingController();
  TextEditingController startingDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController noneController = TextEditingController();
  List<File> images = [];
  List<String> imageLinks = [];
  DateTime? biddingDate;
  DateTime todayDate = DateTime.now();
  DateTime? startTime;
  DateTime? endTime;
  TimeOfDay? picked = TimeOfDay.now();
  Uuid uuid = const Uuid();
  List features = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: textColorDark,
        centerTitle: true,
        title: const Text(
          "Add Auction",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColorDark,
            fontSize: 25,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: height(context) * 0.1,
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: <Widget>[
                      SizedBox(
                        height: height(context) * 0.07,
                        width: width(context) * 0.8,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: textColorLight),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      alignment: Alignment.bottomCenter,
                                      curve: Curves.easeInOut,
                                      duration:
                                          const Duration(milliseconds: 600),
                                      reverseDuration:
                                          const Duration(milliseconds: 600),
                                      type: PageTransitionType.fade,
                                      child: const AddAuction(),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: width(context) * 0.45,
                                  child: const Center(
                                    child: FittedBox(
                                      child: Text(
                                        'Add Car',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColorDark,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: width(context) * 0.45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: containerColor),
                                child: const Center(
                                  child: FittedBox(
                                    child: Text(
                                      'Add Property',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColorLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height(context) * 0.2,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: images.length + 1,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return (index >= images.length)
                                ? GestureDetector(
                                    onTap: () {
                                      showImageOptions();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: height(context) * 0.18,
                                        width: height(context) * 0.18,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: lightBlack,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.add,
                                            color: textColorDark,
                                            size: 60,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: height(context) * 0.18,
                                          width: height(context) * 0.18,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: lightBlack,
                                            image: DecorationImage(
                                                image: FileImage(
                                                  images[index],
                                                ),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          top: 10,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(1100),
                                              color: textColorLight,
                                            ),
                                            child: GestureDetector(
                                              child: const Padding(
                                                padding: EdgeInsets.all(3.0),
                                                child: Icon(Icons.close),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  images.removeAt(index);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          },
                        ),
                      ),
                      buildTextFormFeild(
                          descriptionController,
                          'Property Description',
                          'Please enter the Property description'),
                      buildTextFormFeild(areaController, 'Property Area',
                          'Please enter the Property area'),
                      buildTextFormFeild(typeController, 'Property Type',
                          'Please enter the Property Type'),
                      buildTextFormFeild(bedroomController, 'No. of Bedrooms',
                          'Please enter the number of bedrooms'),
                      buildTextFormFeild(bathsController, 'No. of Baths',
                          'Please enter the number of baths'),
                      buildTextFormFeild(
                          locationController,
                          'Property location',
                          'Please enter the Property location'),
                      buildTextFormFeild(startingBidController, 'Starting Bid',
                          'Please enter the car starting bid'),
                      const SizedBox(height: 0.0),
                      GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          childAspectRatio: 2 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: features.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                features[index]['isavailable'] =
                                    !features[index]['isavailable'];
                              });
                            },
                            child: Container(
                              height: width(context) * 0.2,
                              width: width(context) * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (features[index]['isavailable'])
                                    ? secondaryColor
                                    : textColorDark,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        features[index]['icon'],
                                        height: 30,
                                        color: textColorLight,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: FittedBox(
                                          child: Text(
                                            features[index]['feature'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: textColorLight,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 50.0),
                      GestureDetector(
                        onTap: () {
                          datePicker();
                        },
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.date_range_outlined,
                                color: textColorDark,
                              ),
                            ),
                            Text(
                              (biddingDate != null)
                                  ? DateFormat('EEEE, MMM d, yyyy')
                                      .format(biddingDate!)
                                  : 'Select Bidding Date ',
                              style: myTheme.textTheme.displaySmall!
                                  .copyWith(color: textColorLight),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          if (biddingDate != null) {
                            selectStartTime(context).then(
                              (value) => selectEndTime(context),
                            );
                          } else {
                            showCustomSnackbar(
                                context: context,
                                content: 'Please select bidding date');
                          }
                        },
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_time_rounded,
                                color: textColorDark,
                              ),
                            ),
                            Text(
                              (startTime != null)
                                  ? DateFormat('h:mm a  -  ').format(startTime!)
                                  : 'Select starting time  -  ',
                              style: myTheme.textTheme.displaySmall!
                                  .copyWith(color: textColorLight),
                            ),
                            Text(
                              (endTime != null)
                                  ? DateFormat('h:mm a').format(endTime!)
                                  : 'Select ending time',
                              style: myTheme.textTheme.displaySmall!
                                  .copyWith(color: textColorLight),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(containerColor)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (images.isNotEmpty &&
                                startTime != null &&
                                endTime != null) {
                              uploadData();
                            } else {
                              showCustomSnackbar(
                                  context: context,
                                  content: 'Please fill all the feilds!');
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Add Car to Auction',
                            style: myTheme.textTheme.displaySmall!
                                .copyWith(color: textColorLight),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height(context) * 0.15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          buildNavBar(
            context,
            2,
          ),
        ],
      ),
    );
  }

  void datePicker() async {
    var date = await getDate();
    setState(() {
      if (date != null) {
        biddingDate = date;
      }
    });
  }

  Future<DateTime?> getDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 10)),
    );
  }

  Future<void> selectStartTime(BuildContext context) async {
    picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 00, minute: 00),
    );
    setState(() {
      if (picked != null) {
        startTime = DateTime(biddingDate!.year, biddingDate!.month,
            biddingDate!.day, picked!.hour, picked!.minute);
      }
    });
  }

  Future<void> selectEndTime(BuildContext context) async {
    picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 00, minute: 00),
    );
    setState(() {
      if (picked != null) {
        if ((picked!.hour + picked!.minute / 60.0) >
            (startTime!.hour + startTime!.minute / 60.0)) {
          endTime = DateTime(biddingDate!.year, biddingDate!.month,
              biddingDate!.day, picked!.hour, picked!.minute);
        } else {
          showCustomSnackbar(
              content: 'End-Time cannot be past Start-Time', context: context);
          endTime = startTime;
        }
      }
    });
  }

  TextFormField buildTextFormFeild(
      TextEditingController controller, String label, String errorText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        }
        return null;
      },
    );
  }

  void selectImage(ImageSource source) async {
    XFile? selectedImage = await ImagePicker().pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        images.add(File(selectedImage.path));
      });
    }
  }

  void showImageOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Upload profile picture",
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: const Icon(Icons.photo_album_rounded),
                title: const Text(
                  "Select from Gallery",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: const Icon(CupertinoIcons.photo_camera),
                title: const Text(
                  "Take new photo",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void uploadData() async {
    showLoadingDialog(context, 'Uploading data...');
    for (var image in images) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("carPictures")
          .child(image.path)
          .putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      imageLinks.add(imageUrl);
    }

    PropertyModel propertyModel = PropertyModel(
      id: uuid.v1(),
      images: imageLinks,
      description: descriptionController.text.trim(),
      ownerId: UserModel.loggedinUser!.id,
      startDate: startTime.toString(),
      endDate: endTime.toString(),
      location: locationController.text.trim(),
      startingBid: startingBidController.text.trim(),
      addedOn: DateTime.now().toString(),
      features: features,
      bids: [],
      isActive: true,
      winingBid: '',
      area: '',
      baths: '',
      bedrooms: '',
      type: '',
    );

    await FirebaseFirestore.instance
        .collection("auction")
        .doc(propertyModel.id)
        .set(propertyModel.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 1),
            content: Text("New Auction added"),
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const HomeScreenSeller();
            },
          ),
        );
      },
    );
  }
}
