import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/contact.dart';
import '../providers/contacts_provider.dart';

class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({super.key});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // controladores
  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _dirCtrl = TextEditingController();

  DateTime? _fechaNac;
  bool _saving = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    _dirCtrl.dispose();
    super.dispose();
  }

  // --- Validadores simples
  String? _req(String? v, String campo) =>
      (v == null || v.trim().isEmpty) ? 'Ingrese $campo' : null;

  String? _validEmail(String? v) {
    if (_req(v, 'el email') != null) return 'Ingrese el email';
    if (!(v!.contains('@') && v.contains('.'))) return 'Email inválido';
    return null;
  }

  Future<void> _pickFecha() async {
    final now = DateTime.now();
    final ini = DateTime(now.year - 80);
    final fin = DateTime(now.year + 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaNac ?? DateTime(now.year - 20),
      firstDate: ini,
      lastDate: fin,
    );
    if (picked != null) setState(() => _fechaNac = picked);
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    // crear Contact y guardar
    final contact = Contact(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // id simple
      nombre: _nombreCtrl.text.trim(),
      apellido: _apellidoCtrl.text.trim(),
      telefono: _telCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      direccion: _dirCtrl.text.trim(),
      fechaNacimiento: _fechaNac,
    );

    context.read<ContactsProvider>().add(contact);

    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context).pop(); // volver a la lista
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Contacto agregado')));
  }

  @override
  Widget build(BuildContext context) {

    // Formatear fecha
   final f = _fechaNac == null ? 'Sin definir' : 
   DateFormat('dd/MM/yyyy').format(_fechaNac!);

    // UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo contacto'),
        actions: [
          IconButton(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save),
            tooltip: 'Guardar',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Nombre
                TextFormField(
                  controller: _nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  textInputAction: TextInputAction.next,
                  validator: (v) => _req(v, 'el nombre'),
                  inputFormatters: [
                    // solo letras, espacios, apostrofes y guiones
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-ZáéíóúÁÉÍÓÚñÑ\s'\-]"),
                    ),
                    LengthLimitingTextInputFormatter(30),
                  ],
                ),
                const SizedBox(height: 12),
                // Apellido
                TextFormField(
                  controller: _apellidoCtrl,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                  textInputAction: TextInputAction.next,
                  validator: (v) => _req(v, 'el apellido'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-ZáéíóúÁÉÍÓÚñÑ\s'\-]"),
                    ),
                    LengthLimitingTextInputFormatter(30),
                  ],
                ),
                const SizedBox(height: 12),
                // Teléfono
                TextFormField(
                  controller: _telCtrl,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (v) => _req(v, 'el teléfono'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9+\s\-]")),
                    LengthLimitingTextInputFormatter(18),
                  ],
                ),
                const SizedBox(height: 12),
                // Email
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validEmail,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp(r"\s"),
                    ), // sin espacios
                    LengthLimitingTextInputFormatter(60),
                  ],
                ),
                const SizedBox(height: 12),
                // Dirección
                TextFormField(
                  controller: _dirCtrl,
                  decoration: const InputDecoration(labelText: 'Dirección'),
                  textInputAction: TextInputAction.next,
                  validator: (v) => _req(v, 'la dirección'),
                ),
                const SizedBox(height: 12),
                // Fecha de nacimiento
                Row(
                  children: [
                    Expanded(
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de nacimiento',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(f),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: _pickFecha,
                      icon: const Icon(Icons.date_range),
                      label: const Text('Elegir'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // boton grande guardar 
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
