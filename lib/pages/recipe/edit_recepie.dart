import 'package:evox/models/recipe.dart';
import 'package:evox/services/recipe_ingredient_service.dart';
import 'package:flutter/material.dart';

class EditRecepie extends StatefulWidget {
  final Recipe recipe;
  const EditRecepie({super.key, required this.recipe});

  @override
  State<EditRecepie> createState() => _EditRecepieState();
}

class _EditRecepieState extends State<EditRecepie> {
  final RecipeIngredientService _recipeIngredientService =
      RecipeIngredientService();
  List<Map<String, dynamic>> ingredients = [];

  Future<void> updateIngredients() async {
    ingredients = await _recipeIngredientService.getAllIngredientsByRecipeId(
      widget.recipe.id!,
    );
  }

  @override
  void initState() {
    updateIngredients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.recipe.name}')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: ListView.builder(
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            var item = ingredients.elementAt(index);
            var ingredient = item['ingredient'];
            var measure = item['measure'];
            var quantity = item['quantity'];

            return ListTile(
              title: Text('$ingredient'),
              subtitle: Text('$measure $quantity'),
            );
          },
        ),
      ),
    );
  }
}
