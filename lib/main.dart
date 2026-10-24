import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MiApp());
}

const morado = Color(0xFF673AB7);
const fondo = Color(0xFFF6F3FF);

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login y Registro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: morado),
        scaffoldBackgroundColor: fondo,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// COMPONENTE PARA LOS CAMPOS
class CampoTexto extends StatelessWidget {
  final String etiqueta;
  final TextEditingController controller;
  final bool contrasena;
  final bool mostrar;
  final VoidCallback? cambiarVisibilidad;
  final TextInputType tipo;

  const CampoTexto({
    super.key,
    required this.etiqueta,
    required this.controller,
    this.contrasena = false,
    this.mostrar = false,
    this.cambiarVisibilidad,
    this.tipo = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: tipo,
        obscureText: contrasena && !mostrar,
        decoration: InputDecoration(
          labelText: etiqueta,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: contrasena
              ? IconButton(
                  icon: Icon(
                    mostrar ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: cambiarVisibilidad,
                )
              : null,
        ),
      ),
    );
  }
}

// COMPONENTE PARA LOS BOTONES
class BotonPrincipal extends StatelessWidget {
  final String texto;
  final VoidCallback accion;

  const BotonPrincipal({
    super.key,
    required this.texto,
    required this.accion,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: accion,
        style: ElevatedButton.styleFrom(
          backgroundColor: morado,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(texto),
      ),
    );
  }
}

bool correoValido(String correo) {
  return RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  ).hasMatch(correo);
}

void mensaje(BuildContext context, String texto) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(texto)),
  );
}

