import 'package:band_names/presentation/providers/socket_provider.dart';
import 'package:band_names/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketProvider(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': ( _ ) => const HomeScreen(),
          'status': ( _ ) => const StatusScreen(),
        },
      ),
    );
  }
}