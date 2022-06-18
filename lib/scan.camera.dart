import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  static const color = Color.fromARGB(255, 130, 91, 8);
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  final _scanCode = 'Scan a code';
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haaho scanner ticket'),
        backgroundColor: color,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: (result != null)
                  ? FutureBuilder(
                      future: getTicket(result!.code.toString()),
                      builder: (context, AsyncSnapshot ticket) {
                        if (ticket.connectionState == ConnectionState.none) {
                          return const Text('no connection now....');
                        }
                        if (ticket.connectionState == ConnectionState.waiting) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              Text('Ticket scanned, loading data....')
                            ],
                          );
                        }
                        if (ticket.connectionState == ConnectionState.active) {
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
                        if (ticket.connectionState == ConnectionState.done) {
                          controller!.stopCamera();
                          if (ticket.data == null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.cancel_sharp,
                                      size: 18.0,
                                      color: Color.fromARGB(255, 234, 39, 25),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                        'Sorry,this ticket is not valid, try again...!')
                                  ],
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                OutlinedButton(
                                  onPressed: () => controller!.resumeCamera(),
                                  child: const Text(
                                    'Refresh',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: color),
                                ),
                              ],
                            );
                          }
                        }

                        return ticket.data['url'] == null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.cancel_sharp,
                                        size: 18.0,
                                        color: Color.fromARGB(255, 234, 39, 25),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                          'Sorry,this ticket is not valid, try again...!')
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 9,
                                  ),
                                  OutlinedButton(
                                    onPressed: () => controller!.resumeCamera(),
                                    child: const Text(
                                      'Refresh',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor: color),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.all(6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // const Icon(
                                        //   Icons.verified_user_rounded,
                                        //   color: Colors.green,size: 32,
                                        // ),
                                        Container(
                                          height: 90,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                              image: NetworkImage(ticket
                                                  .data['event']['image']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${ticket.data['event']['name']}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                            const SizedBox(
                                              height: 1,
                                            ),
                                            Text(
                                              "${ticket.data['event']['place']}",
                                              style: const TextStyle(),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              ticket.data['ticket_type']
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "Ticket(s) count : ${ticket.data['quantity']}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            ticket.data['payment_method'] !=
                                                    "coins"
                                                ? Text(
                                                    "Amount paid : ${ticket.data['amount']} ¥ ",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black54),
                                                  )
                                                : Text(
                                                    "Amount paid : ${ticket.data['amount']} Coins",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black54),
                                                  ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            const Text(
                                              "Client Informations",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              "${ticket.data['owner']['first_name']} ${ticket.data['owner']['last_name']} ${ticket.data['owner']['username']}",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              " ${ticket.data['owner']['email']}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black87),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "${ticket.data['owner']['phone_number']}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: const [
                                        Icon(Icons.check_circle,
                                            color: Colors.green),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'This Ticket is Valid for the event...!',
                                          style: TextStyle(color: Colors.green),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              result = null;
                                            });
                                          },
                                          child: const Text(
                                            'SCAN A NEW TICKET',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor: color),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                      })
                  : Text(_scanCode),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future getTicket(api) async {
    try {
      var response = await http.get(Uri.parse(api));
      return jsonDecode(response.body);
    } catch (ex) {
      //  debugPrint('EXCEPTION ====================$ex');
      return null;
    }
  }
}
