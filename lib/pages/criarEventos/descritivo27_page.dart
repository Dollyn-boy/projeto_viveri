import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../criarEventos/widgets/app_bar.dart';
import '../criarEventos/widgets/campo_texto.dart';
import 'evento_dto.dart';

class Descritivo27Page extends StatefulWidget {
  final EventoDTO eventoDTO;
  Descritivo27Page({super.key, EventoDTO? eventoDTO}) : eventoDTO = eventoDTO ?? EventoDTO();

  @override
  State<Descritivo27Page> createState() => _Descritivo27PageState();
}

class _Descritivo27PageState extends State<Descritivo27Page> {
  EventoDTO get dto => ModalRoute.of(context)?.settings.arguments as EventoDTO? ?? widget.eventoDTO;

  bool? estacionamento;
  bool? areaPet;
  bool? espacoKids;

  List<bool> formasPagamento = [false, false, false];

  String nomeFotoLocal = "Anexar.jpg";
  String nomeFotoEstabelecimento = "Anexar.jpg";

  String? pathFotoLocal;
  String? pathFotoEstabelecimento;

  static const Color corFundo = Color(0xFFD6E0D2);
  static const Color corContainer = Color(0xFFE2E8DA);
  static const Color corTextoPrincipal = Color(0xFF284017);
  static const Color corDestaque = Color(0xFFF4B134);

  Future<void> selecionarArquivo(Function(String) setNome, Function(String?) setPath) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        setNome(result.files.single.name);
        setPath(result.files.single.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,
      appBar: const AppBarEvento(progresso: 0.8),
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
                  const Text("Imagens:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corTextoPrincipal)),
                  const SizedBox(height: 15),

                  _buildAnexarRow("Local:", nomeFotoLocal, () => selecionarArquivo((n) => nomeFotoLocal = n, (p) => pathFotoLocal = p)),
                  const SizedBox(height: 10),

                  _buildAnexarRow("Estabelecimento:", nomeFotoEstabelecimento, () => selecionarArquivo((n) => nomeFotoEstabelecimento = n, (p) => pathFotoEstabelecimento = p)),
                  const SizedBox(height: 15),

                  _buildRadioWithHeader("Estacionamento?", estacionamento, (val) => setState(() => estacionamento = val)),
                  const SizedBox(height: 10),
                  _buildRadioWithHeader("Área pet?", areaPet, (val) => setState(() => areaPet = val)),

                  const SizedBox(height: 25),

                  const Text("Conteúdo adicional:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: corTextoPrincipal)),
                  const SizedBox(height: 15),

                  _buildRadioWithHeader("Espaço kids?", espacoKids, (val) => setState(() => espacoKids = val)),
                  
                  const SizedBox(height: 20),

                  const Text("Formas de pagamento:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: corTextoPrincipal)),
                  const SizedBox(height: 10),
                  
                  _buildCheckboxItem("Dinheiro", 0),
                  _buildCheckboxItem("Cartão", 1),
                  _buildCheckboxItem("Pix", 2),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            Center(
              child: ElevatedButton(
                onPressed: () {
                  dto.nomeFotoLocal = nomeFotoLocal;
                  dto.pathFotoLocal = pathFotoLocal;
                  dto.nomeFotoEstabelecimento = nomeFotoEstabelecimento;
                  dto.pathFotoEstabelecimento = pathFotoEstabelecimento;
                  dto.temEstacionamento = estacionamento;
                  dto.areaPet = areaPet;
                  dto.espacoKids = espacoKids;
                  dto.formasPagamento = formasPagamento;

                  Navigator.pushNamed(
                    context, 
                    '/criar-eventos-etapa-5',
                    arguments: dto,
                  );
               },
                style: ElevatedButton.styleFrom(
                  backgroundColor: corTextoPrincipal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text("Próximo", style: TextStyle(color: corDestaque, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _buildCheckboxItem(String label, int index) {
    return Row(
      children: [
        Checkbox(
          value: formasPagamento[index],
          activeColor: corDestaque,
          checkColor: corTextoPrincipal,
          onChanged: (bool? value) {
            setState(() {
              formasPagamento[index] = value ?? false;
            });
          },
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: corTextoPrincipal),
        ),
      ],
    );
  }


  Widget _buildAnexarRow(String label, String btnText, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 130, child: Text(label, style: const TextStyle(fontSize: 16, color: corTextoPrincipal))),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFC1CEBF),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black12),
              ),
              child: Center(
                child: Text(
                  btnText, 
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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