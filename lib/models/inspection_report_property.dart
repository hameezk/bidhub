class PropertyReport {
  final String? reportId;
  final String? reportDate;
  final String? inspectionDate;
  final String? inspectionTime;
  final String? agentName;
  final String? agentContact;
  final String? clientName;
  final String? clientAddress;
  final String? clientContact;
  final String? overallScore;
  final String? locationScore;
  final String? confortScore;
  final String? houseFacing;
  final String? houseAge;
  final String? streetType;
  final String? houseType;
  final String? waterSource;
  final String? sewageSource;
  final String? noOfStories;
  final String? spaceBelowGrade;
  final String? garage;
  final String? utilityStatus;
  final String? occoupancy;
  final String? peoplePresent;

  PropertyReport({
    required this.reportId,
    required this.reportDate,
    required this.inspectionDate,
    required this.inspectionTime,
    required this.agentName,
    required this.agentContact,
    required this.clientName,
    required this.clientAddress,
    required this.clientContact,
    required this.overallScore,
    required this.locationScore,
    required this.confortScore,
    required this.houseFacing,
    required this.houseAge,
    required this.streetType,
    required this.houseType,
    required this.waterSource,
    required this.sewageSource,
    required this.noOfStories,
    required this.spaceBelowGrade,
    required this.garage,
    required this.utilityStatus,
    required this.occoupancy,
    required this.peoplePresent,
  });

  static PropertyReport parseInspectionReport(String? recognizedText) {
    var parts = recognizedText!.split('\n');
    String reportId = parts[3].replaceAll('Report Id: ', '').trim();
    String reportDate = parts[15].replaceAll('Report Date: ', '').trim();
    String inspectionDate = parts[4].replaceAll('Inspection Date: ', '').trim();
    String inspectionTime =
        parts[16].replaceAll('Inspection Time: ', '').trim();
    String agentName = parts[5].replaceAll('Agent Name: ', '').trim();
    String agentContact = parts[17].replaceAll('Agent Contact: ', '').trim();
    String clientName = parts[6].replaceAll('Client Name: ', '').trim();
    String clientAddress = parts[18].replaceAll('Client Address: ', '').trim();
    String clientContact = parts[7].replaceAll('Client Contact: ', '').trim();
    String overallScore = parts[19].replaceAll('Overall Score: ', '').trim();
    String locationScore = parts[8].replaceAll('Location Score: ', '').trim();
    String confortScore = parts[20].replaceAll('Comfort Score: ', '').trim();
    String houseFacing = parts[9].replaceAll('House Facing: ', '').trim();
    String houseAge = parts[21].replaceAll('House Age: ', '').trim();
    String streetType = parts[10].replaceAll('Street Type: ', '').trim();
    String houseType = parts[22].replaceAll('House Type: ', '').trim();
    String waterSource = parts[11].replaceAll('Water Source: ', '').trim();
    String sewageSource = parts[23].replaceAll('Sewage Source: ', '').trim();
    String noOfStories = parts[12].replaceAll('No. of Stories: ', '').trim();
    String spaceBelowGrade =
        parts[24].replaceAll('Space Below Grade: ', '').trim();
    String garage = parts[13].replaceAll('Garage: ', '').trim();
    String utilityStatus = parts[25].replaceAll('Utility Status: ', '').trim();
    String occoupancy = parts[14].replaceAll('Occupancy: ', '').trim();
    String peoplePresent = parts[26].replaceAll('People Present: ', '').trim();

    PropertyReport propertyReport = PropertyReport(
      reportId: reportId,
      reportDate: reportDate,
      inspectionDate: inspectionDate,
      inspectionTime: inspectionTime,
      agentName: agentName,
      agentContact: agentContact,
      clientName: clientName,
      clientAddress: clientAddress,
      clientContact: clientContact,
      overallScore: overallScore,
      locationScore: locationScore,
      confortScore: confortScore,
      houseFacing: houseFacing,
      houseAge: houseAge,
      streetType: streetType,
      houseType: houseType,
      waterSource: waterSource,
      sewageSource: sewageSource,
      noOfStories: noOfStories,
      spaceBelowGrade: spaceBelowGrade,
      garage: garage,
      utilityStatus: utilityStatus,
      occoupancy: occoupancy,
      peoplePresent: peoplePresent,
    );

    return propertyReport;
  }
}
