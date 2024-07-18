import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screen/auth_screen.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import 'package:shop_app/screen/user_product_screen.dart';
import './screen/cart_screen.dart';
import './screen/product_overview_screen.dart';
import './screen/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screen/order_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
              auth.token!,
              auth.userId!,
              previousProducts == null ? [] : previousProducts.items,
            ),
            create: (_) => Products(null, null, []),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
              auth.token!,
              auth.userId!,
              previousOrders == null ? [] : previousOrders.orders,
            ),
            create: (ctx) => Orders(null, null, []),
          ),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                    title: 'MyShop',
                    theme: ThemeData(
                      primaryColor: Colors.purple,
                      hintColor: Colors.deepOrange,
                      fontFamily: 'Lato',
                    ),
                    home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
                    routes: {
                      ProductDetailScreen.routeName: (ctx) =>
                          ProductDetailScreen(),
                      CartScreen.routeName: (ctx) => CartScreen(),
                      OrdersScreen.routeName: (ctx) => OrdersScreen(),
                      UserProductScreen.routename: (ctx) => UserProductScreen(),
                      EditProductScreen.routename: (ctx) => EditProductScreen(),
                    })));
  }
}
