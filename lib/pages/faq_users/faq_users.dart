import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viveri/app/data/models/faq_model.dart';

class FaqPageUsers extends StatefulWidget {
  const FaqPageUsers({super.key});

  @override
  State<FaqPageUsers> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPageUsers> {
  // Cores do Tema Viveri
  final Color bgLight = const Color(0xFFDCE6DD);
  final Color bgDark = const Color(0xFF6A7B6E);
  final Color textDark = const Color(0xFF2C332E);
  final Color badgeColor = const Color(0xFFB85C5C);

  final TextEditingController _textController = TextEditingController();
  List<FaqModel> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // Carregar mensagens salvas no celular
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? messagesJson = prefs.getString('faq_user_messages');

    if (messagesJson != null) {
      final List<dynamic> decodedList = jsonDecode(messagesJson);
      setState(() {
        _messages = decodedList.map((item) => FaqModel.fromJson(item)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _messages = [];
        _isLoading = false;
      });
    }
  }

  // Salvar mensagens no celular
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _messages.map((m) => m.toJson()).toList(),
    );
    await prefs.setString('faq_user_messages', encodedData);
  }

  // Enviar nova mensagem
  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    final newMessage = FaqModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _textController.text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, newMessage);
    });

    _textController.clear();
    _saveMessages();
  }

  // Curtir/Descurtir mensagem
  void _toggleLike(int index) {
    setState(() {
      _messages[index].isLiked = !_messages[index].isLiked;
    });
    _saveMessages();
  }

  // Deletar mensagem
  void _deleteMessage(int index) {
    setState(() {
      _messages.removeAt(index);
    });
    _saveMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        title: const Text(
          "Minhas Dúvidas & Anotações",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: bgDark,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // LISTA DE MENSAGENS
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: bgDark))
                : _messages.isEmpty
                ? Center(
                    child: Text(
                      "Nenhuma anotação encontrada.\nEscreva abaixo para salvar.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textDark.withOpacity(0.5)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageCard(message, index);
                    },
                  ),
          ),

          // CAMPO DE TEXTO (INPUT)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Escreva sua dúvida ou anotação...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: bgLight.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: bgDark,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(FaqModel message, int index) {
    return Dismissible(
      key: Key(message.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _deleteMessage(index);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Item removido"),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(fontSize: 16, color: textDark, height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(message.timestamp),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                GestureDetector(
                  onTap: () => _toggleLike(index),
                  child: Icon(
                    message.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: message.isLiked ? badgeColor : Colors.grey[400],
                    size: 22,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
