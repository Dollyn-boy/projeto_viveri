import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CriarPerguntaPage(),
  ));
}

class CriarPerguntaPage extends StatefulWidget {
  const CriarPerguntaPage({super.key});

  @override
  State<CriarPerguntaPage> createState() => _CriarPerguntaPageState();
}

class _CriarPerguntaPageState extends State<CriarPerguntaPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_inputFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_textController.text.trim().isNotEmpty) {
      print("Enviando: ${_textController.text}");
      // lógica para fechar a tela ou salvar
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE6DA),
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: const Color(0xFF566B5E),
        elevation: 0,
        centerTitle: true,
        
        leading: Center(
          child: GestureDetector(
            onTap: () {
               if (Navigator.canPop(context)) {
                 Navigator.pop(context);
               }
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                color: Color(0xFF3B4A3F), // Verde Escuro
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left, // Setinha para esquerda
                color: Colors.amber,
                size: 24,
              ),
            ),
          ),
        ),

        title: Column(
          children: [
            Text('FAQ',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18)),
            const SizedBox(
                width: 40,
                child: Divider(color: Colors.black26, thickness: 2)),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Faça uma pergunta:",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),

              // CAIXA DE TEXTO
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: const Color(0xFFBCC8BC),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _textController,
                  focusNode: _inputFocusNode,
                  maxLines: null,
                  expands: true,
                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.black87),
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Digite sua dúvida aqui...",
                    hintStyle: GoogleFonts.roboto(color: Colors.black45),
                    border: InputBorder.none,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight, // Alinha à direita
                child: GestureDetector(
                  onTap: _handleSend,
                  child: Container(
                    width: 50, 
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3B4A3F), // MESMA COR do botão voltar
                      shape: BoxShape.circle,
                      boxShadow: [ // Uma sombra leve para destacar
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2)
                        )
                      ]
                    ),
                    child: const Icon(
                      Icons.arrow_forward, // Setinha para direita (Enviar)
                      color: Colors.amber,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}