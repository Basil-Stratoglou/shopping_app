import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/providers/products_provider.dart';
import 'package:shopping_app/screens/auth_screen.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';
import 'package:shopping_app/screens/orders_screen.dart';
import 'package:shopping_app/screens/product_detail_screen.dart';
import 'package:shopping_app/screens/products_overview_screen.dart';
import 'package:shopping_app/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /* use the value syntax when you have a provider and you are providing the data on a single list
          or grid where flutter will recycle the widgets you attach the provider to,
          create causes bugs with out of screen widgets*/
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          // create: (_) => ProductsProvider(),
          // in order to avoid the is required you can rollback to provider 3.0.0 and use builder instead of update
          update: (ctx, auth, previousProductsProvider) => ProductsProvider(
              auth.token,
              auth.userId,
              previousProductsProvider == null
                  ? []
                  : previousProductsProvider.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shop',
          theme: ThemeData(
            primarySwatch: Colors.green,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOveriewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routename: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
