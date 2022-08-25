import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

class PosScanner extends StatefulWidget {
  const PosScanner({Key? key}) : super(key: key);

  @override
  State<PosScanner> createState() => _PosScannerState();
}

class _PosScannerState extends State<PosScanner> {
  static const color = Color.fromARGB(255, 130, 91, 8);
  TextEditingController txturl = TextEditingController();
  var urlvalue = '';
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();
  var _scan = false;
  var showInput = false;

  void _printScreen() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();
      final image = await WidgetWraper.fromKey(
        key: _printKey,
        pixelRatio: 2.0,
      );

      doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a5,
          build: (pw.Context context) {
            return pw.SizedBox(
                child: pw.Center(
                    child: pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 0, right: 0),
                        child: pw.Container(
                          child: pw.Image(image),
                        ))));
          }));
      return doc.save();
    });
  }

  var data;
  String myToken = '';
  Future getSession() async {
    final session = await SharedPreferences.getInstance();
    data = {
      'id': session.getString('id').toString(),
      'token': session.getString('user_token'),
      'fullname': session.getString('user_names'),
      'phone': session.getString('user_phone'),
    };

    setState(() {
      myToken = data['token'].toString();
    });
  }

  Future destroySession() async {
    final session = await SharedPreferences.getInstance();
    session.clear();
    Navigator.of(context).pushNamed('/signin');
  }

  @override
  void initState() {
    getSession();
    super.initState();
  }

  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller!.resumeCamera();
  //   }
  // }

  String _setdate(timestamp) {
    DateTime date = DateTime.parse(timestamp);
    String formattedDate = DateFormat('dd MMM,yyyy | HH:mm a').format(date);
    return formattedDate;
  }

  @override
  void dispose() {
    super.dispose();
    // controller?.dispose();
    txturl.dispose();
  }

  _desablekey() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
      // FocusScope.of(context).requestFocus(FocusNode());
    }
  }

