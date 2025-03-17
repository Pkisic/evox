import 'package:evox/services/ingredient_service.dart';
import 'package:evox/services/inventory_service.dart';
import 'package:flutter/material.dart';

mixin AddIngredientDialog {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

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
  }

  Future<dynamic> addIngridientDialog(BuildContext context) {
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
}
