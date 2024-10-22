import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcribit_app/features/menus/list_menu_screen.dart';
import 'package:transcribit_app/features/menus/providers/menu_provider.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: ref.watch(menuSelectedProvider),
        children: menusScreen,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          ref.read(menuSelectedProvider.notifier).state = index;
        },
        selectedIndex: ref.watch(menuSelectedProvider),
        // indicatorColor: Colors.blue,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
              icon: Icon(Icons.history_outlined),
              label: 'Historial',
              selectedIcon: Icon(Icons.history)),
        ],
      ),
    );
  }
}
