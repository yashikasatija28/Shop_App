import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const routename = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefocusnode = FocusNode();
  final _descriptionfocusnode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlfocusnode = FocusNode();
  var _form = GlobalKey<FormState>();

  var _editedProducts =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;

  var _isLoading = false;

  @override
  void initState() {
    _imageUrlfocusnode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editedProducts =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProducts.title,
          'description': _editedProducts.description,
          'price': _editedProducts.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProducts.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlfocusnode.removeListener(_updateImageUrl);
    _pricefocusnode.dispose();
    _descriptionfocusnode.dispose();
    _imageUrlController.dispose();
    _imageUrlfocusnode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlfocusnode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProducts.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProducts.id, _editedProducts);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProducts)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                    key: _form,
                    child: ListView(
                      children: [
                        TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_pricefocusnode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Provide a Value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProducts = Product(
                                title: value ?? '',
                                price: _editedProducts.price,
                                description: _editedProducts.description,
                                imageUrl: _editedProducts.imageUrl,
                                id: _editedProducts.id,
                                isFavorite: _editedProducts.isFavorite);
                          },
                        ),
                        TextFormField(
                            initialValue: _initValues['price'],
                            decoration: InputDecoration(labelText: 'Price'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _pricefocusnode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionfocusnode);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a price.';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              }
                              if (double.parse(value) <= 0) {
                                return 'Please enter a number greater than zero.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProducts = Product(
                                  title: _editedProducts.title,
                                  price: double.parse(value ?? '0'),
                                  description: _editedProducts.description,
                                  imageUrl: _editedProducts.imageUrl,
                                  id: _editedProducts.id,
                                  isFavorite: _editedProducts.isFavorite);
                            }),
                        TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionfocusnode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description.';
                            }
                            if (value.length < 10) {
                              return 'Should be at least 10 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProducts = Product(
                              title: _editedProducts.title,
                              price: _editedProducts.price,
                              description: value ?? '',
                              imageUrl: _editedProducts.imageUrl,
                              id: _editedProducts.id,
                              isFavorite: _editedProducts.isFavorite,
                            );
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(
                                top: 8,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter a Url')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(
                                child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              focusNode: _imageUrlfocusnode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an image URL.';
                                }
                                // Regular expression for validating URL
                                String pattern =
                                    r'^(http|https):\/\/.*\.(png|jpg|jpeg)$';
                                RegExp regExp = RegExp(pattern);

                                if (!regExp.hasMatch(value)) {
                                  return 'Please enter a valid image URL.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProducts = Product(
                                  title: _editedProducts.title,
                                  price: _editedProducts.price,
                                  description: _editedProducts.description,
                                  imageUrl: value ?? '',
                                  id: _editedProducts.id,
                                  isFavorite: _editedProducts.isFavorite,
                                );
                              },
                            ))
                          ],
                        )
                      ],
                    )),
              ));
  }
}
