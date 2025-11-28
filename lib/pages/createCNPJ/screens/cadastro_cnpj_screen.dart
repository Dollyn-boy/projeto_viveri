import 'package:flutter/material.dart';
import '../controllers/cadastro_controller.dart';

class CadastroCnpjScreen extends StatefulWidget {
  const CadastroCnpjScreen({super.key});

  @override
  State<CadastroCnpjScreen> createState() => _CadastroCnpjScreenState();
}

class _CadastroCnpjScreenState extends State<CadastroCnpjScreen> {
  bool _senhaVisivel = false;
  bool aceitaTermos = false;
  String tipoConta = "CNPJ";

  final auth = CadastroController();

  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController nomeFantasiaController = TextEditingController();
  final TextEditingController empresaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController nomeResponsavelController = TextEditingController();
  final TextEditingController sobrenomeResponsavelController = TextEditingController();

  @override
  void dispose() {
    cnpjController.dispose();
    nomeFantasiaController.dispose();
    empresaController.dispose();
    emailController.dispose();
    senhaController.dispose();
    nomeResponsavelController.dispose();
    sobrenomeResponsavelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final criarContaButton = SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F6446),
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
            auth.validarCadastro(
              context,
              cnpjController.text,
              nomeFantasiaController.text,
              emailController.text,
              senhaController.text,
              nomeResponsavelController.text,
              sobrenomeResponsavelController.text,
              aceitaTermos,
              tipoConta
            );

        },
        child: const Text(
          "Criar conta",
          style: TextStyle(
            color: Color(0xFFF4C542),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFD6E8D2),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Cadastro de Empresa",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // FOTO + CPF/CNPJ
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => print("clicou na galinha!"),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF8CA57A),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    "assets/images/galinha.png",
                    width: 150,
                    height: 150,
                  ),
                ),
              ),

    const SizedBox(width: 20),

    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tipoConta == "CPF"
                        ? const Color(0xFF4F6446)
                        : Colors.white,
                    foregroundColor: tipoConta == "CPF"
                        ? Colors.white
                        : const Color(0xFF4F6446),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xFF4F6446)),
                    ),
                  ),
                  onPressed: () {
                    setState(() => tipoConta = "CPF");
                  },
                  child: const Text("CPF"),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tipoConta == "CNPJ"
                        ? const Color(0xFFF4C542)
                        : Colors.white,
                    foregroundColor: tipoConta == "CNPJ"
                        ? Colors.black
                        : const Color(0xFF4F6446),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xFF4F6446)),
                    ),
                  ),
                  onPressed: () {
                    setState(() => tipoConta = "CNPJ");
                  },
                  child: const Text("CNPJ"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Text("Número do CNPJ:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          
          const SizedBox(height: 6),
          TextField(
            controller: cnpjController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(), 
          ),
          )
        ],
      ),
    ),
  ],
),


                const SizedBox(height: 30),

                // CAMPOS
                const Text("Nome Fantasia:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: nomeFantasiaController,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),

                const SizedBox(height: 20),

                const Text("Email:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),

                const SizedBox(height: 20),

                const Text("Senha:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: senhaController,
                  obscureText: !_senhaVisivel,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _senhaVisivel
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _senhaVisivel = !_senhaVisivel;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Dados do Responsável",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                const Divider(thickness: 2),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Nome:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: nomeResponsavelController,
                            decoration:
                                const InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Sobrenome:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: sobrenomeResponsavelController,
                            decoration:
                                const InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                Row(
                    children: [
                        Checkbox(
                        value: aceitaTermos,
                        onChanged: (value) {
                            setState(() => aceitaTermos = value!);
                        },
                        ),
                        const Text("Aceito os termos e condições"),
                    ],
                ),
                


                const SizedBox(height: 40),

                criarContaButton,

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      "Já possui uma conta? Faça login",
                      style: TextStyle(
                        color: Color(0xFF4F6446),
                      ),
                    ),
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
