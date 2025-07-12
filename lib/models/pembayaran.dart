import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utsbimbel/databasehelp.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Pembayaran extends StatelessWidget {
  final int? id;
  final int muridId;
  final String bulan;
  final String metodePembayaran;
  final String status;
  final String tanggalPembayaran;
  final String batasPembayaran;
  final int total;
  // New: Password for login
  final databaseHelper = DatabaseHelper();

  Pembayaran({
    super.key,
    this.id,
    required this.muridId,
    required this.bulan,
    required this.metodePembayaran,
    required this.status,
    required this.tanggalPembayaran,
    required this.batasPembayaran,
    required this.total
  });

  // Convert a Murid into a Map for inserting into the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'muridId': muridId,
      'bulan': bulan,
      'metodePembayaran': metodePembayaran,
      'status': status,
      'tanggalPembayaran': tanggalPembayaran,
      'batasPembayaran': batasPembayaran,
      'total': total
    };
  }

  // Create a Murid from a Map
  factory Pembayaran.fromMap(Map<String, dynamic> map) {
    return Pembayaran(
      id: map['id'],
      muridId: map['muridId'],
      bulan: map['bulan'],
      metodePembayaran: map['metodePembayaran'],
      status: map['status'],
      tanggalPembayaran: map['tanggalPembayaran'],
      batasPembayaran: map['batasPembayaran'],
      total: map['total'],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      color: Colors.amberAccent,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(id.toString()),
            Text(metodePembayaran),
          ],
        ),
      ),
    );
  }
}
