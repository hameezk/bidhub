class CarReport {
  final String? reportId;
  final String? reportDate;
  final String? inspectionDate;
  final String? inspectionTime;
  final String? agentName;
  final String? agentContact;
  final String? clientName;
  final String? carNumber;
  final String? clientContact;
  final String? overallScore;
  final String? bodyScore;
  final String? engineScore;
  final String? carMake;
  final String? carModel;
  final String? carVarient;
  final String? carRegistration;
  final String? engineNo;
  final String? chasisNo;
  final String? carColor;
  final String? accidented;
  final String? bodyType;
  final String? seatingCapacity;
  final String? engineCapacity;
  final String? milage;

  CarReport({
    required this.reportId,
    required this.reportDate,
    required this.inspectionDate,
    required this.inspectionTime,
    required this.agentName,
    required this.agentContact,
    required this.clientName,
    required this.carNumber,
    required this.clientContact,
    required this.overallScore,
    required this.bodyScore,
    required this.engineScore,
    required this.carMake,
    required this.carModel,
    required this.carVarient,
    required this.carRegistration,
    required this.engineNo,
    required this.chasisNo,
    required this.carColor,
    required this.accidented,
    required this.bodyType,
    required this.seatingCapacity,
    required this.engineCapacity,
    required this.milage,
  });

  static CarReport parseInspectionReport(String? recognizedText) {
    var parts = recognizedText!.split('\n');
    String reportId = parts[3].replaceAll('Report Id: ', '').trim();
    String reportDate = parts[15].replaceAll('Report Date: ', '').trim();
    String inspectionDate = parts[4].replaceAll('Inspection Date: ', '').trim();
    String inspectionTime =
        parts[16].replaceAll('Inspection Time: ', '').trim();
    String agentName = parts[5].replaceAll('Agent Name: ', '').trim();
    String agentContact = parts[17].replaceAll('Agent Contact: ', '').trim();
    String clientName = parts[6].replaceAll('Client Name: ', '').trim();
    String carNumber = parts[18].replaceAll('Car Number: ', '').trim();
    String clientContact = parts[7].replaceAll('Client Contact: ', '').trim();
    String overallScore = parts[19].replaceAll('Overall Score: ', '').trim();
    String bodyScore = parts[8].replaceAll('Body Score: ', '').trim();
    String engineScore = parts[20].replaceAll('Engine Score: ', '').trim();
    String carMake = parts[9].replaceAll('Car Make: ', '').trim();
    String carModel = parts[21].replaceAll('Car Model: ', '').trim();
    String carVarient = parts[10].replaceAll('Car Varient: ', '').trim();
    String carRegistration =
        parts[22].replaceAll('Car Registration: ', '').trim();
    String engineNo = parts[11].replaceAll('Engine No.: ', '').trim();
    String chasisNo = parts[23].replaceAll('Chasis No.: ', '').trim();
    String carColor = parts[12].replaceAll('Car Color: ', '').trim();
    String accidented = parts[24].replaceAll('Accidented: ', '').trim();
    String bodyType = parts[13].replaceAll('Body Type: ', '').trim();
    String seatingCapacity =
        parts[25].replaceAll('Seating Capacity: ', '').trim();
    String engineCapacity =
        parts[14].replaceAll('Engine Capacity: ', '').trim();
    String milage = parts[26].replaceAll('Milage: ', '').trim();

    CarReport carReport = CarReport(
      reportId: reportId,
      reportDate: reportDate,
      inspectionDate: inspectionDate,
      inspectionTime: inspectionTime,
      agentName: agentName,
      agentContact: agentContact,
      clientName: clientName,
      carNumber: carNumber,
      clientContact: clientContact,
      overallScore: overallScore,
      bodyScore: bodyScore,
      engineScore: engineScore,
      carMake: carMake,
      carModel: carModel,
      carVarient: carVarient,
      carRegistration: carRegistration,
      engineNo: engineNo,
      chasisNo: chasisNo,
      carColor: carColor,
      accidented: accidented,
      bodyType: bodyType,
      seatingCapacity: seatingCapacity,
      engineCapacity: engineCapacity,
      milage: milage,
    );

    return carReport;
  }
}
