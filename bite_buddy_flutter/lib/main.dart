import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MealMateApp());
}

// ============================================================
// MEALMATE - COMPLETE SINGLE FILE FLUTTER APP
// No extra packages required.
// Make sure these images exist in: assets/images/
// ============================================================

class AppStyles {
  static const Color primary = Color(0xFFFF512F);
  static const Color accent = Color(0xFFDD2476);
  static const Color background = Color(0xFFFFF9F6);
  static const Color darkBackground = Color(0xFF111114);
  static const Color darkCard = Color(0xFF1D1D22);

  static const Gradient sunsetGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxDecoration glass({
    double opacity = 0.2,
    double radius = 24,
    Color? color,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white.withOpacity(opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.white.withOpacity(0.3)),
    );
  }

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 25,
      offset: Offset(0, 10),
    ),
  ];

  static const TextStyle heading = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
  );
}

// ============================================================
// GLOBAL APP STATE
// ============================================================

final ValueNotifier<Map<int, int>> cart = ValueNotifier({});
final ValueNotifier<Set<int>> favourites = ValueNotifier({});
final ValueNotifier<List<AppOrder>> orders = ValueNotifier([]);
final ValueNotifier<List<String>> addresses = ValueNotifier([
  'Kegalle, Rambukkana',
]);
final ValueNotifier<bool> notificationsEnabled = ValueNotifier(true);
final ValueNotifier<bool> darkMode = ValueNotifier(false);

String money(double value) => 'Rs. ${value.toStringAsFixed(0)}';

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppStyles.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
}

void addToCart(Food food, [int quantity = 1]) {
  final updated = Map<int, int>.from(cart.value);
  updated[food.id] = (updated[food.id] ?? 0) + quantity;
  cart.value = updated;
}

void changeQuantity(Food food, int delta) {
  final updated = Map<int, int>.from(cart.value);
  final next = (updated[food.id] ?? 0) + delta;
  if (next <= 0) {
    updated.remove(food.id);
  } else {
    updated[food.id] = next;
  }
  cart.value = updated;
}

double cartSubtotal() {
  double total = 0;
  for (final entry in cart.value.entries) {
    final food = foods.firstWhere(
          (f) => f.id == entry.key,
      orElse: () => foods.first,
    );
    total += food.price * entry.value;
  }
  return total;
}

// ============================================================
// MODELS & DATA
// ============================================================

class Food {
  final int id;
  final String name;
  final String category;
  final String description;
  final String image;
  final double price;
  final double rating;
  final int deliveryMinutes;
  final int calories;
  final bool popular;
  final bool special;
  final bool trending;

  const Food({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    this.deliveryMinutes = 25,
    this.calories = 450,
    this.popular = false,
    this.special = false,
    this.trending = false,
  });
}

class AppOrder {
  final String id;
  final List<String> items;
  final double total;
  final DateTime date;
  final String status;

  AppOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
  });
}

const List<Food> foods = [
  Food(
    id: 1,
    name: 'Classic Burger',
    category: 'Burgers',
    description: 'Juicy beef burger with fresh vegetables and our signature sauce.',
    image: 'Classic burger.jpg',
    price: 850,
    rating: 4.8,
    calories: 620,
    special: true,
    trending: true,
  ),
  Food(
    id: 2,
    name: 'Chicken Burger',
    category: 'Burgers',
    description: 'Crispy golden chicken fillet with lettuce and creamy sauce.',
    image: 'Chicken burger.jpg',
    price: 900,
    rating: 4.7,
    calories: 590,
    popular: true,
  ),
  Food(
    id: 4,
    name: 'Double Beef Burger',
    category: 'Burgers',
    description: 'Two juicy beef patties, cheese, onions and signature sauce.',
    image: 'double beef burger.jpg',
    price: 1350,
    rating: 4.9,
    calories: 820,
    trending: true,
  ),
  Food(
    id: 8,
    name: 'Pepperoni Pizza',
    category: 'Pizza',
    description: 'Loaded with delicious pepperoni, mozzarella and rich tomato sauce.',
    image: 'pepperoni pizza.jpg',
    price: 1900,
    rating: 4.9,
    calories: 760,
    special: true,
    trending: true,
  ),
  Food(
    id: 10,
    name: 'Chicken Fried Rice',
    category: 'Rice',
    description: 'Fragrant fried rice with tender chicken, vegetables and egg.',
    image: 'chicken fried rice.jpg',
    price: 1200,
    rating: 4.7,
    calories: 680,
    trending: true,
  ),
  Food(
    id: 16,
    name: 'Strawberry Milkshake',
    category: 'Drinks',
    description: 'Creamy strawberry milkshake topped with a delicious swirl.',
    image: 'Strawberry milkshake.jpg',
    price: 750,
    rating: 4.9,
    calories: 420,
    popular: true,
  ),
  Food(
    id: 18,
    name: 'Chocolate Cake',
    category: 'Desserts',
    description: 'Soft and moist chocolate cake for the perfect sweet ending.',
    image: 'cake.jpg',
    price: 650,
    rating: 4.9,
    calories: 480,
    trending: true,
  ),
];

