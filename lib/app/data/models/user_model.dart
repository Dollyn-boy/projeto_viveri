class PessoaFisicaModel {
  final String cpf;
  final String dataNascimento;

  PessoaFisicaModel({required this.cpf, required this.dataNascimento});

  factory PessoaFisicaModel.fromJson(Map<String, dynamic> json) {
    return PessoaFisicaModel(
      cpf: json['cpf'] ?? "",
      dataNascimento: json['data_nascimento'] ?? "",
    );
  }
}

class PessoaJuridicaModel {
  final String cnpj;
  final String razaoSocial;
  final String nomeFantasia;
  final String enderecoComercial;
  final String dataCredenciamento;
  final String telefoneComercial;
  final String emailCorporativo;
  final String nomeResponsavel;
  final bool documentacaoVerificada;

  PessoaJuridicaModel({
    required this.cnpj,
    required this.razaoSocial,
    required this.nomeFantasia,
    required this.enderecoComercial,
    required this.dataCredenciamento,
    required this.nomeResponsavel,
    required this.telefoneComercial,
    required this.emailCorporativo,
    required this.documentacaoVerificada,
  });

  factory PessoaJuridicaModel.fromJson(Map<String, dynamic> json) {
    return PessoaJuridicaModel(
      cnpj: json['cnpj'] ?? '',
      razaoSocial: json['razao_social'] ?? '',
      nomeFantasia: json['nome_fantasia'] ?? '',
      enderecoComercial: json['endereco_comercial'] ?? '',
      dataCredenciamento: json['data_credenciamento'] ?? "Não informada",
      nomeResponsavel: json['nome_responsavel'] ?? '',
      telefoneComercial: json['telefone_comercial'] ?? '',
      emailCorporativo: json['email_corporativo'] ?? '',
      documentacaoVerificada: json['documentacao_verificada'] ?? false,
    );
  }
}

class UserModel {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String telefone;
  final String? fotoUrl;
  final bool isPF;
  final bool isPJ;

  final PessoaFisicaModel? pessoaFisica;
  final PessoaJuridicaModel? pessoaJuridica;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.telefone,
    required this.isPF,
    required this.isPJ,
    this.fotoUrl,
    this.pessoaFisica,
    this.pessoaJuridica,
  });

  String get fullName => "$firstName $lastName".trim();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      telefone: json['telefone'] ?? "(**) *****-****",
      fotoUrl: json['foto'],
      isPF: json['flag_userPF'] ?? false,
      isPJ: json['flag_userPJ'] ?? false,
      pessoaFisica: json['pessoa_fisica'] != null
          ? PessoaFisicaModel.fromJson(json['pessoa_fisica'])
          : null,
      pessoaJuridica: json['pessoa_juridica'] != null
          ? PessoaJuridicaModel.fromJson(json['pessoa_juridica'])
          : null,
    );
  }
}