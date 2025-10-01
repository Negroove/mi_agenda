import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contacts_provider.dart';
import '../providers/auth_provider.dart';
import 'contact_form_screen.dart'; // la creamos en el paso 5

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool _searchMode = false;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactsProvider>();
    final query = _searchCtrl.text.trim();
    final contacts = query.isEmpty ? provider.items : provider.searchBy(query);
    return Scaffold(
      appBar: AppBar(
        title: _searchMode
            ? TextField(
                controller: _searchCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar...',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.search,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => setState(() {}),
              )
            : const Text('Contactos'),
        leading: _searchMode
            ? IconButton(
                tooltip: 'Cerrar búsqueda',
                icon: const Icon(Icons.close),
                onPressed: () {
                  _searchCtrl.clear();
                  setState(() => _searchMode = false);
                },
              )
            : null,
        actions: [
          IconButton(
            tooltip: 'Buscar',
            icon: const Icon(Icons.search),
            onPressed: () => setState(() => _searchMode = true),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: contacts.isEmpty
          ? const Center(child: Text('No hay contactos aún'))
          : ListView.separated(
              itemCount: contacts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final c = contacts[i];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      c.iniciales,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text('${c.nombre} ${c.apellido}'),
                  subtitle: Text('${c.telefono} · ${c.email}'),
                  onTap: () {
                    // (opcional) en el futuro: detalle del contacto
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nuevo contacto',
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const ContactFormScreen()));
        },
      ),
    );
  }
}
