class Food {
  final String id;
  final String name;
  final String category;
  final double price;
  final String image;
  final String description;

  const Food({required this.id, required this.name, required this.category, required this.price, required this.image, required this.description});
}

const foods = <Food>[
  Food(id: 'burger', name: 'Classic Burger', category: 'Meals', price: 1200, image: '🍔', description: 'Juicy beef patty, fresh vegetables and our signature sauce.'),
  Food(id: 'pizza', name: 'Cheesy Pizza', category: 'Meals', price: 1800, image: '🍕', description: 'Loaded with mozzarella, tomato sauce and delicious toppings.'),
  Food(id: 'pasta', name: 'Creamy Pasta', category: 'Meals', price: 1450, image: '🍝', description: 'Creamy pasta tossed with herbs and a rich house sauce.'),
  Food(id: 'fries', name: 'Crispy Fries', category: 'Sides', price: 650, image: '🍟', description: 'Golden, crispy fries seasoned to perfection.'),
  Food(id: 'wings', name: 'Chicken Wings', category: 'Sides', price: 950, image: '🍗', description: 'Tender chicken wings with a tasty spicy glaze.'),
  Food(id: 'nuggets', name: 'Chicken Nuggets', category: 'Snacks', price: 800, image: '🍗', description: 'Crispy bite-sized chicken pieces served hot and fresh.'),
  Food(id: 'donut', name: 'Chocolate Donut', category: 'Snacks', price: 500, image: '🍩', description: 'Soft donut covered with smooth chocolate glaze.'),
  Food(id: 'shake', name: 'Chocolate Shake', category: 'Snacks', price: 750, image: '🥤', description: 'Cold, creamy chocolate shake for a sweet finish.'),
];
