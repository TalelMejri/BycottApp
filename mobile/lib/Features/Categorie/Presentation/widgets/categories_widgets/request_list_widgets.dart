import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/Features/Categorie/Presentation/bloc/accept_reject_category/accept_category_bloc_bloc.dart';
import 'package:mobile/Features/Categorie/domain/entities/category.dart';

class RequestCategoryListWidget extends StatefulWidget {
  final List<Category> category;

  const RequestCategoryListWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<RequestCategoryListWidget> createState() => _RequestCategoryListWidgetState();
}

class _RequestCategoryListWidgetState extends State<RequestCategoryListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        const Text("List Of Category Demanded"),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: widget.category.length,
            itemBuilder: (BuildContext context, int index) {
              final category = widget.category[index];
              return Card(
                child: ListTile(
                  leading:  Image.memory(
                          base64Decode(
                              (category.photo).split(',').last),
                          width: 100,
                          height: 100,
                        ),
                  title: Text(category.name), 
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Do You Want to Reject?"),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                           BlocProvider.of<AcceptCategoryBlocBloc>(context)
                                               .add(RejectCategoryEvent(categoryId: category.id!));
                                                 Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                        child: const Text("Yes"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        child: const Text("No"),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                           showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Do You Want to Accept ?"),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                            BlocProvider.of<AcceptCategoryBlocBloc>(context)
                                               .add(AcceptCategoryEvent(categoryId: category.id!));
                                                Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                        child: const Text("Yes"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        child: const Text("No"),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.check_sharp, color: Colors.green,),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}