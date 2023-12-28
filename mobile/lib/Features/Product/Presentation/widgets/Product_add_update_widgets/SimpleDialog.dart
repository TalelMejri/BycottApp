import 'package:flutter/material.dart';


class SimpleDialogWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: const Text("Do You Wanna Delete This Category ?"),
        children: [
          SimpleDialogOption(
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Yes")
              ],
            ),
            onPressed: (){Navigator.pop(context,"yes");},
          ),
          SimpleDialogOption(
            child: const Row(
                 mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("No")
              ],
            ),
            onPressed: (){Navigator.pop(context,"no");},
          ),
        ],
      );
  }
}