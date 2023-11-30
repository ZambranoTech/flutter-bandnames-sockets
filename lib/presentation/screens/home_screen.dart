import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:band_names/presentation/providers/providers.dart';
import 'package:band_names/infrastructure/models/band.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 5),
    // Band(id: '2', name: 'Queen', votes: 2),
    // Band(id: '3', name: 'Héroes del Silencio', votes: 1),
    // Band(id: '4', name: 'Bon Jovi', votes: 4),
  ];

  @override
  void initState() {
    super.initState();
    final socketService = context.read<SocketProvider>();

    socketService.socket.on('active-bands', _handleActiveBands);
  }

  _handleActiveBands( dynamic payload ) {
    bands = (payload as List)
        .map((band) => Band.fromMap(band))
        .toList();

    setState(() {});
  }

  @override
  void dispose() {
    final socketService = context.read<SocketProvider>();
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = context.watch<SocketProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: ( socketService.serverStatus == ServerStatus.online )
            ? Icon(Icons.check_circle, color: Colors.blue[300],)
            : const Icon(Icons.offline_bolt, color: Colors.red,),
          )
        ],
      ),
      body: Column(
        children: [

          _ShowGraph(bands: bands),

          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int i) => _BandTile(band: bands[i])
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  addNewBand() {

    final textController = TextEditingController();

    if ( Platform.isAndroid ) {
      showDialog(
      context: context, 
      builder: ( _ ) => AlertDialog(
          title: const Text('New band name:'),
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              onPressed: () => addBandToList(textController.text),
              elevation: 5,
              textColor: Colors.blue,
              child: const Text('Add'),
            )
          ],
        )
      );
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context, 
        builder: ( _ ) => CupertinoAlertDialog(
            title: const Text('New band name'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Add'),
                onPressed: () => addBandToList(textController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          )
      );
    }

  }

  void addBandToList(String name) {   
    final socketService = context.read<SocketProvider>();


    if (name.trim().length > 1) {
      socketService.emit('add-band', { 'name' : name });
    }

    Navigator.pop(context);

  }

}

class _BandTile extends StatelessWidget {
  const _BandTile({
    required this.band,
  });

  final Band band;

  @override
  Widget build(BuildContext context) {

    final socketService = context.read<SocketProvider>();

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketService.emit('delete-band', { 'id' : band.id }),
      background: Container(
        padding: const EdgeInsets.only(left: 8),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white),),
        )
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20),),
        onTap: () => socketService.socket.emit('vote-band', { 'id': band.id }),
      ),
    );
  }
  
}

class _ShowGraph extends StatelessWidget {

  final List<Band> bands;

  const _ShowGraph({required this.bands});

  @override
  Widget build(BuildContext context) {

    Map<String, double> dataMap = Map();

    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 200,
      child: dataMap.isNotEmpty 
      ? PieChart(
        dataMap: dataMap,
        chartType: ChartType.ring,
        )
      : const SizedBox()
    );
  }
}