// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:utsbimbel/models/pembayaran.dart';
// import 'package:utsbimbel/models/murid.dart';

// class Pembayaranmurid extends StatefulWidget {
//   final Murid murid;
//   const Pembayaranmurid({super.key, required this.murid});

//   @override
//   State<Pembayaranmurid> createState() => _PembayaranmuridState();

// }

// class _PembayaranmuridState extends State<Pembayaranmurid> {
//   List<Pembayaran> _pembayaranList = [];
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         title: const Text('Detail Pembayaran'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Expanded(
//         child: ListView.builder(itemCount: _pembayaranList.length,itemBuilder: (context, index) {
//           Pembayaran pembayaranmurid = _pembayaranList[index];
//           return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Bulan: ${pembayaranmurid.bulan}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                                 const SizedBox(height: 8),
//                                 Text('Total Pembayaran: Rp ${pembayaranmurid.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16)),
//                                 Text('Status: ${pembayaranmurid.status}', style: const TextStyle(fontSize: 16)),
//                                 Text('Metode Pembayaran: ${pembayaranmurid.metodePembayaran}', style: const TextStyle(fontSize: 16)),
//                                 Text('Tanggal Pembayaran: ${(pembayaranmurid.tanggalPembayaran)}', style: const TextStyle(fontSize: 16)),
//                                 Text('Batas Pembayaran: ${(pembayaranmurid.batasPembayaran)}', style: const TextStyle(fontSize: 16)),
//                                 const SizedBox(height: 8),
//                               ],
//                             ),
//                           ),
//                         );
//         },),
//       ),
//     );
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:utsbimbel/models/pembayaran.dart';
import 'package:utsbimbel/models/murid.dart';
import 'package:utsbimbel/databasehelp.dart';

class Pembayaranmurid extends StatefulWidget {
  final Murid murid;
  const Pembayaranmurid({super.key, required this.murid});

  @override
  State<Pembayaranmurid> createState() => _PembayaranmuridState();
}

class _PembayaranmuridState extends State<Pembayaranmurid> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Pembayaran> _pembayaranList = [];

  void _fetchPembayaranListByMurid(int? classid) async {
    List<Pembayaran> fetchedList =
        await _databaseHelper.getPembayaranByMuridId(widget.murid.id);
    setState(() {
      _pembayaranList = fetchedList;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPembayaranListByMurid(widget.murid.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pembayaran'),
        backgroundColor: Colors.amber,
      ),
      body: ListView.builder(
        itemCount: _pembayaranList.length,
        itemBuilder: (context, index) {
          Pembayaran pembayaranmurid = _pembayaranList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bulan: ${pembayaranmurid.bulan}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Pembayaran: Rp ${pembayaranmurid.total.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Status: ${pembayaranmurid.status}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Metode Pembayaran: ${pembayaranmurid.metodePembayaran}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Tanggal Pembayaran: ${pembayaranmurid.tanggalPembayaran}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Batas Pembayaran: ${pembayaranmurid.batasPembayaran}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
