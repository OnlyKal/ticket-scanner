// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:http/http.dart' as http;

// class Camera extends StatefulWidget {
//   const Camera({Key? key}) : super(key: key);

//   @override
//   State<Camera> createState() => _CameraState();
// }

// class _CameraState extends State<Camera> {
//   static const color = Color.fromARGB(255, 130, 91, 8);
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode? result;
//   QRViewController? controller;

//   final _scanCode = 'Scan a code';
//   @override
//   void reassemble() {
//     super.reassemble();
//     // if (Platform.isAndroid) {
//     //   controller!.pauseCamera();
//     // } else if (Platform.isIOS) {
//     //   controller!.resumeCamera();
//     // }
//   }

//   @override
//   void initState() {
//     controller?.resumeCamera();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Haaho scanner ticket'),
//           backgroundColor: color,
//         ),
//         body: SingleChildScrollView(
//             child: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: <Widget>[
//               (result == null)
//                   ? Expanded(
//                       flex: 2,
//                       child: QRView(
//                         key: qrKey,
//                         onQRViewCreated: _onQRViewCreated,
//                       ),
//                     )
//                   : Container(
//                       height: MediaQuery.of(context).size.height * 0.3,
//                       width: MediaQuery.of(context).size.width,
//                       decoration: const BoxDecoration(
//                           color: Color.fromARGB(83, 245, 226, 185),
//                           // borderRadius: BorderRadius.circular(13),
//                           image: DecorationImage(
//                               fit: BoxFit.cover,
//                               opacity: 0.1,
//                               image: AssetImage('assets/unnamed.png'))),
//                       child: Center(
//                         child: GestureDetector(
//                             child: OutlinedButton(
//                           style: OutlinedButton.styleFrom(
//                               backgroundColor:
//                                   const Color.fromARGB(255, 153, 113, 4)),
//                           onPressed: () {
//                             setState(() {
//                               result = null;
//                             });
//                           },
//                           child: const Text(
//                             'Check new ticket',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         )),
//                       )),
//               Expanded(
//                 flex: 2,
//                 child: Center(
//                   child: (result != null)
//                       ? FutureBuilder(
//                           future: getTicket(result!.code.toString()),
//                           builder: (context, AsyncSnapshot ticket) {
//                             if (ticket.connectionState ==
//                                 ConnectionState.none) {
//                               return const Text('no connection now....');
//                             }
//                             if (ticket.connectionState ==
//                                 ConnectionState.waiting) {
//                               return Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: const [
//                                   SizedBox(
//                                     height: 13,
//                                     width: 13,
//                                     child: CircularProgressIndicator(
//                                       backgroundColor: color,
//                                       color: Colors.white,
//                                       strokeWidth: 2,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 8,
//                                   ),
//                                   Text('Please wait, loading data...!')
//                                 ],
//                               );
//                             }
//                             if (ticket.connectionState ==
//                                 ConnectionState.active) {
//                               return Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: const [
//                                   Icon(
//                                     Icons.rotate_left_rounded,
//                                     size: 18.0,
//                                     color: Color.fromARGB(255, 35, 87, 241),
//                                   ),
//                                   SizedBox(
//                                     width: 8,
//                                   ),
//                                   Text('Connection is activing...!')
//                                 ],
//                               );
//                             }
//                             if (ticket.connectionState ==
//                                 ConnectionState.done) {
//                               if (ticket.data == null) {
//                                 return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: const [
//                                         Icon(
//                                           Icons.cancel_sharp,
//                                           size: 18.0,
//                                           color:
//                                               Color.fromARGB(255, 234, 39, 25),
//                                         ),
//                                         SizedBox(
//                                           width: 8,
//                                         ),
//                                         Text(
//                                             'No data for this ticket, try again...!')
//                                       ],
//                                     ),
//                                     const SizedBox(
//                                       height: 9,
//                                     ),
//                                     OutlinedButton(
//                                       onPressed: () => setState(() {
//                                         result = null;
//                                       }),
//                                       child: const Text(
//                                         'Refresh',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                       style: OutlinedButton.styleFrom(
//                                           backgroundColor: color),
//                                     ),
//                                   ],
//                                 );
//                               }
//                             }
//                             if (ticket.data['is_used'] == true) {
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: const [
//                                       Icon(
//                                         Icons.cancel_sharp,
//                                         size: 18.0,
//                                         color: Color.fromARGB(255, 234, 39, 25),
//                                       ),
//                                       SizedBox(
//                                         width: 8,
//                                       ),
//                                       Text(
//                                           'This ticket is already used, try an other...!')
//                                     ],
//                                   ),
//                                   const SizedBox(
//                                     height: 9,
//                                   ),
//                                   OutlinedButton(
//                                     onPressed: () => setState(() {
//                                       // result = null;
//                                     }),
//                                     child: const Text(
//                                       'Refresh',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                     style: OutlinedButton.styleFrom(
//                                         backgroundColor: color),
//                                   ),
//                                 ],
//                               );
//                             }

//                             if (ticket.data['url'] == null) {
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: const [
//                                       Icon(
//                                         Icons.cancel_sharp,
//                                         size: 18.0,
//                                         color: Color.fromARGB(255, 234, 39, 25),
//                                       ),
//                                       SizedBox(
//                                         width: 8,
//                                       ),
//                                       Text(
//                                           'Sorry,this ticket is not valid, try again...!')
//                                     ],
//                                   ),
//                                   const SizedBox(
//                                     height: 9,
//                                   ),
//                                   OutlinedButton(
//                                     onPressed: () => setState(() {
//                                       result = null;
//                                     }),
//                                     child: const Text(
//                                       'Refresh',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                     style: OutlinedButton.styleFrom(
//                                         backgroundColor: color),
//                                   ),
//                                 ],
//                               );
//                             } else {
//                               //  cancelTicket(
//                               //         ticket.data['url'].toString(), 'true');
//                               return Padding(
//                                 padding:
//                                     const EdgeInsets.only(left: 13, top: 8),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     const SizedBox(
//                                       height: 12,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       children: [
//                                         // const Icon(
//                                         //   Icons.verified_user_rounded,
//                                         //   color: Colors.green,size: 32,
//                                         // ),
//                                         const Text(
//                                           'TICKET INFORMATIONS ',
//                                           style: TextStyle(
//                                               color: color,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         const SizedBox(
//                                           height: 10,
//                                         ),
//                                         Container(
//                                           height: 90,
//                                           width: 90,
//                                           decoration: BoxDecoration(
//                                             color: Colors.black38,
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             image: DecorationImage(
//                                               image: NetworkImage(ticket
//                                                   .data['event']['image']),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           height: 10,
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ticket.data['event']['name']}",
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.black),
//                                             ),
//                                             const SizedBox(
//                                               height: 1,
//                                             ),
//                                             Text(
//                                               "${ticket.data['event']['place']}",
//                                               style: const TextStyle(),
//                                             ),
//                                             const SizedBox(
//                                               height: 3,
//                                             ),
//                                             Text(
//                                               ticket.data['ticket_type']
//                                                   .toUpperCase(),
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.black54),
//                                             ),
//                                             const SizedBox(
//                                               height: 3,
//                                             ),
//                                             Text(
//                                               "Ticket(s) count : ${ticket.data['quantity']}",
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.black54),
//                                             ),
//                                             const SizedBox(
//                                               height: 3,
//                                             ),
//                                             ticket.data['payment_method'] !=
//                                                     "coins"
//                                                 ? Text(
//                                                     "Amount paid : ${ticket.data['amount']} ¥ ",
//                                                     style: const TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.black54),
//                                                   )
//                                                 : Text(
//                                                     "Amount paid : ${ticket.data['amount']} Coins",
//                                                     style: const TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.black54),
//                                                   ),
//                                             const SizedBox(
//                                               height: 13,
//                                             ),
//                                             const Text(
//                                               'CLIENT INFORMATIONS ',
//                                               style: TextStyle(
//                                                   color: color,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             const SizedBox(
//                                               height: 7,
//                                             ),
//                                             Text(
//                                               "${ticket.data['owner']['first_name']} ${ticket.data['owner']['last_name']} ${ticket.data['owner']['username']}",
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.black),
//                                             ),
//                                             const SizedBox(
//                                               height: 3,
//                                             ),
//                                             Text(
//                                               " ${ticket.data['owner']['email']}",
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.normal,
//                                                   color: Colors.black87),
//                                             ),
//                                             const SizedBox(
//                                               height: 3,
//                                             ),
//                                             Text(
//                                               "${ticket.data['owner']['phone_number']}",
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.normal,
//                                                   color: Colors.black87),
//                                             ),
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                     const SizedBox(
//                                       height: 8,
//                                     ),
//                                     Row(
//                                       children: const [
//                                         Icon(
//                                           Icons.check_circle,
//                                           color: Colors.green,
//                                           size: 26,
//                                         ),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         Text(
//                                           'This Ticket is Valid for the event...!',
//                                           style: TextStyle(
//                                               color: Colors.green,
//                                               fontWeight: FontWeight.bold),
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }
//                           })
//                       : Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                               SizedBox(
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.1,
//                                 width: MediaQuery.of(context).size.width * 0.3,
//                                 child: Image.asset(
//                                   'assets/nodata.png',
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               const Text(
//                                 'TICKET INFORMATIONS',
//                                 style: TextStyle(
//                                     fontSize: 15, fontWeight: FontWeight.w900),
//                               ),
//                               const SizedBox(height: 3),
//                               const Text(
//                                 'Please scan a QR Code to get ticket validity !!',
//                                 style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w300,
//                                     color: Color.fromARGB(255, 99, 98, 98)),
//                               ),
//                             ]),
//                 ),
//               )
//             ],
//           ),
//         )));
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//         debugPrint(result.toString());
//       });
//     });
//   }

//   @override
//   void dispose() {
//     controller?.stopCamera();
//     controller?.dispose();
//     super.dispose();
//   }

//   Future getTicket(api) async {
//     try {
//       var response = await http.get(Uri.parse(api));
//       return jsonDecode(response.body);
//     } catch (ex) {
//       //  debugPrint('EXCEPTION ====================$ex');
//       return null;
//     }
//   }
// }

// Future cancelTicket(url, value) async {
//   await http.put(Uri.parse(url), body: {"is_used": value});
// }
