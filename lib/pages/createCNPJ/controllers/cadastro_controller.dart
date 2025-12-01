import 'package:flutter/material.dart';

// Classe responsável por validar os dados do cadastro
class CadastroController {
  // Método principal que recebe os dados e o contexto para exibir mensagens
  void validarCadastro(
    BuildContext context,
    String cnpj,
    String nomeFantasia,
    String email,
    String senha,
    String nomeResponsavel,
    String sobrenomeResponsavel,
    bool termosAceitos,
    String tipoConta,
  ) {
    // Verifica se algum campo obrigatório está vazio
    if (nomeFantasia.isEmpty ||
        email.isEmpty ||
        senha.isEmpty ||
        nomeResponsavel.isEmpty ||
        sobrenomeResponsavel.isEmpty) {
      _showError(context, "Por favor, preencha todos os campos.");
      return; // Interrompe se faltar algum campo
    }

    // Validação da senha
    if (senha.length < 8 ||
        !senha.contains(RegExp(r'[A-Z]')) || // Precisa de letra maiúscula
        !senha.contains(RegExp(r'[0-9]')) || // Precisa de número
        !senha.contains(RegExp(r'[a-z]'))) { // Precisa de letra minúscula
      _showError(
        context,
        "A senha deve ter pelo menos 8 caracteres, incluindo letra maiúscula, minúscula e número.",
      );
      return; // Interrompe se a senha for inválida
    }

    // Verifica se o usuário aceitou os termos
    if (!termosAceitos) {
      _showError(context, "Você deve aceitar os termos e condições.");
      return;
    }

    // Validação simples do CNPJ
    if (cnpj.length != 14 || !RegExp(r'^[0-9]+$').hasMatch(cnpj)) {
      _showError(context, "CNPJ inválido. Deve conter 14 dígitos numéricos.");
      return;
    }

    // Verificação simples de email (não é validação completa)
    if (!email.contains('@') || !email.contains('.')) {
      _showError(context, "Email inválido.");
      return;
    }
    // Verifica se o tipo de conta requer CNPJ
    if(tipoConta.contains("CNPJ") && cnpj.isEmpty){
      _showError(context, "CNPJ é obrigatório para o tipo de conta selecionado.");
      return;
    }

    // Se passou por todas as validações
    print("Cadastrado com sucesso!");
  }

  // Método privado para exibir mensagens de erro
  void _showError(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erro"), // Título do alerta
        content: Text(msg), // Mensagem recebida
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Fecha o diálogo
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
