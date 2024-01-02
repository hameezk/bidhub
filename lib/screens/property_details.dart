import 'package:bidhub/config/bottombar.dart';
import 'package:bidhub/config/loading_dialoge.dart';
import 'package:bidhub/config/size.dart';
import 'package:bidhub/config/snackbar.dart';
import 'package:bidhub/config/theme.dart';
import 'package:bidhub/models/user_model.dart';
import 'package:bidhub/screens/home_screen_seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../config/colors.dart';
import '../models/property_model.dart';

class PropertyDetails extends StatefulWidget {
  final PropertyModel propertyModel;
  const PropertyDetails({super.key, required this.propertyModel});

  @override
  State<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
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
  List imageLinks = [];
  DateTime? biddingDate;
  DateTime todayDate = DateTime.now();
  DateTime? startTime;
  DateTime? endTime;
  TimeOfDay? picked = TimeOfDay.now();
  Uuid uuid = const Uuid();
  List features = [];

  @override
  void initState() {
    areaController.text = widget.propertyModel.area ?? '';
    typeController.text = widget.propertyModel.type ?? '';
    descriptionController.text = widget.propertyModel.description ?? '';
    locationController.text = widget.propertyModel.location ?? '';
    bedroomController.text = widget.propertyModel.bedrooms ?? '';
    bathsController.text = widget.propertyModel.baths ?? '';
    startingBidController.text = widget.propertyModel.startingBid ?? '';
    startingDateController.text = widget.propertyModel.startDate ?? '';
    endDateController.text = widget.propertyModel.endDate ?? '';
    imageLinks = widget.propertyModel.images ?? [];
    features = widget.propertyModel.features ?? [];
    startTime = DateTime.parse(widget.propertyModel.startDate ?? "");
    endTime = DateTime.parse(widget.propertyModel.endDate ?? "");
    biddingDate = DateTime.parse(widget.propertyModel.startDate ?? "");
    super.initState();
  }

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
          "Auction Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColorDark,
            fontSize: 25,
          ),
        ),
        actions: [
          (UserModel.loggedinUser!.role == 'Customer')
              ? IconButton(
                  onPressed: () {
                    savebid();
                  },
                  icon: const Icon(
                    Icons.bookmark_border_sharp,
                    color: textColorDark,
                  ))
              : Container(
                  height: 0,
                ),
        ],
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
                        height: height(context) * 0.2,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: imageLinks.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: height(context) * 0.18,
                                width: height(context) * 0.18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: lightBlack,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      imageLinks[index],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
                      buildTextFormFeild(noneController, 'Features', ''),
                      GridView.builder(
                        padding: EdgeInsets.zero,
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
                          return Container(
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
                                      padding: const EdgeInsets.only(top: 4.0),
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
                          );
                        },
                      ),
                      const SizedBox(height: 50.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range_outlined,
                            color: textColorDark,
                          ),
                          Text(
                            (biddingDate != null)
                                ? DateFormat('  EEEE, MMM d, yyyy')
                                    .format(biddingDate!)
                                : 'Select Bidding Date ',
                            style: myTheme.textTheme.displaySmall!
                                .copyWith(color: textColorLight),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.more_time_rounded,
                            color: textColorDark,
                          ),
                          Text(
                            (startTime != null)
                                ? DateFormat('  h:mm a  -  ').format(startTime!)
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
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(containerColor)),
                        onPressed: () {
                          if (UserModel.loggedinUser!.role == 'Seller') {
                            withdrawAuction();
                          } else {
                            if (DateTime.parse(
                                        widget.propertyModel.startDate ?? '')
                                    .isBefore(DateTime.now()) &&
                                DateTime.parse(
                                        widget.propertyModel.endDate ?? '')
                                    .isAfter(DateTime.now())) {
                              // navigate(
                              //     context,
                              //     BiddingPage(
                              //         propertyModel: widget.propertyModel));
                            } else {
                              if (DateTime.now().isBefore(DateTime.parse(
                                  widget.propertyModel.startDate ?? ''))) {
                                showCustomSnackbar(
                                    context: context,
                                    content:
                                        'Bidding event has not started yet!');
                              } else {
                                showCustomSnackbar(
                                    context: context,
                                    content: 'Bidding event has been ended!');
                              }
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            (UserModel.loggedinUser!.role == 'Seller')
                                ? 'Withdraw Auction'
                                : 'Go to Bids',
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
            3,
          ),
        ],
      ),
    );
  }

  TextFormField buildTextFormFeild(
      TextEditingController controller, String label, String errorText) {
    return TextFormField(
      controller: controller,
      minLines: 1,
      maxLines: 10,
      readOnly: true,
      style: const TextStyle(
        fontSize: 16,
        color: secondaryColor,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 18,
          color: textColorLight,
          fontWeight: FontWeight.bold,
        ),
        border: InputBorder.none,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        }
        return null;
      },
    );
  }

  Future<void> withdrawAuction() async {
    showLoadingDialog(context, 'Withdrawing Auction');
    await FirebaseFirestore.instance
        .collection("auction")
        .doc(widget.propertyModel.id)
        .delete()
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 1),
            content: Text("Auction Withdrawed Successfully"),
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

  Future<void> savebid() async {
    UserModel userModel = UserModel.loggedinUser!;
    userModel.savedBids!.add(widget.propertyModel.id);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.id)
        .set(userModel.toMap())
        .then(
      (value) {
        UserModel.loggedinUser = userModel;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 1),
            content: Text("Profile Updated"),
          ),
        );
      },
    );
  }
}
