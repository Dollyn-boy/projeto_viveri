import 'package:flutter/material.dart';

class AppBarEvento extends StatelessWidget implements PreferredSizeWidget {
  final double? progresso; 
  final VoidCallback? onBack;

  const AppBarEvento({
    super.key,
    this.progresso,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56 + 8);

  @override
  Widget build(BuildContext context) {
    const Color corFundoAppBar = Color(0xFF5E6F64);
    const Color corFundoBotao = Color(0xFF284017);
    const Color corDestaque = Color(0xFFF4B134);
    const Color corFundoProgresso = Color(0xFFE2E8DA);

    return AppBar(
      backgroundColor: corFundoAppBar,
      elevation: 0,
      automaticallyImplyLeading: false,

      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: GestureDetector(
          onTap: onBack ?? () => Navigator.of(context).pop(),
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
      
      centerTitle: true,
      title: const Text(
        "Criar evento",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: corDestaque,
        ),
      ),

     bottom: PreferredSize(
        preferredSize: const Size.fromHeight(8),
        child: SizedBox( 
          height: 8,
          child: LinearProgressIndicator(
            value: progresso ?? 0.0,
            backgroundColor: corFundoProgresso,
            valueColor: const AlwaysStoppedAnimation(corDestaque),
          ),
        ),
      ),
    );
  }
}
