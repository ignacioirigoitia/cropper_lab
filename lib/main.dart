

import 'package:default_proyect/api/default_api.dart';
import 'package:default_proyect/providers/default_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'router/routes.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  DefaultApi.configureDio();
  Flurorouter.configureRoutes();

  runApp(AppState());
}

class AppState extends StatelessWidget {
  const AppState({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => DefaultProvider())
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Default App',
      initialRoute: Flurorouter.rootRoute,
      onGenerateRoute: Flurorouter.router.generator,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true, 
            title: Text('Default AppBar (Amo los appbars)'),
          ),
          body: child!,
        );
      },
    );
  }
}