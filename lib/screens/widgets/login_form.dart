import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// OJO con la ruta relativa: estás 2 carpetas por debajo de lib/
import '../../providers/auth_provider.dart';

/// Formulario de login desacoplado de la pantalla.
/// - Maneja estado local (texto, foco, loading, ocultar/mostrar contraseña).
/// - Valida datos.
/// - Llama al AuthProvider (la lógica de login vive en el provider).
/// - NO navega: si tu main.dart es "reactivo", la app cambia sola a Contactos.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailFocus.dispose();
    _passFocus.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

// Valida email y password
  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingrese su email';
    if (!v.contains('@')) return 'Email inválido';
    return null;
  }

  String? _validatePass(String? v) {
    if (v == null || v.isEmpty) return 'Ingrese su contraseña';
    if (v.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  void _goToPassword() => _passFocus.requestFocus();
  void _toggleObscure() => setState(() => _obscure = !_obscure);

  /// Llama al AuthProvider para hacer login.
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true); // muestra loading
    final auth = context.read<AuthProvider>(); 
    final ok = await auth.login(_emailCtrl.text.trim(), _passCtrl.text); 

    if (!mounted) return; // 
    setState(() => _loading = false); 

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales inválidas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Usuario', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailCtrl,
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _goToPassword(),
            decoration: const InputDecoration(hintText: 'Ingrese email'),
            validator: _validateEmail,
          ),

          const SizedBox(height: 14),

          const Text('Contraseña', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passCtrl,
            focusNode: _passFocus,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            obscureText: _obscure,
            decoration: InputDecoration(
              hintText: 'Ingrese password',
              suffixIcon: IconButton(
                onPressed: _toggleObscure,
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            validator: _validatePass,
          ),

          const SizedBox(height: 18),

          ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Iniciar sesión'),
          ),
        ],
      ),
    );
  }
}