final MethodChannel _methodChannel =
      const MethodChannel('channel.haaho');
  Future posPrint() async {
    try {
      await _methodChannel.invokeMethod("print-ticket");
    } on PlatformException catch (e) {
      print("exceptiong");
    }
  }

  var focusNode = FocusNode();
  bool isSwitched = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // Barcode? result;
  // QRViewController? controller;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 10,
            width: 20,
            child: const Icon(
              Icons.person,
              color: color,
              size: 16,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(100)),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0),
          child: Row(
            children: [
              const SizedBox(
                width: 12,
              ),
              Text(
                data == null ? 'Haaho Event' : data['fullname'],
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                posPrint();
              },
              icon: const Icon(Icons.print)),
          IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text(
                          'Are you sure you want to disconnect your account ...?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'CANCEL',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 72, 71, 71)),
                            )),
                        TextButton(
                            onPressed: () => destroySession(),
                            child: const Text(
                              'YES',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ))
                      ],
                    );
                  }),
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ))
        ],
        backgroundColor: color,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: SizedBox(
          height: kIsWeb ? height * 0.8 : height,
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showInput == false
                  ? const Text('')
                  : Column(children: [
                      Row(
                        children: [
                          Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor:
                                const Color.fromARGB(255, 242, 185, 92),
                            activeColor: color,
                          ),
                          const Text('Camera')
                        ],
                      ),
                      SizedBox(
                        height: 10,
                        child: TextField(
                            controller: txturl,
                            cursorColor: Colors.white,
                            onTap: () {
                              _desablekey();
                            },
                            focusNode: focusNode,
                            style: const TextStyle(
                                color: Color.fromARGB(79, 35, 35, 35),
                                fontSize: 10),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            onChanged: (text) => setState(() {
                                  urlvalue = text.toString();
                                  _scan = true;
                                  focusNode.requestFocus();
                                })),
                      ),
                      isSwitched
                          ? Container(
                              width: width,
                              height: height * .36,
                              color: Colors.black,
                              // child: Padding(
                              //   padding: const EdgeInsets.all(20),
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(12)),
                              //     child: QRView(
                              //       key: qrKey,
                              //       onQRViewCreated: _onQRViewCreated,
                              //     ),
                              //   ),
                              // ),
                            )
                          : const Text('')
                    ]),
              Expanded(
                flex: 2,
                child: Center(
                  child: (_scan == true)
                      ? FutureBuilder(
                          future: getTicket(urlvalue),
                          builder: (context, AsyncSnapshot ticket) {
                            showInput = false;
                            if (ticket.connectionState ==
                                ConnectionState.none) {
                              return const Text('no connection now....');
                            }
                            if (ticket.connectionState ==
                                ConnectionState.waiting) {
                              return RepaintBoundary(
                                  key: _printKey,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(
                                        height: 13,
                                        width: 13,
                                        child: CircularProgressIndicator(
                                          backgroundColor: color,
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text('Please wait, loading data...!')
                                    ],
                                  ));
                            }
                            if (ticket.connectionState ==
                                ConnectionState.active) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.rotate_left_rounded,
                                    size: 18.0,
                                    color: Color.fromARGB(255, 35, 87, 241),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text('Connection is activing...!')
                                ],
                              );
                            }
                            if (ticket.connectionState ==
                                ConnectionState.done) {
                              showInput = false;
                              _desablekey();
                              if (ticket.data == null) {
                                return RepaintBoundary(
                                    key: _printKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.cancel_sharp,
                                              size: 36.0,
                                              color: Color.fromARGB(
                                                  255, 234, 39, 25),
                                            ),
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            txturl.text == ''
                                                ? const Text(
                                                    'There is no ticket scanned')
                                                : const Text(
                                                    'This QR Code is not valid for Haaho application...!')
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 9,
                                        ),
                                      ],
                                    ));
                              }
                            }

                            if (ticket.data['is_used'] == true) {
                              return RepaintBoundary(
                                  key: _printKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.stop_screen_share_sharp,
                                            size: 36.0,
                                            color: Color.fromARGB(
                                                255, 136, 241, 16),
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          txturl.text == ''
                                              ? const Text(
                                                  'There is no ticket scanned')
                                              : const Text(
                                                  'This ticket is already used, try an other...!')
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 9,
                                      ),
                                    ],
                                  ));
                            }

                            if (ticket.data['url'] == null) {
                              return RepaintBoundary(
                                  key: _printKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.cancel_sharp,
                                            size: 36.0,
                                            color: Color.fromARGB(
                                                255, 234, 39, 25),
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          txturl.text == ''
                                              ? const Text(
                                                  'There is no ticket scanned')
                                              : const Text(
                                                  'Sorry,this ticket is not valid, try again...!')
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 9,
                                      ),
                                    ],
                                  ));
                            } else {
                              // controller?.stopCamera();
                              return Padding(
                                padding: const EdgeInsets.only(left: 0, top: 0),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RepaintBoundary(
                                      key: _printKey,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Column(
                                            children: [
                                              const Text(
                                                'TICKET INFORMATIONS ',
                                                style: TextStyle(
                                                    color: color,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              QrImage(
                                                data: txturl.text,
                                                version: QrVersions.auto,
                                                size: kIsWeb ? 170.0 : 100,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15, bottom: 15),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'TICKET TYPE',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        229,
                                                                        220,
                                                                        193)),
                                                          ),
                                                          Text(
                                                              ticket
                                                                  .data[
                                                                      'ticket_type']
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white))
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'TICKETS',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        229,
                                                                        220,
                                                                        193)),
                                                          ),
                                                          Text(
                                                              ticket
                                                                  .data[
                                                                      'quantity']
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white))
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'TOTAL PAID',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        229,
                                                                        220,
                                                                        193)),
                                                          ),
                                                          ticket.data['payment_method'] !=
                                                                  "coins"
                                                              ? Text(
                                                                  " ${ticket.data['amount']} ¥ ",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white))
                                                              : Text(
                                                                  " ${ticket.data['amount']} Coins ",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                color: color,
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('Title'),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "${ticket.data['event']['name']}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    const SizedBox(
                                                      height: 14,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'Place',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Text(
                                                                "${ticket.data['event']['place']}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        color))
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                'Date',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Text(
                                                                  _setdate(ticket
                                                                              .data[
                                                                          'event']
                                                                      [
                                                                      'date_time']),
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          color))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 11,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: const Color.fromARGB(
                                                    255, 160, 151, 126),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('Fullname'),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "${ticket.data['owner']['first_name']} ${ticket.data['owner']['last_name']} ${ticket.data['owner']['username']}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    const SizedBox(
                                                      height: 14,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'Phone',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Text(
                                                                "${ticket.data['owner']['phone_number']}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        color))
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                'Email',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Text(
                                                                  "${ticket.data['owner']['email']}",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          color))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 26,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'This Ticket is Valid for the event...!',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),

                                //tatatatatatata
                              );
                            }
                          })
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Image.asset(
                                  'assets/nodata.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'TICKET INFORMATIONS',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'Please scan a QR Code to get ticket validity !!',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 99, 98, 98)),
                              ),
                            ]),
                ),
              )
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          setState(() {
            _scan = false;
            showInput = true;
            txturl.text = '';
            focusNode.requestFocus();
          });
        }),
        child: const Icon(Icons.qr_code_scanner_sharp),
        backgroundColor: color,
      ),
    );
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       result = scanData;
  //     });
  //   });
  // }

  Future cancelTicket(url, value) async {
    try {
      await http.put(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${data['token'].toString()}'
      }, body: {
        "is_used": value
      });
    } catch (ex) {
      //  debugPrint('EXCEPTION ====================$ex');
      return null;
    }
  }

  Future getTicket(api) async {
    try {
      var response = await http.get(
        Uri.parse(api),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${data['token'].toString()}'
        },
      );
      _desablekey();
      return jsonDecode(response.body);
    } catch (ex) {
      //  debugPrint('EXCEPTION ====================$ex');
      return null;
    }
  }
}
