import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/contacts_provider.dart';
import 'screens/login_screen.dart';
import 'screens/contacts_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // proveedores de estados 
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ContactsProvider()),
      ],
      // la app en si 
      child: MaterialApp(
        title: 'Mi Agenda',
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: Builder(
          
          builder:  (context) {
          // Usamos un Builder para tener un context con los providers
          // y decidir qué pantalla mostrar: Login o Contactos
          final auth = context.watch<AuthProvider>();
          return auth.isAuth ? const ContactsScreen() : const LoginScreen();
        }
        ),
      ),
    );
  }
}