// 1. LOGIN
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final correo = TextEditingController();
  final contrasena = TextEditingController();
  bool mostrar = false;

  void iniciarSesion() {
    if (correo.text.trim().isEmpty || contrasena.text.isEmpty) {
      mensaje(context, 'Completa todos los campos');
    } else if (!correoValido(correo.text.trim())) {
      mensaje(context, 'Ingresa un correo válido');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(correo: correo.text.trim()),
        ),
      );
    }
  }

  @override
  void dispose() {
    correo.dispose();
    contrasena.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 25),
              const Icon(Icons.lock_outline, size: 70, color: morado),
              const SizedBox(height: 15),
              const Text(
                'Bienvenido de nuevo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Inicia sesión para continuar',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              CampoTexto(
                etiqueta: 'Correo electrónico',
                controller: correo,
                tipo: TextInputType.emailAddress,
              ),
              CampoTexto(
                etiqueta: 'Contraseña',
                controller: contrasena,
                contrasena: true,
                mostrar: mostrar,
                cambiarVisibilidad: () {
                  setState(() => mostrar = !mostrar);
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecuperarScreen(
                          correoInicial: correo.text.trim(),
                        ),
                      ),
                    );
                  },
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ),
              BotonPrincipal(
                texto: 'Iniciar sesión',
                accion: iniciarSesion,
              ),
              const SizedBox(height: 20),
              const Center(child: Text('o continúa con')),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () =>
                    mensaje(context, 'Funcionalidad no disponible'),
                child: const Text('Continuar con Google'),
              ),
              OutlinedButton(
                onPressed: () =>
                    mensaje(context, 'Funcionalidad no disponible'),
                child: const Text('Continuar con Apple'),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegistroScreen(),
                      ),
                    );
                  },
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. REGISTRO
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final nombre = TextEditingController();
  final correo = TextEditingController();
  final contrasena = TextEditingController();
  final confirmar = TextEditingController();

  bool mostrar = false;
  bool terminos = false;

  void crearCuenta() {
    if (nombre.text.trim().isEmpty ||
        correo.text.trim().isEmpty ||
        contrasena.text.isEmpty ||
        confirmar.text.isEmpty) {
      mensaje(context, 'Completa todos los campos');
    } else if (!correoValido(correo.text.trim())) {
      mensaje(context, 'Ingresa un correo válido');
    } else if (contrasena.text != confirmar.text) {
      mensaje(context, 'Las contraseñas no coinciden');
    } else if (!terminos) {
      mensaje(context, 'Debes aceptar los términos');
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(correo: correo.text.trim()),
        ),
        (route) => route.isFirst,
      );
    }
  }

  @override
  void dispose() {
    nombre.dispose();
    correo.dispose();
    contrasena.dispose();
    confirmar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro'), backgroundColor: fondo),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.person_add_alt_1, size: 65, color: morado),
              const SizedBox(height: 12),
              const Text(
                'Crea tu cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              CampoTexto(etiqueta: 'Nombre completo', controller: nombre),
              CampoTexto(
                etiqueta: 'Correo electrónico',
                controller: correo,
                tipo: TextInputType.emailAddress,
              ),
              CampoTexto(
                etiqueta: 'Contraseña',
                controller: contrasena,
                contrasena: true,
                mostrar: mostrar,
                cambiarVisibilidad: () {
                  setState(() => mostrar = !mostrar);
                },
              ),
              CampoTexto(
                etiqueta: 'Confirmar contraseña',
                controller: confirmar,
                contrasena: true,
                mostrar: mostrar,
                cambiarVisibilidad: () {
                  setState(() => mostrar = !mostrar);
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Acepto los términos y condiciones'),
                value: terminos,
                onChanged: (valor) {
                  setState(() => terminos = valor ?? false);
                },
              ),
              const SizedBox(height: 15),
              BotonPrincipal(texto: 'Crear cuenta', accion: crearCuenta),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('¿Ya tienes cuenta? Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. RECUPERAR CONTRASEÑA
class RecuperarScreen extends StatefulWidget {
  final String correoInicial;

  const RecuperarScreen({super.key, this.correoInicial = ''});

  @override
  State<RecuperarScreen> createState() => _RecuperarScreenState();
}

class _RecuperarScreenState extends State<RecuperarScreen> {
  late final TextEditingController correo;

  @override
  void initState() {
    super.initState();
    correo = TextEditingController(text: widget.correoInicial);
  }

  void continuar() {
    if (correo.text.trim().isEmpty) {
      mensaje(context, 'Escribe tu correo electrónico');
    } else if (!correoValido(correo.text.trim())) {
      mensaje(context, 'Ingresa un correo válido');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CodigoScreen(correo: correo.text.trim()),
        ),
      );
    }
  }

  @override
  void dispose() {
    correo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: fondo),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.mark_email_read_outlined,
                  size: 70, color: morado),
              const SizedBox(height: 20),
              const Text(
                'Recuperar contraseña',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Escribe tu correo para continuar con la recuperación.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              CampoTexto(
                etiqueta: 'Correo electrónico',
                controller: correo,
                tipo: TextInputType.emailAddress,
              ),
              BotonPrincipal(
                texto: 'Enviar código',
                accion: continuar,
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('¿La recordaste? Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. CÓDIGO DE VERIFICACIÓN
class CodigoScreen extends StatefulWidget {
  final String correo;

  const CodigoScreen({super.key, required this.correo});

  @override
  State<CodigoScreen> createState() => _CodigoScreenState();
}

class _CodigoScreenState extends State<CodigoScreen> {
  final casillas = List.generate(4, (_) => TextEditingController());
  final focos = List.generate(4, (_) => FocusNode());

  Timer? temporizador;
  int segundos = 45;

  @override
  void initState() {
    super.initState();
    iniciarTemporizador();
  }

  void iniciarTemporizador() {
    temporizador?.cancel();
    setState(() => segundos = 45);

    temporizador = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (segundos <= 1) {
        timer.cancel();
        setState(() => segundos = 0);
      } else {
        setState(() => segundos--);
      }
    });
  }

  void verificar() {
    final codigo = casillas.map((c) => c.text).join();

    if (codigo.length != 4 || !RegExp(r'^\d{4}$').hasMatch(codigo)) {
      mensaje(context, 'Escribe los 4 dígitos');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NuevaContrasenaScreen(correo: widget.correo),
      ),
    );
  }

  @override
  void dispose() {
    temporizador?.cancel();
    for (final c in casillas) {
      c.dispose();
    }
    for (final f in focos) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: fondo),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.verified_user_outlined,
                  size: 65, color: morado),
              const SizedBox(height: 20),
              const Text(
                'Código de verificación',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Ingresa el código enviado a ${widget.correo}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                children: List.generate(4, (i) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        controller: casillas[i],
                        focusNode: focos[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (valor) {
                          if (valor.isNotEmpty) {
                            casillas[i].text =
                                valor.replaceAll(RegExp(r'[^0-9]'), '');
                            casillas[i].selection =
                                const TextSelection.collapsed(offset: 1);
                            if (i < 3 && casillas[i].text.isNotEmpty) {
                              focos[i + 1].requestFocus();
                            } else {
                              focos[i].unfocus();
                            }
                          } else if (i > 0) {
                            focos[i - 1].requestFocus();
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Center(
                child: segundos > 0
                    ? Text(
                        'Reenviar código en 00:${segundos.toString().padLeft(2, '0')}',
                      )
                    : TextButton(
                        onPressed: iniciarTemporizador,
                        child: const Text('Reenviar código'),
                      ),
              ),
              const SizedBox(height: 15),
              BotonPrincipal(
                texto: 'Verificar código',
                accion: verificar,
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 5. NUEVA CONTRASEÑA
class NuevaContrasenaScreen extends StatefulWidget {
  final String correo;

  const NuevaContrasenaScreen({super.key, required this.correo});

  @override
  State<NuevaContrasenaScreen> createState() =>
      _NuevaContrasenaScreenState();
}

class _NuevaContrasenaScreenState extends State<NuevaContrasenaScreen> {
  final nueva = TextEditingController();
  final confirmar = TextEditingController();
  bool mostrar = false;

  bool get longitud => nueva.text.length >= 8;
  bool get mayuscula => RegExp(r'[A-Z]').hasMatch(nueva.text);
  bool get numero => RegExp(r'[0-9]').hasMatch(nueva.text);

  void guardar() {
    if (!longitud || !mayuscula || !numero) {
      mensaje(context, 'Cumple todos los requisitos de la contraseña');
    } else if (nueva.text != confirmar.text) {
      mensaje(context, 'Las contraseñas no coinciden');
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      // El mensaje aparece en Login al volver.
      Future.delayed(const Duration(milliseconds: 300), () {
        // No se realiza ninguna operación con backend.
      });
    }
  }

  Widget requisito(String texto, bool cumplido) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            cumplido ? Icons.check_circle : Icons.cancel_outlined,
            color: cumplido ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(texto),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nueva.dispose();
    confirmar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: fondo),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_reset, size: 65, color: morado),
              const SizedBox(height: 15),
              const Text(
                'Nueva contraseña',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Center(
                child: Chip(
                  label: Text('Código verificado'),
                  avatar: Icon(Icons.check_circle, color: Colors.green),
                ),
              ),
              const SizedBox(height: 25),
              CampoTexto(
                etiqueta: 'Nueva contraseña',
                controller: nueva,
                contrasena: true,
                mostrar: mostrar,
                cambiarVisibilidad: () {
                  setState(() => mostrar = !mostrar);
                },
              ),
              CampoTexto(
                etiqueta: 'Confirmar contraseña',
                controller: confirmar,
                contrasena: true,
                mostrar: mostrar,
                cambiarVisibilidad: () {
                  setState(() => mostrar = !mostrar);
                },
              ),
              const Text(
                'Requisitos de la contraseña:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              requisito('Mínimo 8 caracteres', longitud),
              requisito('Una letra mayúscula', mayuscula),
              requisito('Un número', numero),
              const SizedBox(height: 20),
              BotonPrincipal(
                texto: 'Guardar contraseña',
                accion: guardar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 6. HOME
class HomeScreen extends StatelessWidget {
  final String correo;

  const HomeScreen({super.key, required this.correo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: morado,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  '¡Bienvenido!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(correo),
                const SizedBox(height: 25),
                BotonPrincipal(
                  texto: 'Cerrar sesión',
                  accion: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}