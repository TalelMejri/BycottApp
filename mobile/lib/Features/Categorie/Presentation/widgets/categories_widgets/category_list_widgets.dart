import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/Core/widgets/EmptyPage.dart';
import 'package:mobile/Features/Categorie/Presentation/bloc/Category/category_bloc.dart';
import 'package:mobile/Features/Categorie/Presentation/bloc/add_delete_update_category/adddeleteupdate_category_bloc.dart';
import 'package:mobile/Features/Categorie/Presentation/pages/add_update_category.dart';
import 'package:mobile/Features/Categorie/Presentation/widgets/category_add_update_widgets/SimpleDialog.dart';
import 'package:mobile/Features/Categorie/domain/entities/category.dart';
import 'dart:convert';

class CategoryListWidget extends StatefulWidget {

  final List<Category> category;
  const CategoryListWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {

   Future<void> ConfirmDelete(id)async{
     String ? message=await showDialog(
      barrierDismissible: false,
      context: context,
       builder:(BuildContext context){
          return SimpleDialogWidget();
        });
        if (message!=null){
          if(message=="yes"){
            BlocProvider.of<AdddeleteupdateCategoryBloc>(context)
            .add(DeleteCategoryEvent(categoryId: id));
            _onRefresh(context);
          }
        }
   }

    Future<void> _onRefresh(BuildContext context) async{
      BlocProvider.of<CategoryBloc>(context).add(RefreshCategoryEvent());
    }

  @override
  Widget build(BuildContext context) {
    return widget.category == null || widget.category.isEmpty
        ? const EmptyPage()
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: widget.category.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Column(
                  children: [
                    Image.memory(
                      base64Decode((widget.category[index].photo).split(',').last),
                      width: 200,
                      height: 100,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Text("Name:", style: TextStyle(color: Colors.red)),
                        Text(widget.category[index].name),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed:()async { await ConfirmDelete(widget.category[index].id);},
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2,),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>CategoryAddUpdatePage(isUpdateCategory: true,category:widget.category[index])));
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit"),
                           style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.yellow,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
      }
}
