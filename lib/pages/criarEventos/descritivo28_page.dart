import 'package:flutter/material.dart';
import '../criarEventos/widgets/app_bar.dart';
import '../criarEventos/widgets/campo_texto.dart';
import 'evento_dto.dart';

class Descritivo28Page extends StatefulWidget {
  final EventoDTO eventoDTO;
  Descritivo28Page({super.key, EventoDTO? eventoDTO}) : eventoDTO = eventoDTO ?? EventoDTO();

  @override
  State<Descritivo28Page> createState() => _Descritivo28PageState();
}

class _Descritivo28PageState extends State<Descritivo28Page> {
  EventoDTO get dto => ModalRoute.of(context)?.settings.arguments as EventoDTO? ?? widget.eventoDTO;

  final _codigoController = TextEditingController();
  final _valorController = TextEditingController();

  bool? cupom;

  static const Color corFundo = Color(0xFFD6E0D2);
  static const Color corContainer = Color(0xFFE2E8DA);
  static const Color corTextoPrincipal = Color(0xFF284017);
  static const Color corDestaque = Color(0xFFF4B134);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,
      appBar: const AppBarEvento(progresso: 1.0),
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
                  const Text("Promoções ou descontos:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corTextoPrincipal)),
                  const SizedBox(height: 15),

                  _buildRadioWithHeader("Cupom:", cupom, (v) => setState(() => cupom = v)),
                  const SizedBox(height: 15),

                  _buildLabelAndInputRow("Código:", _codigoController),
                  const SizedBox(height: 15),
                  _buildLabelAndInputRow("valor:", _valorController),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            Center(
              child: ElevatedButton(
                onPressed: () {
                   // Populate DTO (Final Step)
                   dto.temCupom = cupom;
                   dto.codigoCupom = _codigoController.text;
                   dto.valorCupom = _valorController.text;

                   
                   print("EVENTO FINAL DATA:");
                   print(dto.toString());

                  //FALTA INTEGRAR C A API DJANGO 
                   Navigator.pushNamed(context, '/criar-eventos-sucesso');
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: corTextoPrincipal,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text("Criar", style: TextStyle(color: corDestaque, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabelAndInputRow(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label, style: const TextStyle(fontSize: 16, color: corTextoPrincipal))),
        Expanded(child: CampoTexto(label: '', largura: double.infinity, controller: controller)),
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