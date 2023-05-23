import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 

import '../presentation/home/home_screen.dart';
import '../presentation/page1/page1_screen.dart';
import '../presentation/page2/page2_screen.dart';
import 'app_get.dart';

// GoRouter configuration
final goRouter = GoRouter(
  navigatorKey: findInstance<GlobalKey<NavigatorState>>(),
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: 'page1',
      path: '/page1',
      builder: (context, state) => const Page1Screen(),
    ),
    GoRoute(
      name: 'page2',
      path: '/page2',
      builder: (context, state) => const Page2Screen(),
    ),
  ],
);
