import 'package:flutter/material.dart';
import '../criarEventos/widgets/app_bar.dart';
import '../criarEventos/widgets/campo_texto.dart';
import 'evento_dto.dart';

class Descritivo24Page extends StatefulWidget {
  const Descritivo24Page({super.key});

  @override
  State<Descritivo24Page> createState() => _CriarEventoPageState();
}

class _CriarEventoPageState extends State<Descritivo24Page> {
  final dto = EventoDTO();
  final nomeController = TextEditingController();
  final tipoController = TextEditingController();
  final frequenciaController = TextEditingController();
  final faixaEtariaController = TextEditingController();
  final descricaoController = TextEditingController();

  DateTime? dataInicio;
  DateTime? dataFim;
  TimeOfDay? horaInicio;
  TimeOfDay? horaFim;

  bool privado = false;
  double progresso = 0.2;

  @override
  void dispose() {
    nomeController.dispose();
    tipoController.dispose();
    frequenciaController.dispose();
    faixaEtariaController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  void avancarPagina() {
    setState(() => progresso = 0.65);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E0D2),

      appBar: AppBarEvento(
        progresso: progresso,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ==================== CONTAINER ====================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8DA),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // substituí .withValues(...) por fromRGBO para compatibilidade
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ------------------------------ NOME ------------------------------
                  const Text(
                    "Nome do evento:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  CampoTexto(
                    label: '',
                    largura: double.infinity,
                    controller: nomeController,
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------ INÍCIO ------------------------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 70,
                        child: Text(
                          "Início:",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Expanded(child: Center(child: Text("Data"))),
                                SizedBox(width: 10),
                                Expanded(child: Center(child: Text("Horário"))),
                              ],
                            ),
                            const SizedBox(height: 6),

                            Row(
                              children: [
                                Expanded(
                                  child: CampoTexto(
                                    label: '',
                                    largura: double.infinity,
                                    texto: dataInicio != null
                                        ? '${dataInicio!.day}/${dataInicio!.month}/${dataInicio!.year}'
                                        : 'Selecionar data',
                                    readOnly: true,
                                    onTap: () async {
                                      final d = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                        initialDate: DateTime.now(),
                                      );
                                      setState(() => dataInicio = d);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CampoTexto(
                                    label: '',
                                    largura: double.infinity,
                                    texto: horaInicio != null
                                        ? horaInicio!.format(context)
                                        : 'Selecionar hora',
                                    readOnly: true,
                                    onTap: () async {
                                      final t = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      setState(() => horaInicio = t);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------ FIM ------------------------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 70,
                        child: Text(
                          "Fim:",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Expanded(child: Center(child: Text("Data"))),
                                SizedBox(width: 10),
                                Expanded(child: Center(child: Text("Horário"))),
                              ],
                            ),
                            const SizedBox(height: 6),

                            Row(
                              children: [
                                Expanded(
                                  child: CampoTexto(
                                    label: '',
                                    largura: double.infinity,
                                    texto: dataFim != null
                                        ? '${dataFim!.day}/${dataFim!.month}/${dataFim!.year}'
                                        : 'Selecionar data',
                                    readOnly: true,
                                    onTap: () async {
                                      final d = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                        initialDate: DateTime.now(),
                                      );
                                      setState(() => dataFim = d);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CampoTexto(
                                    label: '',
                                    largura: double.infinity,
                                    texto: horaFim != null
                                        ? horaFim!.format(context)
                                        : 'Selecionar hora',
                                    readOnly: true,
                                    onTap: () async {
                                      final t = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      setState(() => horaFim = t);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------ PRIVADO? ------------------------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Text(
                          'Evento privado?',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            radioTheme: RadioThemeData(
                              fillColor: WidgetStateProperty.all(const Color(0xFFF4B134)),
                            ),
                          ),
                          child: Row(
                            children: [
                              RadioMenuButton<bool>(
                                value: true,
                                groupValue: privado,
                                onChanged: (v) => setState(() => privado = v!),
                                child: const Text('Sim'),
                              ),
                              RadioMenuButton<bool>(
                                value: false,
                                groupValue: privado,
                                onChanged: (v) => setState(() => privado = v!),
                                child: const Text('Não'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------ TIPO ------------------------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Text(
                          'Tipo de evento:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CampoTexto(
                          label: '',
                          largura: double.infinity,
                          controller: tipoController,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------ FREQUÊNCIA ------------------------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Text(
                          'Frequência:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CampoTexto(
                          label: '',
                          largura: double.infinity,
                          controller: frequenciaController,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------ FAIXA ETÁRIA ------------------------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Text(
                          'Faixa etária:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CampoTexto(
                          label: '',
                          largura: double.infinity,
                          controller: faixaEtariaController,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------ DESCRIÇÃO ------------------------------
                  const Text(
                     "Descrição do evento:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  CampoTexto(
                    label: '',
                    largura: double.infinity,
                    altura: 200,
                    controller: descricaoController,
                  ),

                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text("0/250 caracteres."),
                  ),

                ],
              ),
            ),
            // ==================== FIM DO CONTAINER ====================

            const SizedBox(height: 25),

             const SizedBox(height: 30),
   
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Populate DTO
                    dto.nome = nomeController.text;
                    dto.tipo = tipoController.text;
                    dto.frequencia = frequenciaController.text;
                    dto.faixaEtaria = faixaEtariaController.text;
                    dto.descricao = descricaoController.text;
                    dto.dataInicio = dataInicio;
                    dto.horaInicio = horaInicio;
                    dto.dataFim = dataFim;
                    dto.horaFim = horaFim;
                    dto.privado = privado;

                    Navigator.pushNamed(
                      context,
                      '/criar-eventos-etapa-2',
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
}
