import 'package:evox/mixins/add_ingredient_dialog.dart';
import 'package:evox/models/inventory.dart';
import 'package:evox/services/ingredient_service.dart';
import 'package:evox/services/inventory_service.dart';
import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  final String name;
  const InventoryPage({super.key, required this.name});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with AddIngredientDialog {
  final InventoryService _inventoryService = InventoryService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void saveIngedient() async {
    var name = _nameController.text;
    var quantity = _quantityController.text;

    final IngredientService ingredientService = IngredientService();
    final InventoryService inventoryService = InventoryService();
    final ingredientId = await ingredientService.saveOne(name);
    //final inventoryId =
    await inventoryService.createInventoryListing(
      ingredientId,
      int.parse(quantity),
    );
    update();
  }

  @override
  dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: FutureBuilder(
        future: _inventoryService.listInventory(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const LinearProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasData) {
                return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    final Inventory inventory = snapshot.data![index];
                    final quantity = inventory.quantity;
                    return createInventoryRow(
                      inventory,
                      context,
                      quantity,
                      update,
                    );
                  }),
                );
              } else {
                return Center(
                  child: Text(
                    'Inventory is empty!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                );
              }
            default:
              return const Text('No results');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {addIngridientDialog(context)},
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Future<dynamic> addIngridientDialog(
    BuildContext context, {
    withoutQuantity = false,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Ingridient name: ',
                  ),
                  controller: _nameController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Quantity: ',
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: _quantityController,
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                _quantityController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                saveIngedient();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
      barrierDismissible: true,
      barrierColor: Colors.red,
      useSafeArea: true,
    );
  }

  Row createInventoryRow(
    Inventory inventory,
    BuildContext context,
    int quantity,
    Function update,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: Text(
            inventory.ingredient.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: Text(
            "$quantity",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: Row(
            children: [
              FilledButton(
                onPressed: () async {
                  await _inventoryService.updateQuantity(
                    inventory,
                    quantity + 1,
                  );
                  update();
                },
                style: OutlinedButton.styleFrom(
                  shape: ContinuousRectangleBorder(),
                ),
                child: Text(
                  '+',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  try {
                    await _inventoryService.updateQuantity(
                      inventory,
                      quantity - 1,
                    );
                    update();
                  } on Exception catch (_) {
                    const snackBar = SnackBar(
                      content: Text('Unable to update quantity!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                style: OutlinedButton.styleFrom(
                  shape: ContinuousRectangleBorder(),
                ),
                child: Text(
                  '-',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