// ============================================================
// APP
// ============================================================

class BiteBuddyApp extends StatelessWidget {
  const BiteBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkMode,
      builder: (_, isDark, __) {
        return MaterialApp(
          title: 'MealMate',
          debugShowCheckedModeBanner: false,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppStyles.background,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppStyles.primary,
              brightness: Brightness.light,
            ),
            fontFamily: 'Poppins',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppStyles.darkBackground,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppStyles.primary,
              brightness: Brightness.dark,
            ),
            fontFamily: 'Poppins',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
            ),
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}

// ============================================================
// LOGO
// ============================================================

class MealMateLogo extends StatelessWidget {
  final double size;
  const MealMateLogo({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(size * 0.2),
          decoration: BoxDecoration(
            gradient: AppStyles.sunsetGradient,
            borderRadius: BorderRadius.circular(size * 0.3),
            boxShadow: [
              BoxShadow(
                color: AppStyles.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            Icons.restaurant_menu_rounded,
            color: Colors.white,
            size: size * 0.6,
          ),
        ),
        SizedBox(width: size * 0.3),
        Text(
          'MealMate',
          style: AppStyles.heading.copyWith(
            color: AppStyles.primary,
            fontSize: size * 0.7,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// MAIN NAVIGATION
// ============================================================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final pages = const [
    HomeScreen(),
    FavouriteScreen(),
    OrdersScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(.92),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppStyles.primary.withOpacity(.12),
                ),
                boxShadow: AppStyles.softShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home_rounded, 'Home', 0),
                  _navItem(Icons.favorite_rounded, 'Favourites', 1),
                  _navItem(Icons.receipt_long_rounded, 'Orders', 2),
                  _navItem(Icons.shopping_bag_rounded, 'Cart', 3, isCart: true),
                  _navItem(Icons.person_rounded, 'Profile', 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(
      IconData icon,
      String label,
      int index, {
        bool isCart = false,
      }) {
    final selected = currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: selected
            ? BoxDecoration(
          gradient: AppStyles.sunsetGradient,
          borderRadius: BorderRadius.circular(18),
        )
            : null,
        child: ValueListenableBuilder<Map<int, int>>(
          valueListenable: cart,
          builder: (_, items, __) {
            final count = items.values.fold<int>(0, (a, b) => a + b);
            return Badge(
              isLabelVisible: isCart && count > 0,
              label: Text('$count'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: selected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface.withOpacity(.55),
                    size: 23,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface.withOpacity(.55),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// HOME
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  String sortType = 'Top Rated';
  String query = '';
  final searchController = TextEditingController();

  final categories = const [
    ('All', Icons.apps_rounded),
    ('Burgers', Icons.lunch_dining_rounded),
    ('Pizza', Icons.local_pizza_rounded),
    ('Rice', Icons.rice_bowl_rounded),
    ('Drinks', Icons.local_drink_rounded),
    ('Desserts', Icons.cake_rounded),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Food> get filteredFoods {
    var result = foods.where((food) {
      final categoryMatch =
          selectedCategory == 'All' || food.category == selectedCategory;
      final searchMatch =
          query.isEmpty ||
              food.name.toLowerCase().contains(query.toLowerCase()) ||
              food.category.toLowerCase().contains(query.toLowerCase());
      return categoryMatch && searchMatch;
    }).toList();

    if (sortType == 'Top Rated') {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (sortType == 'Cheapest') {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortType == 'Fastest Delivery') {
      result.sort((a, b) => a.deliveryMinutes.compareTo(b.deliveryMinutes));
    } else if (sortType == 'Calories Low to High') {
      result.sort((a, b) => a.calories.compareTo(b.calories));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(),
          _buildSearchBar(),
          _buildQuickStats(),
          _buildSpecialBanner(),
          _buildTrendingSection(),
          _buildCategories(),
          _buildMenuHeader(),
          _buildMenuGrid(),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 58, 22, 8),
        child: Row(
          children: [
            const Hero(
              tag: 'app-logo',
              child: MealMateLogo(size: 40),
            ),
            const Spacer(),
            ValueListenableBuilder<bool>(
              valueListenable: notificationsEnabled,
              builder: (_, enabled, __) {
                return GestureDetector(
                  onTap: () {
                    if (enabled) {
                      showMessage(context, 'You are all caught up! 🔔');
                    } else {
                      showMessage(context, 'Notifications are turned off.');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      boxShadow: AppStyles.softShadow,
                    ),
                    child: Icon(
                      enabled
                          ? Icons.notifications_none_rounded
                          : Icons.notifications_off_outlined,
                      color: AppStyles.accent,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 4),
        child: TextField(
          controller: searchController,
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
            hintText: 'Search your cravings...',
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppStyles.primary,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.tune_rounded,
                color: AppStyles.accent,
              ),
              onPressed: _showFilterSheet,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 8),
        child: Row(
          children: [
            _miniStat(Icons.flash_on_rounded, '25 min', 'Fast delivery'),
            const SizedBox(width: 10),
            _miniStat(Icons.star_rounded, '4.9', 'Top rated'),
            const SizedBox(width: 10),
            _miniStat(Icons.discount_rounded, '40%', 'Weekend deal'),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(17),
          boxShadow: AppStyles.softShadow,
        ),
        child: Column(
          children: [
            Icon(icon, color: AppStyles.primary, size: 19),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialBanner() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
        child: Container(
          height: 190,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            gradient: AppStyles.sunsetGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppStyles.primary.withOpacity(.35),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                bottom: -25,
                child: Transform.rotate(
                  angle: -.10,
                  child: Hero(
                    tag: 'banner-image',
                    child: Image.asset(
                      'assets/images/pepperoni pizza.jpg',
                      width: 220,
                      height: 180,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.local_pizza_rounded,
                        size: 150,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'LIMITED TIME',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '40% OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 34,
                      ),
                    ),
                    const Text(
                      'WEEKEND FEAST',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppStyles.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() => sortType = 'Top Rated');
                        showMessage(context, 'Showing our top rated picks 🍕');
                      },
                      child: const Text(
                        'Explore Deals',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    final trending = foods.where((f) => f.trending).toList();

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 30, 22, 14),
            child: Row(
              children: [
                Text(
                  'Trending Now',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                SizedBox(width: 5),
                Text('🔥', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          SizedBox(
            height: 125,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: trending.length,
              itemBuilder: (_, i) => _trendingCard(trending[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trendingCard(Food food) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FoodDetails(food: food)),
      ),
      child: Container(
        width: 255,
        margin: const EdgeInsets.only(right: 13),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppStyles.softShadow,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/${food.image}',
                width: 84,
                height: 84,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 84,
                  height: 84,
                  color: AppStyles.primary.withOpacity(.1),
                  child: const Icon(
                    Icons.fastfood_rounded,
                    color: AppStyles.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    money(food.price),
                    style: const TextStyle(
                      color: AppStyles.accent,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(
                        ' ${food.rating}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 112,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 5),
          itemCount: categories.length,
          itemBuilder: (_, i) {
            final cat = categories[i];
            final selected = selectedCategory == cat.$1;

            return GestureDetector(
              onTap: () => setState(() => selectedCategory = cat.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 78,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  gradient: selected ? AppStyles.sunsetGradient : null,
                  color: selected ? null : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(21),
                  boxShadow: selected ? AppStyles.softShadow : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cat.$2,
                      color: selected ? Colors.white : AppStyles.primary,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat.$1,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 12),
        child: Row(
          children: [
            const Text(
              'Popular Menu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const Spacer(),
            Text(
              '${filteredFoods.length} items',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    final filtered = filteredFoods;

    if (filtered.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 60,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              const Text(
                'No food found',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
              const Text(
                'Try another search or category.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 10),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 16,
          childAspectRatio: .66,
        ),
        delegate: SliverChildBuilderDelegate(
              (_, i) => FoodCard(food: filtered[i], index: i),
          childCount: filtered.length,
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) {
        final options = [
          'Top Rated',
          'Cheapest',
          'Fastest Delivery',
          'Calories Low to High',
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sort & Filter',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 18),
                ...options.map(
                      (title) => RadioListTile<String>(
                    value: title,
                    groupValue: sortType,
                    activeColor: AppStyles.primary,
                    title: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => sortType = value);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// FOOD CARD
// ============================================================

class FoodCard extends StatelessWidget {
  final Food food;
  final int index;

  const FoodCard({
    super.key,
    required this.food,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + index * 70),
      builder: (_, value, child) => Transform.translate(
        offset: Offset(0, 25 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FoodDetails(food: food)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(26),
            boxShadow: AppStyles.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Hero(
                      tag: 'food-${food.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(26),
                        ),
                        child: Image.asset(
                          'assets/images/${food.image}',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppStyles.primary.withOpacity(.08),
                            child: const Center(
                              child: Icon(
                                Icons.fastfood_rounded,
                                size: 60,
                                color: AppStyles.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (food.special)
                      Positioned(
                        left: 9,
                        top: 9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppStyles.sunsetGradient,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Text(
                            'SPECIAL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 9,
                      right: 9,
                      child: FavouriteButton(food: food),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 11, 13, 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          money(food.price),
                          style: const TextStyle(
                            color: AppStyles.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        Text(
                          ' ${food.rating}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: ElevatedButton(
                        onPressed: () {
                          addToCart(food);
                          showMessage(context, '${food.name} added to cart 🛒');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.primary.withOpacity(.1),
                          foregroundColor: AppStyles.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: const Text(
                          '+ Add',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavouriteButton extends StatelessWidget {
  final Food food;

  const FavouriteButton({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<int>>(
      valueListenable: favourites,
      builder: (_, favs, __) {
        final selected = favs.contains(food.id);

        return GestureDetector(
          onTap: () {
            final updated = Set<int>.from(favs);
            if (selected) {
              updated.remove(food.id);
              showMessage(context, 'Removed from favourites');
            } else {
              updated.add(food.id);
              showMessage(context, 'Added to favourites ❤️');
            }
            favourites.value = updated;
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
              boxShadow: AppStyles.softShadow,
            ),
            child: Icon(
              selected
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
              color: selected ? Colors.red : Colors.grey,
              size: 19,
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// FAVOURITES
// ============================================================

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favourites',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ValueListenableBuilder<Set<int>>(
        valueListenable: favourites,
        builder: (_, favs, __) {
          final list = foods.where((f) => favs.contains(f.id)).toList();

          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: AppStyles.primary.withOpacity(.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 60,
                        color: AppStyles.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nothing saved yet',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Tap the heart on any meal to save it here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 120),
            itemCount: list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 16,
              childAspectRatio: .66,
            ),
            itemBuilder: (_, i) => FoodCard(food: list[i], index: i),
          );
        },
      ),
    );
  }
}

// ============================================================
// FOOD DETAILS
// ============================================================

class FoodDetails extends StatefulWidget {
  final Food food;

  const FoodDetails({super.key, required this.food});

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final food = widget.food;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 380,
                pinned: true,
                backgroundColor: AppStyles.primary,
                foregroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'food-${food.id}',
                    child: Image.asset(
                      'assets/images/${food.image}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppStyles.primary.withOpacity(.15),
                        child: const Icon(
                          Icons.fastfood_rounded,
                          size: 100,
                          color: AppStyles.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FavouriteButton(food: food),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25, 28, 25, 140),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              food.name,
                              style: const TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            money(food.price),
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: AppStyles.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          _infoChip(Icons.star_rounded, '${food.rating}'),
                          const SizedBox(width: 8),
                          _infoChip(
                            Icons.schedule_rounded,
                            '${food.deliveryMinutes} min',
                          ),
                          const SizedBox(width: 8),
                          _infoChip(
                            Icons.local_fire_department_rounded,
                            '${food.calories} kcal',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'About this meal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        food.description,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Why you will love it',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Wrap(
                        spacing: 9,
                        runSpacing: 9,
                        children: [
                          DetailPill(icon: Icons.eco_rounded, text: 'Fresh'),
                          DetailPill(
                            icon: Icons.local_fire_department_rounded,
                            text: 'Hot & tasty',
                          ),
                          DetailPill(
                            icon: Icons.verified_rounded,
                            text: 'Best seller',
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          const Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Spacer(),
                          QuantityControl(
                            quantity: quantity,
                            onMinus: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                            onPlus: () => setState(() => quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SafeArea(
              child: SizedBox(
                height: 62,
                child: ElevatedButton(
                  onPressed: () {
                    addToCart(food, quantity);
                    showMessage(
                      context,
                      '$quantity × ${food.name} added to your bag 🛒',
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primary,
                    foregroundColor: Colors.white,
                    elevation: 10,
                    shadowColor: AppStyles.primary.withOpacity(.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Add to Bag • ${money(food.price * quantity)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: AppStyles.primary.withOpacity(.08),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppStyles.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const DetailPill({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppStyles.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: AppStyles.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CART
// ============================================================

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String promo = '';
  bool promoApplied = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Order',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          ValueListenableBuilder<Map<int, int>>(
            valueListenable: cart,
            builder: (_, items, __) {
              if (items.isEmpty) return const SizedBox.shrink();
              return IconButton(
                onPressed: () => _clearCart(context),
                icon: const Icon(Icons.delete_sweep_rounded),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Map<int, int>>(
        valueListenable: cart,
        builder: (_, items, __) {
          if (items.isEmpty) return _emptyCart();

          final cartList =
          foods.where((f) => items.containsKey(f.id)).toList();
          final subtotal = cartSubtotal();
          final discount = promoApplied ? subtotal * .40 : 0.0;
          final delivery = subtotal >= 2500 ? 0.0 : 250.0;
          final total = subtotal - discount + delivery;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                  children: [
                    _deliveryBanner(context),
                    const SizedBox(height: 15),
                    ...cartList.map(
                          (food) => CartItem(
                        food: food,
                        quantity: items[food.id]!,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _promoBox(),
                    const SizedBox(height: 18),
                    _summary(
                      subtotal: subtotal,
                      discount: discount,
                      delivery: delivery,
                      total: total,
                    ),
                  ],
                ),
              ),
              _checkoutBar(total),
            ],
          );
        },
      ),
    );
  }

  Widget _emptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(27),
              decoration: BoxDecoration(
                gradient: AppStyles.sunsetGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your bag is empty',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 7),
            const Text(
              'Add something delicious and your order will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deliveryBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(.09),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.local_shipping_rounded, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Free delivery on orders above Rs. 2,500',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(17),
        boxShadow: AppStyles.softShadow,
      ),
      child: TextField(
        onChanged: (v) => promo = v,
        decoration: InputDecoration(
          hintText: 'Promo code (try BITE40)',
          prefixIcon: const Icon(
            Icons.local_offer_outlined,
            color: AppStyles.primary,
          ),
          suffixIcon: TextButton(
            onPressed: () {
              if (promo.trim().toUpperCase() == 'BITE40') {
                setState(() => promoApplied = true);
                showMessage(context, '40% discount applied 🎉');
              } else {
                showMessage(context, 'Invalid promo code');
              }
            },
            child: const Text(
              'APPLY',
              style: TextStyle(
                color: AppStyles.accent,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          filled: false,
        ),
      ),
    );
  }

  Widget _summary({
    required double subtotal,
    required double discount,
    required double delivery,
    required double total,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', money(subtotal)),
          if (discount > 0) _summaryRow('Discount', '- ${money(discount)}'),
          _summaryRow(
            'Delivery',
            delivery == 0 ? 'FREE' : money(delivery),
          ),
          const Divider(height: 25),
          _summaryRow(
            'Total',
            money(total),
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: bold ? null : Colors.grey,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
              fontSize: bold ? 17 : 13,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: bold ? AppStyles.primary : null,
              fontWeight: FontWeight.w900,
              fontSize: bold ? 19 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkoutBar(double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        boxShadow: AppStyles.softShadow,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 57,
          child: ElevatedButton(
            onPressed: () => _checkout(total),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              'Place Order • ${money(total)}',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _clearCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('All items will be removed from your bag.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cart.value = {};
              Navigator.pop(context);
              showMessage(context, 'Cart cleared');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _checkout(double total) {
    if (addresses.value.isEmpty) {
      showMessage(context, 'Please add a delivery address first.');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LocationScreen()),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => CheckoutSheet(total: total),
    );
  }
}

class CartItem extends StatelessWidget {
  final Food food;
  final int quantity;

  const CartItem({
    super.key,
    required this.food,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppStyles.softShadow,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/${food.image}',
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: AppStyles.primary.withOpacity(.1),
                child: const Icon(
                  Icons.fastfood_rounded,
                  color: AppStyles.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  money(food.price),
                  style: const TextStyle(
                    color: AppStyles.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 7),
                QuantityControl(
                  quantity: quantity,
                  small: true,
                  onMinus: () => changeQuantity(food, -1),
                  onPlus: () => changeQuantity(food, 1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            money(food.price * quantity),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppStyles.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final bool small;

  const QuantityControl({
    super.key,
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = small ? 30.0 : 36.0;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppStyles.primary.withOpacity(.08),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _button(Icons.remove_rounded, onMinus, size),
          SizedBox(
            width: small ? 25 : 30,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: small ? 12 : 14,
              ),
            ),
          ),
          _button(Icons.add_rounded, onPlus, size),
        ],
      ),
    );
  }

  Widget _button(IconData icon, VoidCallback action, double size) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: size * .55,
          color: AppStyles.primary,
        ),
      ),
    );
  }
}

// ============================================================
// CHECKOUT
// ============================================================

class CheckoutSheet extends StatefulWidget {
  final double total;

  const CheckoutSheet({super.key, required this.total});

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  String payment = 'Cash on Delivery';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: SizedBox(
                width: 45,
                child: Divider(thickness: 4),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Confirm Your Order',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),
            _checkoutInfo(
              Icons.location_on_rounded,
              'Delivery address',
              addresses.value.first,
            ),
            const SizedBox(height: 12),
            _checkoutInfo(
              Icons.receipt_long_rounded,
              'Order total',
              money(widget.total),
            ),
            const SizedBox(height: 18),
            const Text(
              'Payment method',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: payment,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.payment_rounded),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Cash on Delivery',
                  child: Text('Cash on Delivery'),
                ),
                DropdownMenuItem(
                  value: 'Card',
                  child: Text('Credit / Debit Card'),
                ),
                DropdownMenuItem(
                  value: 'Digital Wallet',
                  child: Text('Digital Wallet'),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => payment = v);
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 57,
              child: ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Confirm & Place Order',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkoutInfo(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppStyles.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _placeOrder() {
    final itemNames = <String>[];

    for (final entry in cart.value.entries) {
      final food = foods.firstWhere((f) => f.id == entry.key);
      itemNames.add('${entry.value} × ${food.name}');
    }

    final order = AppOrder(
      id: '#BB-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: itemNames,
      total: widget.total,
      date: DateTime.now(),
      status: 'Preparing',
    );

    orders.value = [order, ...orders.value];
    cart.value = {};

    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => OrderSuccessDialog(orderId: order.id),
    );
  }
}

class OrderSuccessDialog extends StatelessWidget {
  final String orderId;

  const OrderSuccessDialog({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppStyles.sunsetGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Order Confirmed! 🎉',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 7),
          Text(
            'Your order $orderId is being prepared.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Awesome!'),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ORDERS
// ============================================================

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ValueListenableBuilder<List<AppOrder>>(
        valueListenable: orders,
        builder: (_, orderList, __) {
          if (orderList.isEmpty) {
            return const EmptyOrders();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
            itemCount: orderList.length,
            itemBuilder: (_, i) => OrderCard(order: orderList[i]),
          );
        },
      ),
    );
  }
}

class EmptyOrders extends StatelessWidget {
  const EmptyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 75,
              color: AppStyles.primary.withOpacity(.35),
            ),
            const SizedBox(height: 15),
            const Text(
              'No orders yet',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your completed and ongoing orders will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final AppOrder order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.status == 'Delivered';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                order.id,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: (isDelivered ? Colors.green : Colors.orange)
                      .withOpacity(.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: isDelivered ? Colors.green : Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          ...order.items.take(3).map(
                (item) => Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '${order.date.day}/${order.date.month}/${order.date.year}',
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const Spacer(),
              Text(
                money(order.total),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppStyles.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE
// ============================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            children: [
              const SizedBox(height: 18),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppStyles.sunsetGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppStyles.softShadow,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 65,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Jayani Samarakoon',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const Text(
                'jayani.s@example.com',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),
              _stats(context),
              const SizedBox(height: 28),
              _sectionTitle('Account'),
              _profileMenu(
                context,
                Icons.payment_rounded,
                'Payment Methods',
                'Cards, wallets & cash',
                    () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentMethodsScreen(),
                  ),
                ),
              ),
              _profileMenu(
                context,
                Icons.location_on_rounded,
                'My Addresses',
                'Manage delivery locations',
                    () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LocationScreen()),
                ),
              ),
              _profileMenu(
                context,
                Icons.settings_rounded,
                'Settings',
                'Notifications, theme & privacy',
                    () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
              _profileMenu(
                context,
                Icons.help_outline_rounded,
                'Help & Support',
                'We are here for you',
                    () => _support(context),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout_rounded, color: Colors.red),
                    label: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppStyles.softShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _stat('Orders', '${orders.value.length}'),
            _stat('Reviews', '12'),
            _stat('Points', '850'),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppStyles.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 11),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _profileMenu(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      VoidCallback onTap,
      ) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppStyles.primary.withOpacity(.08),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, color: AppStyles.accent),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }

  void _support(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.support_agent_rounded,
                color: AppStyles.primary,
                size: 50,
              ),
              SizedBox(height: 12),
              Text(
                'How can we help?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 8),
              Text(
                'For this prototype, support requests can be connected to your backend or Firebase later.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showMessage(context, 'Logged out successfully');
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PAYMENT METHODS
// ============================================================

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<Map<String, String>> methods = [
    {'type': 'Visa', 'number': '**** **** **** 4242', 'expiry': '05/27'},
    {'type': 'Mastercard', 'number': '**** **** **** 8899', 'expiry': '12/27'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Methods',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
        children: [
          ...methods.asMap().entries.map(
                (entry) => _buildCard(
              entry.key,
              entry.value['type']!,
              entry.value['number']!,
              entry.value['expiry']!,
            ),
          ),
          const SizedBox(height: 8),
          _methodTile(
            Icons.account_balance_wallet_rounded,
            'Digital Wallet',
            'Apple Pay / Google Pay',
          ),
          _methodTile(
            Icons.payments_rounded,
            'Cash on Delivery',
            'Available',
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 57,
            child: ElevatedButton.icon(
              onPressed: _addCard,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Add New Card',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index, String type, String number, String expiry) {
    final isVisa = type == 'Visa';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 190,
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isVisa
              ? [const Color(0xFF153E75), const Color(0xFF1E88E5)]
              : [const Color(0xFF7B1FA2), const Color(0xFFE91E63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                type,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  setState(() => methods.removeAt(index));
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              const Text(
                'JAYANI SAMARAKOON',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Text(
                expiry,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _methodTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppStyles.primary.withOpacity(.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppStyles.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 11),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }

  void _addCard() {
    final numberController = TextEditingController();
    final expiryController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Add Card',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Card number',
                prefixIcon: Icon(Icons.credit_card_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: expiryController,
              decoration: const InputDecoration(
                labelText: 'Expiry',
                prefixIcon: Icon(Icons.date_range_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final last4 = numberController.text.length >= 4
                  ? numberController.text.substring(
                numberController.text.length - 4,
              )
                  : '0000';
              setState(() {
                methods.add({
                  'type': 'Visa',
                  'number': '**** **** **** $last4',
                  'expiry': expiryController.text.isEmpty
                      ? '12/28'
                      : expiryController.text,
                });
              });
              Navigator.pop(context);
              showMessage(context, 'Card added successfully');
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LOCATION
// ============================================================

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Addresses',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 170,
            margin: const EdgeInsets.fromLTRB(22, 10, 22, 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppStyles.primary.withOpacity(.16),
                  AppStyles.accent.withOpacity(.13),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 55,
                    color: AppStyles.primary,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Delivery Locations',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Choose where your food should arrive',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: addresses,
              builder: (_, list, __) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  itemCount: list.length,
                  itemBuilder: (_, i) => _addressTile(list[i], i),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 25),
            child: SizedBox(
              width: double.infinity,
              height: 57,
              child: OutlinedButton.icon(
                onPressed: _addAddress,
                icon: const Icon(Icons.add_location_alt_rounded),
                label: const Text(
                  'Add New Address',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppStyles.primary,
                  side: const BorderSide(color: AppStyles.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressTile(String address, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(21),
        boxShadow: AppStyles.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppStyles.primary.withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.home_rounded,
              color: AppStyles.primary,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Home',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    if (index == 0) ...[
                      const SizedBox(width: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              final list = List<String>.from(addresses.value)..removeAt(index);
              addresses.value = list;
            },
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _addAddress() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Add Address',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: TextField(
          controller: controller,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'Enter your full delivery address',
            prefixIcon: Icon(Icons.location_on_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              addresses.value = [
                ...addresses.value,
                controller.text.trim(),
              ];
              Navigator.pop(context);
              showMessage(context, 'Address saved');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SETTINGS
// ============================================================

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
        children: [
          const Text(
            'Preferences',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<bool>(
            valueListenable: notificationsEnabled,
            builder: (_, value, __) => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: value,
              activeColor: AppStyles.primary,
              title: const Text(
                'Notifications',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: const Text(
                'Get updates about your orders and offers',
                style: TextStyle(fontSize: 11),
              ),
              onChanged: (v) => notificationsEnabled.value = v,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: darkMode,
            builder: (_, value, __) => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: value,
              activeColor: AppStyles.primary,
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: const Text(
                'Use a darker appearance',
                style: TextStyle(fontSize: 11),
              ),
              onChanged: (v) => darkMode.value = v,
            ),
          ),
          const Divider(height: 35),
          const Text(
            'Account & Privacy',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Language',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: const Text('English'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => showMessage(context, 'Language selection coming soon'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Privacy Policy',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            trailing: const Icon(Icons.open_in_new_rounded, size: 20),
            onTap: () => _privacy(context),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'About MealMate',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: const Text('Version 3.0.0 • Premium Prototype'),
            trailing: const Icon(Icons.info_outline_rounded),
            onTap: () => _about(context),
          ),
        ],
      ),
    );
  }

  void _privacy(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Privacy Policy'),
        content: Text(
          'This prototype stores data locally in memory. No personal information is sent to a real server from this demo.',
        ),
      ),
    );
  }

  void _about(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'MealMate',
      applicationVersion: '3.0.0',
      applicationIcon: const Icon(
        Icons.restaurant_menu_rounded,
        color: AppStyles.primary,
      ),
      children: const [
        Text(
          'A beautiful food ordering application prototype with cart, favourites, orders, checkout, settings and more.',
        ),
      ],
    );
  }
}
