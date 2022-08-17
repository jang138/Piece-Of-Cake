import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:piece_of_cake/main.dart';
import 'package:piece_of_cake/models/kakao_login_model.dart';
import 'package:piece_of_cake/vo.dart';
import 'package:piece_of_cake/widgets/image_upload_widget.dart';
import 'package:piece_of_cake/widgets/map_setting.dart';
import 'package:provider/provider.dart';
// import 'package:piece_of_cake/widgets/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// GlobalKey<_ImageUploadState> globalKey = GlobalKey();
// GlobalKey<_MapSettingState> mapKey = GlobalKey();
GlobalKey<_DlvCreateState> dlvCreateKey = GlobalKey();

class ReturnValue {
  String? result;
  ReturnValue({this.result});
}

class Arguments {
  LatLng center;
  ReturnValue? returnValue;
  Arguments({this.center: const LatLng(0.0, 0.0), this.returnValue});
}

class DlvCreate extends StatefulWidget {
  const DlvCreate({Key? key}) : super(key: key);

  @override
  State<DlvCreate> createState() => _DlvCreateState();
}

class _DlvCreateState extends State<DlvCreate> {
  final formKey = GlobalKey<FormState>();

  String? itemLink = '';
  String? name = '';
  String? content = '';
  String? totalAmount = '';
  int memberNumTotal = 2;
  int? memberNumCurrent = 1;
  String addr = '';
  String? addrDetail = '';

  createParty(var kakaoUserProvider) {
    insertParty(kakaoUserProvider);
  }

  Future insertParty(var kakaoUserProvider) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }
    PartyReqVO partyReqVO = PartyReqVO(
        itemLink: this.itemLink!,
        partyAddr: this.addr,
        partyAddrDetail: this.addrDetail!,
        partyStatus: 1,
        partyBookmarkCount: 0,
        partyCode: '003',
        partyContent: content!,
        partyMemberNumCurrent: memberNumCurrent!,
        partyMemberNumTotal: memberNumTotal,
        partyRdvLat: this._center.latitude.toString(),
        partyRdvLng: this._center.longitude.toString(),
        partyTitle: name!,
        totalAmount: this.totalAmount!,
        partyMainImageUrl: 'assets/images/harry.png',
        userSeq: kakaoUserProvider.userResVO!.userSeq);
    // print(name);
    final response = await http.post(
      Uri.parse('http://i7e203.p.ssafy.io:9090/party'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(partyReqVO),
    );
    // print('response.body: ${response.body}');
    //print(Party.fromJson(jsonDecode(utf8.decode(response.bodyBytes))));
    // print(response.body.substring(response.body.indexOf("partySeq") + 10, response.body.indexOf("userSeq") - 2));
    int partySeq = int.parse(response.body.substring(
        response.body.indexOf("partySeq") + 10,
        response.body.indexOf("userSeq") - 2));
    imageKey.currentState?.addImage(partySeq);
  }

  // late GoogleMapController mapController;

  LatLng _center = LatLng(45.521563, -122.677433);

  String Rdv_Address = '주소 적힐곳';

  // List<Marker> _markers = [];

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  // int setRdvValue(LatLng center) {
  //   this._center = center;
  //   print(center);
  //   return 1;
  // }

  void _setRdvPoint(BuildContext context, LatLng center) async {
    print('testRdv');
    _center = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapSetting()),
    );
    //setState(() {});
    var Lat = _center.latitude;
    var Lng = _center.longitude;
    // _center = LatLng(Lat, Lng);
    final Uri getAddress = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$Lat,$Lng&key=AIzaSyBdf3QkB2KbMDzdfPXYxoBBfyFSk_fxBqk&language=ko');
    final response = await http.get(getAddress);
    Rdv_Address = jsonDecode(response.body)['results'][0]['formatted_address'];
    List<String> splitAddr = Rdv_Address.split(' ');
    addrDetail = splitAddr[splitAddr.length - 1];
    splitAddr.removeAt(0);
    for (int i = 0; i < splitAddr.length; i++) {
      addr += '${splitAddr[i]}';
      if (i != splitAddr.length - 1) addr += ' ';
    }
    ;
    // mapController.animateCamera(CameraUpdate.newCameraPosition(
    //     CameraPosition(target: _center, zoom: 15.0)));
    // _markers = [];
    // _markers.add(Marker(markerId: MarkerId("1"), position: _center));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final kakaoUserProvider =
        Provider.of<KakaoLoginModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('DlvCreate'),
        actions: [
          IconButton(
              onPressed: () {
                createParty(kakaoUserProvider);
              },
              icon: Icon(Icons.done))
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: ImageUploadWidget(key: imageKey),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.amber),
                          borderRadius: BorderRadius.circular((15))),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '배달업체링크',
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 20),
                          onSaved: (val) {
                            setState(() {
                              itemLink = val as String;
                            });
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please enter something";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.amber),
                          borderRadius: BorderRadius.circular((15))),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '제목',
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 20),
                          onSaved: (val) {
                            setState(() {
                              name = val as String;
                            });
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please enter something";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.amber),
                          borderRadius: BorderRadius.circular((15))),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '총 가격',
                            suffixText: '원',
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 20),
                          onSaved: (val) {
                            setState(() {
                              totalAmount = val as String;
                            });
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please enter something";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.amber),
                          borderRadius: BorderRadius.circular((15))),
                      child: SizedBox(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '내용',
                            ),
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 20),
                            onSaved: (val) {
                              setState(() {
                                content = val as String;
                              });
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please enter something";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.amber),
                borderRadius: BorderRadius.circular((15))),
            // height: 40,
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  Rdv_Address,
                  style: TextStyle(fontSize: 20),
                )),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.amber),
                borderRadius: BorderRadius.circular((15))),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: TextButton(
                child: Text('랑데뷰 포인트 설정'),
                onPressed: () {
                  _setRdvPoint(context, _center);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}