import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:qr_reader/pages/direciones_page.dart';
import 'package:qr_reader/pages/historial_mapas.dart';
import 'package:qr_reader/providers_services/scan_list_provider.dart';
import 'package:qr_reader/providers_services/ui_provider.dart';
import 'package:qr_reader/providers_services/db_provider.dart';
import 'package:qr_reader/widgets/custom_navigatorBar.dart';
import 'package:qr_reader/widgets/scan_botton.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Historial'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              final scanListProvider =
                  Provider.of<ScanListProvider>(context, listen: false);
              scanListProvider.borrarTodos();
            },
          ),
        ],
      ),
      body: _HomePageBody(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Obtenemos el selected menu opt
    final uiProvider = Provider.of<UiProvider>(context);

    //Si ponemos 0 sale una página y si ponemos 1 sale la otra
    final currentIndex = uiProvider.selectedMenuOpt;
    final tempScan = new ScanModel(valor: 'http://google.com');

    // DBProvider.db.nuevoScan(tempScan);
    // DBProvider.db.deleteAllScan().then(print);
    //Aquí usamos el scan list provider

    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    switch (currentIndex) {
      case 0:
        scanListProvider.cargarScansPorTipo('geo');
        return HistorialMapasPage();

      case 1:
        scanListProvider.cargarScansPorTipo('http');
        return DireccionesPage();

      default:
        return HistorialMapasPage();
    }
  }
}
