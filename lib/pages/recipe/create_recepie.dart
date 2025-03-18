import 'dart:convert';

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

  Set<String> selected = {};
  Map<String, TextEditingController> controllers = {};

  final IngredientService _ingredientService = IngredientService();
  final RecipeService _recipeService = RecipeService();

  void saveRecepie() {
    String name = nameTextController.text;
    String duration = durationTextController.text;
    String instructions = jsonEncode(_controller.document.toDelta().toJson());
    print(name);
    print(duration);
    print(instructions);
    _recipeService.createRecipe(name, int.parse(duration), instructions);
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
        child: Center(child: createForm()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => saveRecepie(),
        child: Icon(Icons.save),
      ),
    );
  }

  Column createForm() {
    return Column(
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
        Row(children: [Text('data')]),
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
                            var uniqueId = '${e.name}-${e.id}';
                            return DropdownMenuItem(
                              value: uniqueId,
                              child: StatefulBuilder(
                                builder: (context, _setState) {
                                  return Row(
                                    children: [
                                      // Checkbox to select/deselect items
                                      Checkbox(
                                        value: selected.contains(uniqueId),
                                        onChanged: (isSelected) {
                                          if (isSelected == true) {
                                            selected.add(
                                              uniqueId,
                                            ); // Add item if selected
                                            controllers.putIfAbsent(
                                              uniqueId,
                                              () => TextEditingController(),
                                            ); // add controller
                                          } else {
                                            selected.remove(
                                              uniqueId,
                                            ); // Remove item if deselected
                                            controllers[uniqueId]!.dispose();
                                            controllers.remove(uniqueId);
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
          itemCount: selected.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(child: Text(selected.elementAt(index))),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Quantity',
                    ),
                    controller: controllers[selected.elementAt(index)],
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
        Expanded(
          child: QuillEditor.basic(
            controller: _controller,
            config: const QuillEditorConfig(),
          ),
        ),
      ],
    );
  }
}
