import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

  void _printScreen() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();

      final image = await WidgetWraper.fromKey(
        key: _printKey,
        pixelRatio: 2.0,
      );

      doc.addPage(pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return  pw.Padding(padding: const pw.EdgeInsets.only(left: 0,right: 0), child: pw.Container(
         

                child: pw.Image(image),
              
            ));
          }));

      return doc.save();
    });
  }

  @override
  Widget build(BuildContext context) {
  


  


    return Scaffold(
      appBar: AppBar(
        title: const Text('Haaho scanner ticket'),
        backgroundColor: color,
      ),
      body: SingleChildScrollView(
       
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () =>_printScreen(),
                        // onTap: () => Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const PDFhtml(
                                  
                        //           )),
                        // ),
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: (txturl.text != '')
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Icon(Icons.print),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(' Print')
                                    ],
                                  )
                                : null),
                      ),
                    ),
                   TextField(
                      controller: txturl,
                      cursorColor: color,
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: color))),
                      autofocus: true,
                      onChanged: (text) => setState(() {
                        setState(() {
                          urlvalue = text.toString();
                        });
                      }),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                      // height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: (txturl.text != '')
                            ? FutureBuilder(
                                future: getTicket(urlvalue),
                                builder: (context, AsyncSnapshot ticket) {
                                  if (ticket.connectionState ==
                                      ConnectionState.none) {
                                    return const Text('no connection now....');
                                  }
                                  if (ticket.connectionState ==
                                      ConnectionState.waiting) {
                                    return Row(
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
                                    );
                                  }
                                  if (ticket.connectionState ==
                                      ConnectionState.active) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                    if (ticket.data == null) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.cancel_sharp,
                                                size: 18.0,
                                                color: Color.fromARGB(
                                                    255, 234, 39, 25),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                  'This QR Code is not valid for Haaho application...!')
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 9,
                                          ),
                                          OutlinedButton(
                                            onPressed: () => setState(() {
                                              // result = null;
                                            }),
                                            child: const Text(
                                              'Refresh',
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                                backgroundColor: color),
                                          ),
                                        ],
                                      );
                                    }
                                  }
        
                                  if (ticket.data['is_used'] == true) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.cancel_sharp,
                                              size: 18.0,
                                              color: Color.fromARGB(
                                                  255, 234, 39, 25),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                                'This ticket is already used, try an other...!')
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 9,
                                        ),
                                        OutlinedButton(
                                          onPressed: () => setState(() {
                                            // result = null;
                                          }),
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
        
                                  if (ticket.data['url'] == null) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.cancel_sharp,
                                              size: 18.0,
                                              color: Color.fromARGB(
                                                  255, 234, 39, 25),
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
                                          onPressed: () => setState(() {
                                            // result = null;
                                          }),
                                          child: const Text(
                                            'Refresh',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor: color),
                                        ),
                                      ],
                                    );
                                  } else {
                                    // cancelTicket(
                                    //     ticket.data['url'].toString(), 'true');
                                    return RepaintBoundary(
            key: _printKey,  child:Padding(
                                      padding:
                                          const EdgeInsets.only(left: 0, top: 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // const SizedBox(
                                          //   height: 12,
                                          // ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // const Icon(
                                              //   Icons.verified_user_rounded,
                                              //   color: Colors.green,size: 32,
                                              // ),
                                              const Text(
                                                'TICKET INFORMATIONS ',
                                                style: TextStyle(
                                                    color: color,
                                                    fontWeight: FontWeight.bold,fontSize: 20),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              QrImage(
                                                data: txturl.text,
                                                version: QrVersions.auto,
                                                size: 170.0,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
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
                                                              ticket.data[
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
                                                              ticket.data[
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
                                                padding: const EdgeInsets.all(16),
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
                                                                    color: color))
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(left: 20),
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
                                                                  "${ticket.data['event']['place']}",
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
                                                padding: const EdgeInsets.all(16),
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
                                                                    color: color))
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(left: 20),
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
                                                    fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              OutlinedButton(
                                                onPressed: () => setState(() {
                                                  txturl.text = '';
                                                }),
                                                child: const Text(
                                                  'Scan new ticket',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                    backgroundColor: color),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                          )      );
                                  }
                                })
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height *
                                          0.1,
                                      width:
                                          MediaQuery.of(context).size.width * 0.3,
                                      child: Image.asset(
                                        'assets/nodata.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'TICKET INFORMATIONS',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900),
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
      
    );
  }

  @override
  void dispose() {
    txturl.dispose();
    super.dispose();
  }
}

Future cancelTicket(url, value) async {
  await http.put(Uri.parse(url), body: {"is_used": value});
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
