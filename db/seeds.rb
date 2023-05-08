# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

ingredients = Ingredient.create([{name: "Salad"}, {name: "Ham"}, {name: "Cheese"}, {name: "Olives"}, {name: "Flour"}, {name: "Coffee"}, {name: "Mascarpone"}])
tags = Tag.create([{name: "Vegan"}, {name: "Kids Friendly"}, {name: "Winter"}, {name: "Summer"}, {name: "Main Course"}, {name: "Dessert"}, {name: "Appetizer"}, {name: "Cocktail"}])

Recipe.create([
    {
        name: "Tiramisu", 
        description: "Hum, c'est bon le tiramisu", 
        prep_time: 50, 
        servings: 8, 
        tags: [tags.second, tags[5]], 
        ingredients: [ingredients.last, ingredients[5]]
    },
    {
        name: "Salade Cesar", 
        description: "Melanger la salade, le jambon et le fromage", 
        prep_time: 10,
        ingredients: [ingredients.first, ingredients.second, ingredients.third]
    },
    {
        name: "Cake aux Olives", 
        description: "Dans un grand bol melanger la farine, l'huile, les olives et mettre au four a 180 degres. ", 
        prep_time: 30, 
        cooking_time:25, 
        servings: 10
    },
    {
        name: "Tresse", 
        description: "Faire legerement chauffer le lait et ajouter la levure de boulanger. Ajouter dans un saladier le lait et la levure, puis le sel, sucre farine oeufs et le beurre puis malaxer a la main."
    },
    {
        name: "Gateau a l'ananas",
        description: "C'est bon un gateau a l'ananas avec des rondelles fraiches, mais avec de l'ananas en conserve ca va aussi."
    },
    {
        name: "Gateau Mickey",
        description: "Simple gateau au yaourt avec un peu de noix de coco rapé. Simple et rapide."
    },
    {
        name: "Crumble aux pommes",
        description: "Couper les pommes puis les etaler dans un plat. Saupoudrer du melange sucre, farine et je sais plus quoi par dessus, puis mettre au four."
    },
    {
        name: "Soupe aux carrotes",
        description: "Soupe avec des carrotes, quelques patates, du bouillon et puis c'est tout. On peut assaisoner avec du curry, du lait, de la sauce piquante, ..."
    },
    {
        name: "Soupe courgettes et bleu d'Auvergne"
    },
    {
        name: "Pates Bolognese",
        description: "C'est la base de tout"
    }
])