import 'package:evox/pages/recipe/create_recepie.dart';
import 'package:evox/pages/inventory/inventory_page.dart';
import 'package:evox/pages/measurements/measure_page.dart';
import 'package:evox/pages/recipe/recipies_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(widget.title),
        primary: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipiesPage()),
                );
              },
              child: Text('List'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            CreateRecepie(name: 'Create new Recepie ... '),
                  ),
                );
              },
              child: Text('Create New'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InventoryPage(name: 'Inventory'),
                  ),
                );
              },
              child: Text('Inventory'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeasurePage(name: 'Measurements'),
                  ),
                );
              },
              child: Text('Measurements'),
            ),
          ],
        ),
      ),
    );
  }
}
