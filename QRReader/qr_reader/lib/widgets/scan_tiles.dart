import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers_services/scan_list_provider.dart';
import 'package:qr_reader/utils/utils.dart';

class ScanTiles extends StatelessWidget {
  final String tipo;

  const ScanTiles({@required this.tipo});
  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (_, i) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (DismissDirection direcction) {
          Provider.of<ScanListProvider>(context, listen: false)
              .borrarScansPorId(scans[i].id);
        },
        child: ListTile(
          leading: Icon(
            this.tipo == 'http' ? Icons.home_outlined : Icons.maps_ugc_outlined,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(scans[i].valor),
          subtitle: Text(scans[i].id.toString()),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
          ),
          onTap: () => launchURL(context, scans[i]),
        ),
      ),
    );
  }
}