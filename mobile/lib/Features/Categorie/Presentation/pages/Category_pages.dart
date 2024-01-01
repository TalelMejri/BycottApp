import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Core/widgets/LandingPage.dart';
import 'package:mobile/Core/widgets/Loading_widget.dart';
import 'package:mobile/Features/Auth/data/datasource/user_local_data_source.dart';
import 'package:mobile/Features/Categorie/Presentation/bloc/Category/category_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/Features/Categorie/Presentation/pages/Statistique.dart';
import 'package:mobile/Features/Categorie/Presentation/pages/add_update_category.dart';
import 'package:mobile/Features/Categorie/Presentation/widgets/categories_widgets/MessageDisplayWidget.dart';
import 'package:mobile/Features/Categorie/Presentation/widgets/categories_widgets/category_list_widgets.dart';
import 'package:mobile/injection_container.dart';

class CategoriePages extends StatefulWidget {
  const CategoriePages({super.key});
 
  @override
  State<CategoriePages> createState() => _CategoriePagesState();
}

class _CategoriePagesState extends State<CategoriePages> {


  final UserLocalDataSource userLocalDataSource=sl.get<UserLocalDataSource>();
 
  @override
  void initState() {
   //userLocalDataSource.clearCachedUser();
    getAuth();
    super.initState();
  }


  void getAuth () async{
    var res=await userLocalDataSource.getCachedUser()!=null ? true : false;
    setState(()  {
      auth=res;
    });
    print(auth);
  }
  
  int _selectIndex=0;
  bool auth=false;

  void changeSelectedINdex(int index){
    setState(() {
      _selectIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: auth ?  _buildBottomNavigationBar() : null,
    );
  }

  AppBar _buildAppBar() => AppBar(
     title: _selectIndex==0 ? const Text('Category') : const Text('Add Category'),
     leading: IconButton(onPressed: (){ 
       Navigator.push(context, MaterialPageRoute(builder: (context)=>LandingPage()));
      },icon: Icon(Icons.arrow_back)),
    actions: [
      IconButton(onPressed: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>Statistique()));
      }, icon: Icon(Icons.pie_chart_sharp))
    ],
    );


  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
        if (state is LoadingCategoryState) {
          return const LoadingWidget();
        } else if (state is LoadedCategory) {
            return RefreshIndicator(
                child: _selectIndex==0  ?
                       CategoryListWidget(category: state.categorys) :
                       const CategoryAddUpdatePage(isUpdateCategory: false),
                onRefresh: ()=>_onRefresh(context),
              );
        } else if (state is ErrorCategoryState) {
          return MessageDisplayWidget(message:state.message);
        } else {
          return const LoadingWidget();
        }
      }),
    );
  }

  Widget _buildBottomNavigationBar() {
    return 
      CurvedNavigationBar(
      color:Color.fromARGB(255, 0, 0, 0),
      buttonBackgroundColor:Color.fromARGB(255, 0, 0, 0),
      backgroundColor:Colors.white,
      animationCurve: Curves.easeInOut,
      animationDuration:const  Duration(milliseconds: 600),
      onTap: (index){changeSelectedINdex(index);},
      index: _selectIndex,
       items:<Widget> [
         Icon(Icons.list,color: Colors.white,),
         Icon(Icons.add,color: Colors.white,),
        ]);
    }

    Future<void> _onRefresh(BuildContext context) async{
        BlocProvider.of<CategoryBloc>(context).add(RefreshCategoryEvent());
    }

}