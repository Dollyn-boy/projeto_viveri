import 'package:flutter/material.dart';
import '../criarEventos/widgets/app_bar.dart';
import '../criarEventos/widgets/campo_texto.dart';
import 'evento_dto.dart';

class Descritivo25Page extends StatefulWidget {
  final EventoDTO eventoDTO;
  Descritivo25Page({super.key, EventoDTO? eventoDTO}) : eventoDTO = eventoDTO ?? EventoDTO();

  @override
  State<Descritivo25Page> createState() => _CriarEventoPage2State();
}

class _CriarEventoPage2State extends State<Descritivo25Page> {
  EventoDTO get dto => ModalRoute.of(context)?.settings.arguments as EventoDTO? ?? widget.eventoDTO;

  static const Color corFundo = Color(0xFFD6E0D2);
  static const Color corContainer = Color(0xFFE2E8DA);
  static const Color corTextoPrincipal = Color(0xFF284017);
  static const Color corDestaque = Color(0xFFF4B134);

  final TextEditingController _nomeLocalController = TextEditingController();
  final TextEditingController _cep1Controller = TextEditingController();
  final TextEditingController _cep2Controller = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _capacidadeController = TextEditingController();

  String? estacionamento = '';
  String? bife = '';
  String? quarto = '';

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: corFundo,
      appBar: const AppBarEvento(progresso: 0.5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
        child: Column(
          children: [
           
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: corContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Sobre o local:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: corTextoPrincipal,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Nome do Local
                  const Text(
                    "Nome do local:",
                    style: TextStyle(fontSize: 16, color: corTextoPrincipal),
                  ),
                  const SizedBox(height: 5),
                  CampoTexto(
                    controller: _nomeLocalController,
                    label: 'Nome do local',
                    largura: screenWidth,
                    altura: 40,
                  ),
                  const SizedBox(height: 15),

                  // CEP
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      const Text(
                        "CEP:",
                        style:
                            TextStyle(fontSize: 16, color: corTextoPrincipal),
                      ),
                      const SizedBox(width: 10),

                      CampoTexto(
                        controller: _cep1Controller,
                        label: '',
                        largura: 120,
                        altura: 40,
                      ),
                      const SizedBox(width: 10),

                      CampoTexto(
                        controller: _cep2Controller,
                        label: '',
                        largura: 100,
                        altura: 40,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Endereço
                  const Text(
                    "Endereço completo:",
                    style: TextStyle(fontSize: 16, color: corTextoPrincipal),
                  ),
                  const SizedBox(height: 5),
                  CampoTexto(
                    controller: _enderecoController,
                    label: 'Endereço completo',
                    largura: screenWidth,
                    altura: 40,
                  ),
                  const SizedBox(height: 15),

                  // Capacidade
                  Row(
                    children: <Widget>[
                      const Text(
                        "Capacidade máxima:",
                        style:
                            TextStyle(fontSize: 16, color: corTextoPrincipal),
                      ),
                      const SizedBox(width: 10),
                      CampoTexto(
                        controller: _capacidadeController,
                        label: '',
                        largura: 100,
                        altura: 40,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    "Comodidades:",
                    style: TextStyle(
                      fontSize: 16,
                      color: corTextoPrincipal,
                    ),
                  ),
                  const SizedBox(height: 10),

                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300, 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            SizedBox(
                              width: 40,
                              child: Text(
                                "Sim",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              child: Text(
                                "Não",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  _linhaRadio("Estacionamento", estacionamento, (val) {
                    setState(() => estacionamento = val);
                  }),
                  _linhaRadio("Bifê", bife, (val) {
                    setState(() => bife = val);
                  }),
                  _linhaRadio("Quarto", quarto, (val) {
                    setState(() => quarto = val);
                  }),
                ],
              ),
            ),

            const SizedBox(height: 30),
   
            Center(
              child: ElevatedButton(
                
                onPressed: () {
                    // Populate DTO
                    dto.localNome = _nomeLocalController.text;
                    dto.cep = "${_cep1Controller.text}-${_cep2Controller.text}";
                    dto.endereco = _enderecoController.text;
                    dto.capacidade = _capacidadeController.text;
                    dto.estacionamento = estacionamento;
                    dto.bife = bife;
                    dto.quarto = quarto;

                    Navigator.pushNamed(
                      context,
                      '/criar-eventos-etapa-3',
                      arguments: dto,
                    );    
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF284017),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4), 
                  ),
                  elevation: 0, 
                ),
                child: const Text(
                  "Próximo", 
                  style: TextStyle(
                    color: Color(0xFFF4B134), 
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget _linhaRadio(
      String label, String? grupo, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: corTextoPrincipal,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Radio<String>(
                        value: "sim",
                        groupValue: grupo,
                        onChanged: onChanged,
                        activeColor: corDestaque,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Radio<String>(
                        value: "nao",
                        groupValue: grupo,
                        onChanged: onChanged,
                        activeColor: corDestaque,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
