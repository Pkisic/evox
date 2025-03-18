import 'package:evox/models/measure_local.dart';
import 'package:evox/services/measure_service.dart';
import 'package:flutter/material.dart';

class MeasurePage extends StatefulWidget {
  final String name;
  const MeasurePage({super.key, required this.name});

  @override
  State<MeasurePage> createState() => _MeasurePageState();
}

class _MeasurePageState extends State<MeasurePage> {
  final MeasureService _measureService = MeasureService();

  Future<List<MeasureLocal>> getAllMeasures() async {
    return await _measureService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Center(
        child: FutureBuilder(
          future: getAllMeasures(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              case ConnectionState.done:
                final measurements = snapshot.data;

                return ListView.builder(
                  itemCount: measurements?.length ?? 0,
                  itemBuilder: (context, index) {
                    final MeasureLocal measureLocal = measurements![index];
                    return ListTile(
                      title: Text(
                        measureLocal.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    );
                  },
                );
              default:
                return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
