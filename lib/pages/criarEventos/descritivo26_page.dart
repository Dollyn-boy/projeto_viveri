import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../criarEventos/widgets/app_bar.dart';
import '../criarEventos/widgets/campo_texto.dart';
import 'evento_dto.dart';

class Descritivo26Page extends StatefulWidget {
  final EventoDTO eventoDTO;
  Descritivo26Page({super.key, EventoDTO? eventoDTO}) : eventoDTO = eventoDTO ?? EventoDTO();

  @override
  State<Descritivo26Page> createState() => _Descritivo26PageState();
}

class _Descritivo26PageState extends State<Descritivo26Page> {
  EventoDTO get dto => ModalRoute.of(context)?.settings.arguments as EventoDTO? ?? widget.eventoDTO;

  final _nomeIngressoController = TextEditingController();
  final _valorController = TextEditingController();
  final _taxaController = TextEditingController();
  
  bool? eventoGratuito;
  bool? menorIdade;
  bool? estudantes;

  String nomeArquivoRegras = "Anexar.pdf";
  String nomeArquivoVestimentas = "Anexar.pdf";
  String nomeArquivoGenero = "Anexar.pdf";

  String? pathRegras;
  String? pathVestimentas;
  String? pathGenero;

  static const Color corFundo = Color(0xFFD6E0D2);
  static const Color corContainer = Color(0xFFE2E8DA);
  static const Color corTextoPrincipal = Color(0xFF284017);
  static const Color corDestaque = Color(0xFFF4B134);

  Future<void> selecionarArquivo(
    Function(String) setNome, 
    Function(String?) setPath
  ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      String nome = result.files.single.name;
      String? caminho = result.files.single.path; 

      setState(() {
        setNome(nome);    
        setPath(caminho);
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,
      appBar: const AppBarEvento(progresso: 0.65),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: corContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Operacional:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corTextoPrincipal)),
                  const SizedBox(height: 15),

                  _buildRadioWithHeader("Evento gratuito?", eventoGratuito, (val) => setState(() => eventoGratuito = val)),
                  const SizedBox(height: 15),

                  const Text("Nome do ingresso:", style: TextStyle(fontSize: 16, color: corTextoPrincipal)),
                  const SizedBox(height: 5),
                  CampoTexto(label: '', largura: double.infinity, controller: _nomeIngressoController),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Valor:", style: TextStyle(fontSize: 16, color: corTextoPrincipal)),
                            const SizedBox(height: 5),
                            CampoTexto(label: '', largura: double.infinity, controller: _valorController),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Taxa:", style: TextStyle(fontSize: 16, color: corTextoPrincipal)),
                            const SizedBox(height: 5),
                            CampoTexto(label: '', largura: double.infinity, controller: _taxaController),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),


                  const SizedBox(height: 25),

                  const Text("Politicas:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corTextoPrincipal)),
                  const SizedBox(height: 15),

                  // AQUI: Passamos as duas funções (uma pra mudar o nome, outra pra salvar o path)
                  _buildAnexarRow(
                    "Regras Gerais", 
                    nomeArquivoRegras, 
                    () => selecionarArquivo(
                      (n) => nomeArquivoRegras = n, 
                      (p) => pathRegras = p
                    )
                  ),
                  const SizedBox(height: 10),
                  
                  _buildAnexarRow(
                    "Vestimentas", 
                    nomeArquivoVestimentas,
                    () => selecionarArquivo(
                      (n) => nomeArquivoVestimentas = n,
                      (p) => pathVestimentas = p
                    )
                  ),
                  const SizedBox(height: 10),
                  
                  _buildAnexarRow(
                    "Pol. de gênero", 
                    nomeArquivoGenero,
                    () => selecionarArquivo(
                      (n) => nomeArquivoGenero = n,
                      (p) => pathGenero = p
                    )
                  ),
                  const SizedBox(height: 15),

                  _buildRadioWithHeader("Menor de idade?", menorIdade, (val) => setState(() => menorIdade = val)),
                  const SizedBox(height: 10),
                  _buildRadioWithHeader("Estudantes?", estudantes, (val) => setState(() => estudantes = val)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            Center(
              child: ElevatedButton(
                onPressed: () {
                    
                    dto.eventoGratuito = eventoGratuito;
                    dto.nomeIngresso = _nomeIngressoController.text;
                    dto.valorIngresso = _valorController.text;
                    dto.taxaIngresso = _taxaController.text;
                    dto.nomeArquivoRegras = nomeArquivoRegras;
                    dto.pathRegras = pathRegras;
                    dto.nomeArquivoVestimentas = nomeArquivoVestimentas;
                    dto.pathVestimentas = pathVestimentas;
                    dto.nomeArquivoGenero = nomeArquivoGenero;
                    dto.pathGenero = pathGenero;
                    dto.menorIdade = menorIdade;
                    dto.estudantes = estudantes;

                    Navigator.pushNamed(
                      context,
                      '/criar-eventos-etapa-4',
                      arguments: dto,
                    );    
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: corTextoPrincipal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text("Proximo", style: TextStyle(color: corDestaque, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAnexarRow(String label, String btnText, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: corTextoPrincipal)),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFC1CEBF),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black12),
            ),
            constraints: const BoxConstraints(maxWidth: 150),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.attach_file, size: 16, color: Colors.black54),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    btnText, 
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRadioWithHeader(String label, bool? groupValue, Function(bool?) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16, color: corTextoPrincipal))),
        Row(
          children: [
            _buildRadioItem("Sim", true, groupValue, onChanged),
            const SizedBox(width: 10),
            _buildRadioItem("Não", false, groupValue, onChanged),
          ],
        )
      ],
    );
  }

  Widget _buildRadioItem(String header, bool value, bool? groupValue, Function(bool?) onChanged) {
    return Column(
      children: [
        Text(header, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        Radio<bool>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: corDestaque,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        )
      ],
    );
  }
}