import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import '../screen/user_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({super.key});
  static const routename = './user-product';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final Productdata = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Products'),
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
        body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: Productdata.items.length,
                  itemBuilder: (_, i) => Column(
                        children: [
                          UserProductItem(
                            Productdata.items[i].id,
                            Productdata.items[i].title,
                            Productdata.items[i].imageUrl,
                          ),
                          Divider(),
                        ],
                      ))),
        ));
  }
}
