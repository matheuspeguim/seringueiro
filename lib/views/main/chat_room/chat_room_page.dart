import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRoomPage extends StatefulWidget {
  final User user;

  ChatRoomPage({Key? key, required this.user}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  // Variáveis de estado e lógica do chat podem ser adicionadas aqui

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sala de Conversas'),
        backgroundColor: Colors.green.shade900,
      ),
      body: Column(
        children: <Widget>[
          // Aqui você pode colocar a lista de conversas ou mensagens
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Substitua por sua lógica de dados
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                      // Adicione a lógica para exibir a foto do perfil
                      ),
                  title: Text('Usuário $index'),
                  subtitle: Text('Última mensagem...'),
                  onTap: () {
                    // Aqui você pode adicionar a lógica para abrir uma conversa específica
                  },
                );
              },
            ),
          ),
          // Adicione um widget para enviar novas mensagens
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: 'Digite sua mensagem...',
                    ),
                    // Adicione o controlador e a lógica para enviar mensagens
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Adicione a lógica para enviar a mensagem
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
