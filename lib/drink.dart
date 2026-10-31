class Drink {
  final int id;
  final String name;
  final String description;
  final String ingredients;
  final String imageUrl;

  Drink({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    String? description = json['description'];
    if (description == null || description.isEmpty) {
      description = 'N/A';
    }

    final List ingredientList = json['ingredients'] ?? [];

    return Drink(
      id: json['id'],
      name: json['title'],
      description: description,
      ingredients: ingredientList.join(', '),
      imageUrl: json['image'] ?? '',
    );
  }
}