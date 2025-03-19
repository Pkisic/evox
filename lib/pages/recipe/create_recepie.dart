import 'dart:convert';

import 'package:evox/enums/meal_of_day.dart';
import 'package:evox/mixins/add_ingredient_dialog.dart';
import 'package:evox/models/ingredient.dart';
import 'package:evox/services/ingredient_service.dart';
import 'package:evox/services/recipe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CreateRecepie extends StatefulWidget {
  final String name;

  const CreateRecepie({super.key, required this.name});

  @override
  State<CreateRecepie> createState() => _CreateRecepieState();
}

class _CreateRecepieState extends State<CreateRecepie>
    with AddIngredientDialog {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController durationTextController = TextEditingController();
  final QuillController _controller = QuillController.basic();

  // Set<String> selected = {};
  Map<Ingredient, TextEditingController> selectedIngredients = {};

  final List<Mealofday> mealValues = Mealofday.values;
  late Mealofday selectedValue;

  final IngredientService _ingredientService = IngredientService();
  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    selectedValue = mealValues.first;
    super.initState();
  }

  void saveRecepie() {
    String name = nameTextController.text;
    String duration = durationTextController.text;
    String instructions = jsonEncode(_controller.document.toDelta().toJson());
    Mealofday mealofday = selectedValue;

    selectedIngredients.map((key, value) {
      // print(key);
      // print(value);

      return MapEntry(key, value);
    });
    Map<Ingredient, int> selection = Map.from(
      selectedIngredients,
    ).map((key, value) => MapEntry(key, int.tryParse(value.text)!));
    print(selection);
    // print(name);
    // print(duration);
    // print(instructions);
    // print(selectedValue);

    _recipeService.createRecipe(
      name,
      int.parse(duration),
      instructions,
      selection,
      mealOfDay: mealofday,
    );
  }

  Future<List<Ingredient>> getAllIngredients() async {
    return await _ingredientService.getAll();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    durationTextController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: createForm(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => saveRecepie(),
        child: Icon(Icons.save),
      ),
    );
  }

  createForm() {
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Recipe name',
                ),
                controller: nameTextController,
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Duration',
                ),
                controller: durationTextController,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        DropdownButtonFormField(
          value: selectedValue,
          onChanged: (x) {
            // selectedValue = x;
          },
          items:
              mealValues.map((Mealofday e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e.name),
                  onTap: () => selectedValue = e,
                );
              }).toList(),
        ),

        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 8,
              child: FutureBuilder<List<Ingredient>>(
                future: getAllIngredients(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField(
                      onChanged:
                          (
                            x,
                          ) {}, // This is required but not used in this custom implementation
                      items:
                          snapshot.data!.map((e) {
                            // var uniqueId = '${e.name}-${e.id}';
                            return DropdownMenuItem(
                              value: e,
                              child: StatefulBuilder(
                                builder: (context, _setState) {
                                  return Row(
                                    children: [
                                      // Checkbox to select/deselect items
                                      Checkbox(
                                        value: selectedIngredients.containsKey(
                                          e,
                                        ),
                                        onChanged: (isSelected) {
                                          if (isSelected == true) {
                                            // selectedIngredients.add(
                                            //   '${e.id}',
                                            // );
                                            selectedIngredients.putIfAbsent(
                                              e,
                                              () => TextEditingController(),
                                            ); // add controller
                                          } else {
                                            // selected.remove(
                                            //   '${e.id}',
                                            // ); // Remove item if deselected
                                            selectedIngredients[e]!.dispose();
                                            selectedIngredients.remove(e);
                                          }
                                          _setState(
                                            () {},
                                          ); // Update checkbox state
                                          setState(
                                            () {},
                                          ); // Update parent widget
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ), // Add space between checkbox and text
                                      Text(e.name), // Display item label
                                    ],
                                  );
                                },
                              ),
                            );
                          }).toList(),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: IconButton.filled(
                onPressed: () => addIngridientDialog(context),
                icon: Icon(Icons.add),
              ),
            ),
          ],
        ),

        ListView.separated(
          itemCount: selectedIngredients.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var selectedElement = selectedIngredients.entries.elementAt(index);
            print(selectedElement);
            return Row(
              children: [
                Expanded(child: Text(selectedElement.key.name)),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Quantity',
                    ),
                    controller: selectedElement.value,
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 10),
        ),
        Padding(padding: EdgeInsets.all(25), child: Text('Instructions: ')),
        QuillSimpleToolbar(
          controller: _controller,
          config: QuillSimpleToolbarConfig(),
        ),
        SizedBox(
          height: 500,
          child: QuillEditor.basic(
            controller: _controller,
            config: const QuillEditorConfig(),
          ),
        ),
      ],
    );
  }
}
