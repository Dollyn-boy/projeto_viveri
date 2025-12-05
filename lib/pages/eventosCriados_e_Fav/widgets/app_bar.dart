import 'package:flutter/material.dart';

class AppBarEvento extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  // NOVO: Adicione o TabController como parâmetro obrigatório
  final TabController tabController; 
  
  // Ajuste o construtor para incluir o TabController
  const AppBarEvento({super.key, this.onBack, required this.tabController});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    const Color corFundoAppBar = Color(0xFF5E6F64);
    const Color corFundoBotao = Color(0xFF284017);
    const Color corDestaque = Color(0xFFF4B134); // Amarelo

    return AppBar(
      backgroundColor: corFundoAppBar,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,

      // 1. Botão de Voltar Personalizado
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: GestureDetector(
          onTap: onBack ?? () {
            // Verifica se pode voltar antes de tentar
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: CircleAvatar(
            backgroundColor: corFundoBotao,
            radius: 15,
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 13,
              color: corDestaque,
            ),
          ),
        ),
      ),

      // 2. Título
      title: const Text(
        "Eventos",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black, 
        ),
      ),

      // As Abas (Favoritados | Criados)
        bottom: TabBar(
        // ATUALIZAÇÃO: Passe o controller que foi recebido
        controller: tabController, 
        indicatorColor: corDestaque, 
        indicatorWeight: 3,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black54, 
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w500
        ),
        tabs: const [
          Tab(text: "Favoritados"),
          Tab(text: "Criados"),
        ],
      ),
    );
  }
}