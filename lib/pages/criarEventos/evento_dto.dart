import 'package:flutter/material.dart';

class EventoDTO {
  // Page 24 Data
  String? nome;
  String? tipo;
  String? frequencia;
  String? faixaEtaria;
  String? descricao;
  DateTime? dataInicio;
  DateTime? dataFim;
  TimeOfDay? horaInicio;
  TimeOfDay? horaFim;
  bool? privado;

  // Page 25 Data
  String? localNome;
  String? cep; // combining cep1 and cep2
  String? endereco;
  String? capacidade;
  String? estacionamento;
  String? bife;
  String? quarto;

  // Page 26 Data
  bool? eventoGratuito;
  String? nomeIngresso;
  String? valorIngresso;
  String? taxaIngresso;
  String? nomeArquivoRegras;
  String? pathRegras;
  String? nomeArquivoVestimentas;
  String? pathVestimentas;
  String? nomeArquivoGenero;
  String? pathGenero;
  bool? menorIdade;
  bool? estudantes;

  // Page 27 Data
  String? nomeFotoLocal;
  String? pathFotoLocal;
  String? nomeFotoEstabelecimento;
  String? pathFotoEstabelecimento;
  bool? temEstacionamento; // distinct from page 25's string radio?
  bool? areaPet;
  bool? espacoKids;
  List<bool> formasPagamento = [false, false, false];

  // Page 28 Data
  bool? temCupom;
  String? codigoCupom;
  String? valorCupom;

  EventoDTO();

  @override
  String toString() {
  return '''
  TELA-1
  Nome: $nome
  Inicio: $dataInicio $horaInicio
  Fim: $dataFim $horaFim
  Privado: $privado
  Tipo: $tipo
  Freq: $frequencia
  Faixa: $faixaEtaria
  Desc: $descricao

  TELA-2
  Local: $localNome
  CEP: $cep
  End: $endereco
  Cap: $capacidade
  Estac=$estacionamento
  Bife=$bife
  Quarto=$quarto

  TELA-3
  Ingresso: Gratuito=$eventoGratuito
  NomeIngresso=$nomeIngresso
  Valor=$valorIngresso
  Taxa=$taxaIngresso
  ArquivosPDF: 
  Regras=$pathRegras,
  Vestimentas=$pathVestimentas, 
  Genero=$pathGenero

  Menor=$menorIdade 
  Estudantes=$estudantes

  TELA-4
  ArquivosIMG: 
  Local=$pathFotoLocal
  Estab=$pathFotoEstabelecimento


  Estaciomento=$temEstacionamento
  Pet=$areaPet
  Kids=$espacoKids
  Pagamento: $formasPagamento
  
  TELA-5
  Promo: Cupom=$temCupom
  Cod=$codigoCupom 
  Val=$valorCupom 
''';
  }
}
