// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class PDFTicket extends StatefulWidget {
//   final url;
//   const PDFTicket({Key? key, this.url}) : super(key: key);

//   @override
//   State<PDFTicket> createState() => _PDFTicketState();
// }

// class _PDFTicketState extends State<PDFTicket> {
//   dynamic dataREvent;
//   static const color = Color.fromARGB(255, 130, 91, 8);
//   @override
//   void initState() {
//     getTicket(widget.url);
//     super.initState();
//   }

//   final doc = pw.Document();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//           leading: GestureDetector(
//             child: const Icon(Icons.arrow_back_ios),
//             onTap: () => Navigator.pop(context),
//           ),
//           backgroundColor: const Color.fromARGB(255, 153, 113, 4)),
//       body: PdfPreview(
//         build: (format) => _generatePdf(format, 'TICKET INFORMATIONS', context),
//       ),
//     );
//   }

//   Future<Uint8List> _generatePdf(
//       PdfPageFormat format, String title, BuildContext context) async {
//     final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
//     final font = await PdfGoogleFonts.nunitoExtraLight();
//     final bold = await PdfGoogleFonts.exoBold();
//     debugPrint(dataREvent['ticket_type'].toString());

//     pdf.addPage(pw.Page(
//       pageFormat: format,
//       build: (context) {
//         return dataREvent['ticket_type']==null
//             ? pw.Text('')
//             : pw.Column(
//                 children: [
//                   pw.SizedBox(
//                     width: 200,
//                     child: pw.FittedBox(
//                       child: pw.Text(title, style: pw.TextStyle(font: bold)),
//                     ),
//                   ),
//                   pw.SizedBox(
//                     height: 10,
//                   ),
//                   pw.Container(
//                     width: 400,
//                     // color: ,
//                     // height: MediaQuery.of(context).size.height * 0.06,
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.all(15),
//                       child: pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
//                         crossAxisAlignment: pw.CrossAxisAlignment.center,
//                         children: [
//                           pw.Column(
//                             mainAxisAlignment:
//                                 pw.MainAxisAlignment.spaceBetween,
//                             children: [
//                               pw.Text(
//                                 'TICKET TYPE',
//                                 style: pw.TextStyle(font: bold),
//                               ),
//                               pw.Text(
//                                   dataREvent['ticket_type'] != null
//                                       ? dataREvent['ticket_type'].toUpperCase()
//                                       : '',
//                                   style: pw.TextStyle(font: font))
//                             ],
//                           ),
//                           pw.Column(
//                             mainAxisAlignment:
//                                 pw.MainAxisAlignment.spaceBetween,
//                             children: [
//                               pw.Text(
//                                 'TICKETS',
//                                 style: pw.TextStyle(font: bold),
//                               ),
//                               pw.Text(dataREvent['quantity'].toString(),
//                                   style: pw.TextStyle(font: font))
//                             ],
//                           ),
//                           pw.Column(
//                             mainAxisAlignment:
//                                 pw.MainAxisAlignment.spaceBetween,
//                             children: [
//                               pw.Text(
//                                 'TOTAL PAID',
//                                 style: pw.TextStyle(font: bold),
//                               ),
//                               dataREvent['payment_method'] != "coins"
//                                   ? pw.Text(" ${dataREvent['amount']} ¥ ",
//                                       style: pw.TextStyle(font: font))
//                                   : pw.Text(" ${dataREvent['amount']}  Coins ",
//                                       style: pw.TextStyle(font: font))
//                             ],
//                           ),

//                           //ggdh
//                         ],
//                       ),
//                     ),
//                     // color: color,
//                   ),
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(16),
//                     child: pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       mainAxisAlignment: pw.MainAxisAlignment.start,
//                       children: [
//                         pw.Text('Title'),
//                         pw.SizedBox(
//                           height: 5,
//                         ),
//                         pw.Text(
//                           "EVENT NAME",
//                           style: pw.TextStyle(font: font),
//                         ),
//                         pw.SizedBox(
//                           height: 14,
//                         ),
//                         pw.Row(
//                           children: [
//                             pw.Column(
//                               mainAxisAlignment:
//                                   pw.MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: pw.CrossAxisAlignment.start,
//                               children: [
//                                 pw.Text(
//                                   'Place',
//                                   style: pw.TextStyle(font: bold),
//                                 ),
//                                 pw.Text("HOTEL LINDA",
//                                     style: pw.TextStyle(font: font))
//                               ],
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.only(left: 20),
//                               child: pw.Column(
//                                 mainAxisAlignment:
//                                     pw.MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                                 children: [
//                                   pw.Text(
//                                     'Date',
//                                     style: pw.TextStyle(font: bold),
//                                   ),
//                                   pw.Text("Wnd. 20 . 03. 2022",
//                                       style: pw.TextStyle(font: font))
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(16),
//                     child: pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       mainAxisAlignment: pw.MainAxisAlignment.start,
//                       children: [
//                         pw.Text(
//                           'NAME',
//                           style: pw.TextStyle(font: bold),
//                         ),
//                         pw.SizedBox(
//                           height: 5,
//                         ),
//                         pw.Text(
//                           "Bihango Justin Stark",
//                           style: pw.TextStyle(font: font),
//                         ),
//                         pw.SizedBox(
//                           height: 14,
//                         ),
//                         pw.Row(
//                           children: [
//                             pw.Column(
//                               mainAxisAlignment:
//                                   pw.MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: pw.CrossAxisAlignment.start,
//                               children: [
//                                 pw.Text(
//                                   'PHONE',
//                                   style: pw.TextStyle(font: bold),
//                                 ),
//                                 pw.Text("+946745464774",
//                                     style: pw.TextStyle(font: font))
//                               ],
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.only(left: 20),
//                               child: pw.Column(
//                                 mainAxisAlignment:
//                                     pw.MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                                 children: [
//                                   pw.Text(
//                                     'MAIL ADDRESS',
//                                     style: pw.TextStyle(font: bold),
//                                   ),
//                                   pw.Text("bihangokin@Gmail.com",
//                                       style: pw.TextStyle(font: font))
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//       },
//     ));

//     return pdf.save();
//   }

//   Future getTicket(api) async {
//     try {
//       var response = await http.get(Uri.parse(api));
//       dataREvent = jsonDecode(response.body);
//       return jsonDecode(response.body);
//     } catch (ex) {
//       //  debugPrint('EXCEPTION ====================$ex');
//       return null;
//     }
//   }
// }
