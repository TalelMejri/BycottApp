import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/Core/Strings/constantes.dart';
import 'package:mobile/Core/utils/validator.dart';
import 'package:mobile/Core/widgets/custom_scaffold.dart';
import 'package:mobile/Features/Categorie/domain/entities/category.dart';
import 'package:mobile/Features/Product/Presentation/bloc/add_delete_update_product/adddeleteupdate_product_bloc.dart';
import 'package:mobile/Features/Product/Presentation/widgets/Product_add_update_widgets/form_submit_btn.dart';
import 'package:mobile/Features/Categorie/Presentation/widgets/category_add_update_widgets/text_form_field_widget.dart';
import 'package:mobile/Features/Product/domain/entities/Product.dart';

class FormWidgetProduct extends StatefulWidget {
  final bool isUpdateProduct;
  final Product? product;
  final Category category;
  const FormWidgetProduct(
      {Key? key,
      required this.isUpdateProduct,
      this.product,
      required this.category})
      : super(key: key);

  @override
  State<FormWidgetProduct> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidgetProduct> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String photo = "";
  String description = "";
  late File imagePicker = File('path');
  late File selectedImage = File('path');
  String imageError = "";

  @override
  void initState() {
    if (widget.isUpdateProduct) {
      imagePicker = File(widget.product!.photo.path);
      name = widget.product!.name;
      description = widget.product!.description;
    }
    super.initState();
  }

  Future<void> onChangeImage(ImageSource source) async {
    try {
      XFile? pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 2,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        !widget.isUpdateProduct
                            ? 'Add Product '
                            : "Update Product",
                        style: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormFieldWidget(
                        initialValue: name,
                        validation: validateName,
                        onChanged: (value) {
                          name = value;
                        },
                        hintText: 'Enter your name',
                        icon: Icons.edit,
                        keyboardType: TextInputType.name,
                        labelText: 'Name',
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                         TextFormFieldWidget(
                        initialValue: description,
                        validation: validateDescription,
                        onChanged: (value) {
                          description = value;
                        },
                        hintText: 'Enter your description',
                        icon: Icons.edit,
                        keyboardType: TextInputType.text,
                        labelText: 'Description',
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Visibility(
                        visible: widget.isUpdateProduct ? true : false,
                        child: CachedNetworkImage(
                          width: 100,
                          height: 100,
                          imageUrl: BASE_URL_STORAGE + imagePicker.path,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              onChangeImage(ImageSource.gallery);
                            },
                            child: const Text("Choose Your Photo"),
                          ),
                          selectedImage.path == 'path'
                              ? const Text("No Image Selected")
                              : Image.file(selectedImage, width: 50),
                        ],
                      ),
                      Text(
                        imageError.isNotEmpty ? imageError : '',
                        style: const TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FormSubmitBtn(
                          isUpdateProduct: widget.isUpdateProduct,
                          onPressed: validateFormThenUpdateOrAddProduct,
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Thank you for your support',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void validateFormThenUpdateOrAddProduct() {
    final isValid = _formKey.currentState!.validate();
    if (imagePicker == null && !widget.isUpdateProduct) {
      setState(() {
        imageError = "Image Required";
      });
      return;
    }

    if (isValid) {
      final product = Product(
        id: widget.isUpdateProduct ? widget.product!.id : null,
        name: name,
        photo: selectedImage,
        description: description,
        id_categorie: widget.category.id.toString()!,
      );
      if (widget.isUpdateProduct) {
        BlocProvider.of<AdddeleteupdateProductBloc>(context)
            .add(UpdateProductEvent(product: product));
      } else {
        BlocProvider.of<AdddeleteupdateProductBloc>(context)
            .add(AddProductEvent(product: product));
      }
    }
  }
}
