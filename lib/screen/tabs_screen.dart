import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screen/category_screen.dart';
import 'package:meals/screen/filters_screen.dart';
import 'package:meals/screen/meals_screen.dart';
import 'package:meals/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  final List<Meal> favoriteMeal = [];
  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = favoriteMeal.contains(meal);
    if (isExisting) {
      setState(() {
        favoriteMeal.remove(meal);
        _showInfoMessage('Removed From Favorites');
      });
    } else {
      setState(() {
        favoriteMeal.add(meal);
        _showInfoMessage('Added to Favorites');
      });
    }
  }

  void _setScreen(String identifier) {
    if (identifier == 'meals') {
      Navigator.pop(context);
    } else if (identifier == 'filters') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoryScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
    );
    var activePageTitle = 'Categories';
    if (_selectedIndex == 1) {
      activePage = MealsScreen(
        meals: favoriteMeal,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _selectPage(index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
    );
  }
}
