import 'package:evox/models/recipe.dart';
import 'package:evox/services/recipe_service.dart';
import 'package:flutter/material.dart';

class RecipiesPage extends StatefulWidget {
  const RecipiesPage({super.key});

  @override
  State<RecipiesPage> createState() => _RecipiesPageState();
}

class _RecipiesPageState extends State<RecipiesPage> {
  final RecipeService _recipeService = RecipeService();

  Future<List<Recipe>> getAllRecipies() async {
    return await _recipeService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipies')),
      body: Center(
        child: FutureBuilder(
          future: getAllRecipies(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasData) {
                  final recipies = snapshot.data;
                  return ListView.builder(
                    itemCount: recipies?.length,
                    itemBuilder: (context, index) {
                      Recipe recipe = snapshot.data![index];
                      return ListTile(
                        title: Text(recipe.name),
                        subtitle: Text('$recipe'),
                      );
                    },
                  );
                }
                return Text('No recipies!');
              default:
                return Text('No recipies!');
            }
          },
        ),
      ),
    );
  }
}
