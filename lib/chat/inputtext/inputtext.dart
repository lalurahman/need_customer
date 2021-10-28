import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatefulWidget {
  const InputText({Key key, @required this.idTransaksi, @required this.idUser, @required this.idCustomer}) : super(key: key);
  final String idTransaksi;
  final String idUser, idCustomer;

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  double widthMe = 45.0;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: Container()),
        Row(
          children: <Widget>[
            Container(
              height: widthMe,
              width: MediaQuery.of(context).size.width - 70,
              margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular((widthMe >= 90.0) ? 10.0 : 50.0), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2.0)]),
              child: TextField(
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: 20,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
                onChanged: (hasil) {
                  if (hasil.isNotEmpty) {
                    if (hasil.contains('\n') || hasil.length > 45) {
                      setState(() {
                        widthMe = 90.0;
                      });
                    } else {
                      setState(() {
                        widthMe = 45.0;
                      });
                    }
                  } else {
                    setState(() {
                      widthMe = 45.0;
                    });
                  }
                },
                controller: _textEditingController,
                decoration: InputDecoration(border: InputBorder.none, hintText: 'Masukkan Pesan Disini'),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (_textEditingController.text.isNotEmpty) {
                  String pesan = _textEditingController.text.toString();
                  setState(() {
                    _textEditingController.text = '';
                    widthMe = 45.0;
                  });
                  await Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).collection('list_chat').document().setData({
                    'created_at': DateTime.now(),
                    'updated_at': DateTime.now(),
                    'pesan': pesan.toString(),
                    'dari': 'customer',
                    'read': false,
                    'id_transaksi': widget.idTransaksi,
                    'id_depot': widget.idUser.toString(),
                    'id_user': widget.idCustomer.toString(),
                  });
                }
              },
              child: Container(
                height: 40.0,
                width: 40,
                margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(50.0), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2.0)]),
                child: Center(
                    child: Icon(
                  Icons.send,
                  size: 20.0,
                  color: Colors.white,
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
