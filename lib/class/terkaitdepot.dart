import 'package:cloud_firestore/cloud_firestore.dart';

class TerkaitDepot {
  CollectionReference depotRef = Firestore.instance.collection('data_mitra');
  String idDepot='';
  TerkaitDepot({this.idDepot=''});

  Future<DocumentSnapshot> get getCekDepot async {
    DocumentSnapshot userData;
    await depotRef.document(idDepot.toString()).get().then((onValue){
      if (onValue.exists) {
        userData=onValue;
      }
    });
    return userData;
  }
}