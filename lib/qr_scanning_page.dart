import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:wellibe_proj/top_bar.dart';

import 'assets/wellibe_colors.dart';


const String scanQRString = 'סריקת רופא';
const String cancelQRScanString = 'ביטול סריקה';

class QRScanningPage extends StatefulWidget {

  @override
  State<QRScanningPage> createState() => _QRScanningPageState();
}

class _QRScanningPageState extends State<QRScanningPage> {
  Future<void> scanQR() async {
    var result = await BarcodeScanner.scan();

    print(result.type); // The result type (barcode, cancelled, failed)
    if(result.type == ResultType.Barcode) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorInfoPage(doctorName: result.rawContent)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: TopBar(),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: AppColors.mainWhite,
              child: Center(
                child: ElevatedButton(
                  child: Text(
                    scanQRString,
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () => scanQR(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String yourDoctorIsString = 'המטפל/ת שלך הוא/היא';
const String doctorString = 'ד"ר יסמין כרמי';

class DoctorInfoPage extends StatelessWidget {
  final String doctorName;

  DoctorInfoPage({required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: AppColors.mainYellow,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  yourDoctorIsString,
                  style: TextStyle(fontSize: 20),
                ),
              ),

              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainWhite,
                    ),
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage('https://www.woolha.com/media/2020/03/eevee.png'),
                          ),
                        ),
                        Text(
                          doctorName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                        ),
                        Text(
                          'מתמחה במחלקה הכירוגית',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                        )
                      ],
                    ),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    primary: AppColors.buttonRed,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.favorite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

