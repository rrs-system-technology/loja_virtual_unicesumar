import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './controllers/controllers.dart';
import './repository/repository.dart';
import './services/services.dart';
import './widgets/widgets.dart';
import './views/views.dart';

void main() {
  // Registrar os services globais

  final productService = ProductService();
  final categoryService = CategoryService();
  final bannerService = BannerService();
  final userService = UserService();
  final authService = AuthService();
  // Registrar os RemoteRepositories com seus services

  final productRemoteRepository = ProductRemoteRepository(productService);
  final categoryRemoteRepository = CategoryRemoteRepository(categoryService);
  final bannerRemoteRepository = BannerRemoteRepository(bannerService);

  final authRemoteRepository = AuthRemoteRepository(authService);
  final authLocalRepository = AuthLocalRepository();

  // Registrar os Repositories
  final authRepository = AuthRepository(authLocalRepository, authRemoteRepository);
  Get.put(authRepository);

  final productRepository = ProductRepository(productRemoteRepository);
  Get.put(productRepository);

  final categoryRepository = CategoryRepository(categoryRemoteRepository);
  Get.put(categoryRepository);

  final bannerRepository = BannerRepository(bannerRemoteRepository);
  Get.put(bannerRepository);

  final userLocalRepository = UserLocalRepository();
  final userRemoteRepository = UserRemoteRepository(userService);
  final userRepository = UserRepository(userLocalRepository, userRemoteRepository);
  Get.put(userRepository);

  final cartLocalRepository = CartLocalRepository();
  final cartProductsLocalRepository = CartProductsLocalRepository();
  final cartRepository = CartRepository(cartLocalRepository, cartProductsLocalRepository);
  Get.put(cartRepository);
  Get.put(CartController(cartRepository: cartRepository));

  final favoritosRepository = FavoritosRepository(FavoritosLocalRepository());
  Get.put(favoritosRepository);
  Get.put(FavoritosController(favoritosRepository: favoritosRepository));

  // Registrar os Controllers globais

  Get.put(MainNavigationController());

  Get.put(HomeController(
    bannerRepository: bannerRepository,
    categoryRepository: categoryRepository,
    productRepository: productRepository,
  ));

  Get.put(CartController(cartRepository: cartRepository));

  Get.put(UserController(userRepository: userRepository));

  Get.put(UserController(userRepository: userRepository));

  Get.put(BannerController(bannerRepository: bannerRepository));

  Get.put(CategoryController(categoryRepository: categoryRepository));

  Get.put(ProductController(productRepository: productRepository));

  Get.put(AuthController(authRepository: authRepository));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loja de Produtos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

        // Cores principais
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),

        // Botão flutuante
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: StadiumBorder(),
        ),

        // Card
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 6,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Texto
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
          bodySmall: TextStyle(fontSize: 12, color: Colors.black54),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),

        // Chips padrão (caso use no app)
        chipTheme: ChipThemeData(
          backgroundColor: Colors.deepPurple,
          selectedColor: Colors.orange,
          secondarySelectedColor: Colors.orange,
          labelStyle: const TextStyle(color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: MainNavigationPage(), // sua tela inicial
      getPages: [
        GetPage(name: '/', page: () => MainNavigationPage()), // App já abre com o menu
        GetPage(name: '/category/:category', page: () => CategoryPage()),
        GetPage(name: '/signup', page: () => const SignUpPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        /*
        GetPage(name: '/cart', page: () => CartPage()),
        GetPage(name: '/produto/listar', page: () => ProductListPage()),
        GetPage(name: '/produto/create', page: () => const ProductFormPage()),
        
        */
      ],
    );
  }
}
