import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({super.key});
  static const routename = './user-product';

  @override
  Widget build(BuildContext context) {
    final Productdata = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(' Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routename);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: Productdata.items.length,
              itemBuilder: (_, i) => Column(
                    children: [],
                  ))),
    );
  }
}
