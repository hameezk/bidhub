// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:bidhub/config/bottombar.dart';
import 'package:bidhub/config/loading_dialoge.dart';
import 'package:bidhub/config/size.dart';
import 'package:bidhub/config/snackbar.dart';
import 'package:bidhub/config/theme.dart';
import 'package:bidhub/models/inspection_report_property.dart';
import 'package:bidhub/models/user_model.dart';
import 'package:bidhub/screens/add_car_auction.dart';
import 'package:bidhub/screens/home_screen_seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
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
  final TextEditingController overallScoreController = TextEditingController();
  final TextEditingController locationScoreController = TextEditingController();
  final TextEditingController comfortScoreController = TextEditingController();
  final TextEditingController inspectionDateController =
      TextEditingController();
  List<File> images = [];
  List<String> imageLinks = [];
  DateTime? biddingDate;
  DateTime todayDate = DateTime.now();
  DateTime? startTime;
  DateTime? endTime;
  TimeOfDay? picked = TimeOfDay.now();
  Uuid uuid = const Uuid();
  File? imageFile;
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
                          'Property Description *',
                          'Please enter the Property description'),
                      buildTextFormFeild(areaController, 'Property Area *',
                          'Please enter the Property area'),
                      buildTextFormFeild(typeController, 'Property Type *',
                          'Please enter the Property Type *'),
                      buildTextFormFeild(bedroomController, 'No. of Bedrooms *',
                          'Please enter the number of bedrooms'),
                      buildTextFormFeild(bathsController, 'No. of Baths *',
                          'Please enter the number of baths'),
                      buildTextFormFeild(
                          locationController,
                          'Property location *',
                          'Please enter the Property location'),
                      buildTextFormFeild(
                          startingBidController,
                          'Starting Bid *',
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
                          showInspectionOptions();
                        },
                        onLongPress: () {
                          if (imageFile != null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  elevation: 1,
                                  backgroundColor: Colors.white,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: height(context) * 0.7,
                                        width: width(context) * 0.7,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: FileImage(imageFile!),
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: textColorLight.withOpacity(0.7)),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(
                                    Icons.featured_play_list_outlined,
                                    color: textColorDark,
                                  ),
                                ),
                                SizedBox(
                                  width: width(context) * 0.6,
                                  child: Text(
                                    (imageFile != null)
                                        ? imageFile!.path.split('/').last
                                        : 'Upload Inspection Report',
                                    overflow: TextOverflow.ellipsis,
                                    style: myTheme.textTheme.displaySmall!
                                        .copyWith(color: textColorDark),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      (imageFile != null)
                          ? buildInspectionReportForm()
                          : Container(
                              height: 0,
                            ),
                      const SizedBox(height: 30.0),
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

  TextFormField buildInspectionTextFormFeild(
      TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: InputBorder.none,
      ),
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
          .ref("PropertyPictures")
          .child(image.path)
          .putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      imageLinks.add(imageUrl);
    }

    UploadTask uploadTask = FirebaseStorage.instance
        .ref("inspectionReports")
        .child(imageFile!.path)
        .putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    String reportUrl = await snapshot.ref.getDownloadURL();

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
      area: areaController.text.trim(),
      baths: bathsController.text.trim(),
      bedrooms: bedroomController.text.trim(),
      type: typeController.text.trim(),
      inspectionReport: reportUrl,
    );

    await FirebaseFirestore.instance
        .collection("properties")
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

  void showInspectionOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Upload Inspection Report",
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
                  pickInspectionReport(ImageSource.gallery);
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
                  pickInspectionReport(ImageSource.camera);
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

  Future<String> readTextFromImage() async {
    final inputImage = InputImage.fromFile(imageFile!);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;

    textRecognizer.close();

    return text;
  }

  Future<void> pickInspectionReport(ImageSource source) async {
    XFile? selectedImage = await ImagePicker().pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        imageFile = File(selectedImage.path);
      });
    }
  }

  buildInspectionReportForm() {
    return FutureBuilder(
      future: readTextFromImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          PropertyReport propertyReport =
              PropertyReport.parseInspectionReport(snapshot.data!);
          overallScoreController.text = propertyReport.overallScore ?? "";
          locationScoreController.text = propertyReport.locationScore ?? "";
          comfortScoreController.text = propertyReport.confortScore ?? "";
          inspectionDateController.text = propertyReport.inspectionDate ?? "";
          return Form(
            child: Column(
              children: [
                buildInspectionTextFormFeild(
                    overallScoreController, 'Overall Score'),
                buildInspectionTextFormFeild(
                    locationScoreController, 'Location Score'),
                buildInspectionTextFormFeild(
                    comfortScoreController, 'Comfort Score'),
                buildInspectionTextFormFeild(
                    inspectionDateController, 'Inspection Date'),
                GestureDetector(
                  onTap: () {
                    buildInspectionDialog(propertyReport);
                  },
                  child: Container(
                    height: 60,
                    width: width(context) * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: textColorLight.withOpacity(0.75),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'See All Details   ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColorDark),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: textColorDark,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: containerColor,
              ),
            ],
          );
        }
      },
    );
  }

  buildInspectionDialog(PropertyReport propertyReport) {
    final TextEditingController reportIdController = TextEditingController();
    final TextEditingController inspectionTimeController =
        TextEditingController();
    final TextEditingController reportDateController = TextEditingController();
    final TextEditingController agentNameController = TextEditingController();
    final TextEditingController agentContactController =
        TextEditingController();
    final TextEditingController clientNameController = TextEditingController();
    final TextEditingController clientAddressController =
        TextEditingController();
    final TextEditingController clientContactController =
        TextEditingController();
    final TextEditingController houseFacingController = TextEditingController();
    final TextEditingController houseAgeController = TextEditingController();
    final TextEditingController streetTypeController = TextEditingController();
    final TextEditingController houseTypeController = TextEditingController();
    final TextEditingController waterSourceController = TextEditingController();
    final TextEditingController sewageSourceController =
        TextEditingController();
    final TextEditingController noOfStoriesController = TextEditingController();
    final TextEditingController spaceBelowGradeController =
        TextEditingController();
    final TextEditingController garageController = TextEditingController();
    final TextEditingController utilityStatusController =
        TextEditingController();
    final TextEditingController occoupancyController = TextEditingController();
    final TextEditingController peoplePresentController =
        TextEditingController();

    reportIdController.text = propertyReport.reportId ?? '';
    reportDateController.text = propertyReport.reportDate ?? '';
    inspectionDateController.text = propertyReport.inspectionDate ?? '';
    inspectionTimeController.text = propertyReport.inspectionTime ?? '';
    agentNameController.text = propertyReport.agentName ?? '';
    agentContactController.text = propertyReport.agentContact ?? '';
    clientNameController.text = propertyReport.clientName ?? '';
    clientContactController.text = propertyReport.clientContact ?? '';
    clientAddressController.text = propertyReport.clientAddress ?? '';
    overallScoreController.text = propertyReport.overallScore ?? '';
    locationController.text = propertyReport.locationScore ?? '';
    comfortScoreController.text = propertyReport.confortScore ?? '';
    houseFacingController.text = propertyReport.houseFacing ?? '';
    houseAgeController.text = propertyReport.houseAge ?? '';
    streetTypeController.text = propertyReport.streetType ?? '';
    houseTypeController.text = propertyReport.houseType ?? '';
    waterSourceController.text = propertyReport.waterSource ?? '';
    sewageSourceController.text = propertyReport.sewageSource ?? '';
    noOfStoriesController.text = propertyReport.noOfStories ?? '';
    spaceBelowGradeController.text = propertyReport.spaceBelowGrade ?? '';
    garageController.text = propertyReport.garage ?? '';
    utilityStatusController.text = propertyReport.utilityStatus ?? '';
    occoupancyController.text = propertyReport.occoupancy ?? '';
    peoplePresentController.text = propertyReport.peoplePresent ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 1,
          backgroundColor: Colors.white,
          title: const Text(
            "Car Inspection Report",
            style: TextStyle(
              color: textColorDark,
            ),
          ),
          content: SizedBox(
            height: height(context) * 0.7,
            width: width(context) * 0.7,
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: [
                    buildInspectionTextFormFeild(
                        reportIdController, 'Report Id'),
                    buildInspectionTextFormFeild(
                        reportDateController, 'Report Date'),
                    buildInspectionTextFormFeild(
                        inspectionDateController, 'Inspection Date'),
                    buildInspectionTextFormFeild(
                        inspectionTimeController, 'Inspection Time'),
                    buildInspectionTextFormFeild(
                        agentNameController, 'Agent Name'),
                    buildInspectionTextFormFeild(
                        agentContactController, 'Agent Contact'),
                    buildInspectionTextFormFeild(
                        clientNameController, 'Client Name'),
                    buildInspectionTextFormFeild(
                        clientAddressController, 'Client Address'),
                    buildInspectionTextFormFeild(
                        clientContactController, 'Client Contact'),
                    buildInspectionTextFormFeild(
                        overallScoreController, 'Overall Score'),
                    buildInspectionTextFormFeild(
                        locationScoreController, 'Location Score'),
                    buildInspectionTextFormFeild(
                        comfortScoreController, 'Comfort Score'),
                    buildInspectionTextFormFeild(
                        houseFacingController, 'House Facing'),
                    buildInspectionTextFormFeild(
                        houseAgeController, 'House Age'),
                    buildInspectionTextFormFeild(
                        streetTypeController, 'Street Type'),
                    buildInspectionTextFormFeild(
                        houseTypeController, 'House Type'),
                    buildInspectionTextFormFeild(
                        waterSourceController, 'Water Source'),
                    buildInspectionTextFormFeild(
                        sewageSourceController, 'Sewage Source'),
                    buildInspectionTextFormFeild(
                        noOfStoriesController, 'No. Of Stories'),
                    buildInspectionTextFormFeild(
                        spaceBelowGradeController, 'Space Below Grade'),
                    buildInspectionTextFormFeild(garageController, 'garage'),
                    buildInspectionTextFormFeild(
                        utilityStatusController, 'Utility Status'),
                    buildInspectionTextFormFeild(
                        occoupancyController, 'occoupancy'),
                    buildInspectionTextFormFeild(
                        peoplePresentController, 'People Present'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
