import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/Features/Categorie/Presentation/bloc/Category/category_bloc.dart';
import 'package:mobile/Features/Categorie/Presentation/bloc/add_delete_update_category/adddeleteupdate_category_bloc.dart';
import 'package:mobile/Features/Categorie/Presentation/pages/Category_pages.dart';
import 'core/app_theme.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<CategoryBloc>()..add(GetAllCategoryEvent())),
        BlocProvider(create: (_) => di.sl<AdddeleteupdateCategoryBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BycottApp',
        theme: appTheme,
        home: CategoriePages(),
      ),
    );
  }
}