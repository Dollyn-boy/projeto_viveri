import 'package:flutter/material.dart';
import 'package:viveri/app/data/models/user_model.dart';
import 'package:viveri/app/services/user_service.dart';
import 'package:viveri/pages/alterar_senha/alterar_senha_page.dart';
import 'package:viveri/pages/sobre_a_conta/profile_base.dart';

class ProfileLoaderPage extends StatefulWidget {
  final UserModel model;
  const ProfileLoaderPage({super.key, required this.model});

  @override
  State<ProfileLoaderPage> createState() => _ProfileLoaderPageState();
}

class _ProfileLoaderPageState extends State<ProfileLoaderPage> {
  late Future<UserModel> _userFuture;

  @override
  void initState() {
    super.initState();
    // Aqui é pra passar o token real do usuário
    //_userFuture = UserService().fetchUserProfile("TOKEN_DE_TESTE");
    _userFuture = Future.value(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Erro: ${snapshot.error}")));
        } else if (snapshot.hasData) {
          final user = snapshot.data!;

          if (user.isPJ) {
            return _buildPjScreen(user);
          } else {
            return _buildPfScreen(user);
          }
        }
        return const Scaffold(
          body: Center(child: Text("Usuário não encontrado")),
        );
      },
    );
  }

  // Constrói a tela usando os dados de Pessoa Física
  Widget _buildPfScreen(UserModel user) {
    final pfData = user.pessoaFisica;

    return ProfileBaseLayout(
      title: "Sobre a conta",
      children: [
        const SectionTitle("Tipo de documento:"),
        const SizedBox(height: 10),
        // Passa o CPF vindo do backend
        DocumentField(label: "CPF:", value: pfData?.cpf ?? "Não informado"),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: ActionLink(text: "Alterar para CNPJ?", onTap: () {}),
        ),

        const SizedBox(height: 24),
        const ProfileDivider(),
        const SizedBox(height: 24),

        InfoBlock(label: "Nome Completo:", value: user.fullName),
        const SizedBox(height: 16),
        InfoBlock(label: "Nome Social:", value: user.username),
        const SizedBox(height: 16),
        InfoBlock(
          label: "Data de Nascimento:",
          value: pfData?.dataNascimento ?? "-",
        ),

        const SizedBox(height: 24),
        const ProfileDivider(),
        const SizedBox(height: 24),

        InfoBlock(label: "Telefone de Contato", value: user.telefone),
        const SizedBox(height: 16),
        InfoBlock(label: "Email:", value: user.email),

        const SizedBox(height: 24),
        const ProfileDivider(),
        const SizedBox(height: 24),

        ActionLink(
          text: "Alterar senha",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AlterarSenhaPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        ActionLink(text: "Desativar Conta", onTap: () {}),
        const SizedBox(height: 16),
        ActionLink(text: "Excluir Conta", onTap: () {}),
      ],
    );
  }

  // Constrói a tela usando os dados de Pessoa Jurídica
  Widget _buildPjScreen(UserModel user) {
    final pjData = user.pessoaJuridica;

    return ProfileBaseLayout(
      title: "Conta Empresarial",
      children: [
        const SectionTitle("Tipo de documento:"),
        const SizedBox(height: 10),
        // Passa o CNPJ vindo do backend
        DocumentField(label: "CNPJ:", value: pjData?.cnpj ?? "Não informado"),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: ActionLink(
            text: "Enviar Documento",
            onTap: () {}, // TODO: Adicionar Enviar Documento
          ),
        ),

        const SizedBox(height: 24),
        const ProfileDivider(),
        const SizedBox(height: 24),

        InfoBlock(label: "Razão Social:", value: pjData?.razaoSocial ?? "-"),
        const SizedBox(height: 16),
        InfoBlock(label: "Nome Fantasia:", value: pjData?.nomeFantasia ?? "-"),
        const SizedBox(height: 16),
        InfoBlock(label: "Endereço:", value: pjData?.enderecoComercial ?? "-"),
        const SizedBox(height: 16),
        InfoBlock(
          label: "Data de Credenciamento:",
          value: pjData?.dataCredenciamento ?? "-",
        ),

        const SizedBox(height: 24),
        const ProfileDivider(),
        const SizedBox(height: 24),

        InfoBlock(
          label: "Telefone Comercial:",
          value: pjData?.telefoneComercial ?? "-",
        ),
        const SizedBox(height: 16),
        InfoBlock(
          label: "Email Corporativo:",
          value: pjData?.emailCorporativo ?? "-",
        ),
        const SizedBox(height: 16),
        InfoBlock(
          label: "Nome do Responsável",
          value: pjData?.nomeResponsavel ?? "-",
        ),

        const SizedBox(height: 24),
        const ProfileDivider(),
        const SizedBox(height: 24),

        ActionLink(
          text: "Alterar senha",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AlterarSenhaPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        ActionLink(text: "Desativar Conta", onTap: () {}),
        const SizedBox(height: 16),
        ActionLink(text: "Excluir Conta", onTap: () {}),
      ],
    );
  }
}
