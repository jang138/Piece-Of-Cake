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
GlobalKey<_BuyModifyState> buyModifyKey = GlobalKey();

class ReturnValue {
  String? result;
  ReturnValue({this.result});
}

class Arguments {
  LatLng center;
  ReturnValue? returnValue;
  Arguments({this.center: const LatLng(0.0, 0.0), this.returnValue});
}

class BuyModify extends StatefulWidget {
  final Party party;
  const BuyModify({Key? key, required this.party}) : super(key: key);

  @override
  State<BuyModify> createState() => _BuyModifyState();
}

class _BuyModifyState extends State<BuyModify> {
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
    PartyResVO partyResVO = PartyResVO(
        partyRdvDt: widget.party.partyRdvDt,
        partyRegDt: widget.party.partyRegDt,
        partyUpdDt: widget.party.partyUpdDt,
        partySeq: widget.party.partySeq,
        itemLink: this.itemLink!,
        partyAddr: this.addr,
        partyAddrDetail: this.addrDetail!,
        partyStatus: 1,
        partyBookmarkCount: 0,
        partyCode: '002',
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
    final response = await http.patch(
      Uri.parse('http://i7e203.p.ssafy.io:9090/party/${widget.party.partySeq}'),
      // body: jsonEncode(widget.party),
      body: jsonEncode(partyResVO),
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

  List<Marker> _markers = [];

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
        title: Text('BuyCreate'),
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.party.itemLink,
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 20),
                          onSaved: (val) {
                            setState(() {
                              if (val == null || val.isEmpty) {
                                itemLink = widget.party.itemLink;
                              } else {
                                itemLink = val as String;
                              }
                            });
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "제품링크";
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.party.partyTitle,
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 20),
                          onSaved: (val) {
                            setState(() {
                              if (val == null || val.isEmpty) {
                                name = widget.party.partyTitle;
                              } else {
                                name = val as String;
                              }
                            });
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "제목";
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.party.totalAmount,
                            suffixText: '원',
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 20),
                          onSaved: (val) {
                            setState(() {
                              if (val == null || val.isEmpty) {
                                totalAmount = widget.party.totalAmount;
                              } else {
                                totalAmount = val as String;
                              }
                            });
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "총 금액";
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                widget.party.partyMemberNumTotal.toString(),
                            suffixText: '명',
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 20),
                          onSaved: (val) {
                            setState(() {
                              if (val == null || val.isEmpty) {
                                memberNumTotal =
                                    widget.party.partyMemberNumTotal;
                              } else {
                                memberNumTotal = int.parse(val);
                              }
                            });
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "공구 인원";
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
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.party.partyContent,
                            ),
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 20),
                            onSaved: (val) {
                              setState(() {
                                if (val == null || val.isEmpty) {
                                  content = widget.party.partyContent;
                                } else {
                                  content = val as String;
                                }
                              });
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "내용";
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
                  widget.party.partyAddr,
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
          // Container(
          //   margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
          //   child: Wrap(children: [
          //     SizedBox(
          //       width: 200,
          //       height: 200,
          //       child: GoogleMap(
          //         markers: Set.from(_markers),
          //         myLocationEnabled: true,
          //         myLocationButtonEnabled: false,
          //         mapType: MapType.normal,
          //         onMapCreated: _onMapCreated,
          //         initialCameraPosition: CameraPosition(
          //           target: _center,
          //           zoom: 11.0,
          //         ),
          //       ),
          //     ),
          //   ]),
          // ),
        ],
      ),
    );
  }
}