import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:qr_reader/models/scan_model.dart';

launchURL(BuildContext context, ScanModel scanModel) async {
  final url = scanModel.valor;

  if (scanModel.tipo == 'http') {
    //Abrir el sitio web
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scanModel);
  }
}
