import 'package:flutter/foundation.dart';
import '../models/contact.dart';

class ContactsProvider extends ChangeNotifier {
  // Array de contactos de prueba
  final List<Contact> _contacts = [
    const Contact(
      id: '1',
      nombre: 'Lucas',
      apellido: 'Montoya',
      email: 'email@mail.com',
      direccion: 'Av. pueta lugones 94',       
      telefono: '3512664947',
      fechaNacimiento: null
    ),
    const Contact(
      id: '2',
      nombre: 'Ana',
      apellido: 'Gomez',
      email: 'email@email.com',
      telefono: '3512664948',
      direccion: 'Av. pueta lugones 94',      
      fechaNacimiento: null 
    ),
  ];

  List<Contact> get items => List.unmodifiable(_contacts);

  void add(Contact c) {
    _contacts.add(c);
    notifyListeners();
  }

  List<Contact> searchBy(String query) {
    final q = query.toLowerCase();
    return _contacts
        .where(
          (c) =>
              c.nombre.toLowerCase().contains(q) ||
              c.apellido.toLowerCase().contains(q) ||
              c.telefono.toLowerCase().contains(q) ||
              c.email.toLowerCase().contains(q),
        )
        .toList(growable: false);
  }
}
