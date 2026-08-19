

import 'package:ecommerce_app_task/core/theme/theme_cubit.dart';
import 'package:ecommerce_app_task/features/auth/presentation/bloc/auth_gate.dart';
import 'package:ecommerce_app_task/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce_app_task/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection.dart';
import 'features/products/data/models/product_hive_model.dart';
import 'features/products/presentation/pages/product_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(
    ProductHiveModelAdapter(),
  );

  await Hive.openBox<ProductHiveModel>(
    'products',
  );

  await Hive.openBox<ProductHiveModel>(
    'wishlist',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              Injection.createProductBloc(),
        ),

        BlocProvider(
          create: (_) =>
          Injection.createWishlistBloc()
            ..add(LoadWishlist()),
        ),

        BlocProvider(
          create: (_) => ThemeCubit(),
        ),

        BlocProvider(
          create: (_) => AuthBloc(),
        ),
      ],

      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            title: 'E-Commerce App',

            themeMode:
            isDark ? ThemeMode.dark : ThemeMode.light,

            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blue,
              brightness: Brightness.light,
            ),

            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blue,
              brightness: Brightness.dark,
            ),

            home: const AuthGate(),
          );
        },
      ),
    );
  }
}