import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool emailValido(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool senhaValida(String senha) {
    return senha.length >= 6;
  }

  bool camposPreenchidos() {
    return emailController.text.isNotEmpty && senhaController.text.isNotEmpty;
  }

  void mostrarErro(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (!emailValido(email)) {
      mostrarErro("Email inválido");
      return;
    }

    if (!senhaValida(senha)) {
      mostrarErro("Senha inválida");
      return;
    }

    // TODO: backend:
    // mandar email e senha para validar os dados.

    // simulando que o login seja inválido
    bool sucesso = false;

    // manda pra tela de dados inválidos
    if (!sucesso) {
    // TODO: criar rota /login-invalido
    //   Navigator.pushNamedAndRemoveUntil(
    //     context,
    //     '/login-invalido',
    //     (route) => false,
    //   );
    } // else {
    // vai mandar pra tela inicial do app
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD4E0D4),
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 390,
            height: 844,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          // Logo VIVERI
                          'assets/images/logo_viveri.png',
                          width: 180,
                          height: 172,
                        ),

                        const SizedBox(height: 48),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email:',
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0xFF284017),
                              ),
                            ),

                            const SizedBox(height: 4),

                            SizedBox(
                              width: 300,
                              height: 48,
                              child: TextField(
                                controller: emailController,
                                maxLength: 256,
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: Color.fromARGB(26, 40, 64, 23),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 33),

                            const Text(
                              'Senha:',
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0xFF284017),
                              ),
                            ),

                            const SizedBox(height: 4),

                            SizedBox(
                              width: 300,
                              height: 48,
                              child: TextField(
                                controller: senhaController,
                                obscureText: true,
                                maxLength: 64,
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: Color.fromARGB(26, 40, 64, 23),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            SizedBox(
                              width: 300,
                              child: RichText(
                                textAlign: TextAlign.right,
                                text: TextSpan(
                                  text: 'Esqueci minha senha',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFF284017),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                        context,
                                        '/recuperar-senha',
                                      );
                                    },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 48),

                        ElevatedButton(
                          onPressed: () {
                            camposPreenchidos() ? login() : mostrarErro("Preencha email e senha");
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Color(0xFF284017),
                            ),
                            minimumSize: WidgetStateProperty.all(Size(180, 48)),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFFF4B134),
                            ),
                          ),
                        ),

                        const SizedBox(height: 68),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 0.5,
                              width: 80,
                              color: Color(0xFF284017),
                            ),

                            const SizedBox(width: 20),

                            const Text(
                              'ou',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1C2F0F),
                              ),
                            ),

                            const SizedBox(width: 20),

                            Container(
                              height: 0.5,
                              width: 80,
                              color: Color(0xFF284017),
                            ),
                          ],
                        ),

                        const SizedBox(height: 21),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(14, 40, 64, 23),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // TODO: integração pra entrar com o google
                                },
                                child: Image.asset(
                                  'assets/images/google-icon.png',
                                  width: 49,
                                  height: 48,
                                ),
                              ),
                            ),

                            const SizedBox(width: 39),

                            Container(
                              width: 0.5,
                              height: 50,
                              color: Color(0xFF284017),
                            ),

                            const SizedBox(width: 39),

                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(14, 40, 64, 23),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // TODO: integração pra entrar com o instagram
                                },
                                child: Image.asset(
                                  'assets/images/instagram-icon.png',
                                  width: 49,
                                  height: 48,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 84),

                        RichText(
                          text: TextSpan(
                            text: 'Criar Conta',
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFF1C2F0F),
                              fontWeight: FontWeight.w900,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // TODO: adicionar redirecionamento para página de criação de conta
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/criar-conta',
                                  (route) => false,
                                );
                              },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
