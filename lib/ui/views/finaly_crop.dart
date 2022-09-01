
import 'package:default_proyect/providers/default_provider.dart';
import 'package:default_proyect/ui/components/crop_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinalyCrop extends StatelessWidget {
  const FinalyCrop({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 700) {
      return _HomePage(
        key: const ValueKey('desktop'),
        title: 'Desktop',
        displayStyle: PageDisplayStyle.desktop,
      );
    } else {
      return _HomePage(
        key: const ValueKey('mobile'),
        title: 'Mobile',
        displayStyle: PageDisplayStyle.mobile,
      );
    }
  }
}

class _HomePage extends StatefulWidget {
  final PageDisplayStyle displayStyle;
  final String title;

  const _HomePage({
    Key? key,
    required this.displayStyle,
    required this.title,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  @override
  Widget build(BuildContext context) {
    final defaultProvider = Provider.of<DefaultProvider>(context);

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                Column(
                  children: defaultProvider.childrens,
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(vertical: 20),
              child: IconButton(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: (() {
                  defaultProvider.addChildren(new CropComponent());
                }), 
                icon: Icon(Icons.add)
              ),
            ),
          )
        ],
      ),
    );
  }
}