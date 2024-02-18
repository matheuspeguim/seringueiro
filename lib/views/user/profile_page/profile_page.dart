import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/models/usuario.dart';
import 'package:flutter_seringueiro/views/user/account_management/account_management_bloc.dart';
import 'package:flutter_seringueiro/views/user/account_management/account_management_page.dart';
import 'package:flutter_seringueiro/widgets/cup_fill.dart';
import 'package:flutter_seringueiro/widgets/custom_card.dart';
import 'package:flutter_seringueiro/widgets/porcentage_circle.dart';

class ProfilePage extends StatelessWidget {
  final Usuario usuario;

  ProfilePage({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green.shade900,
        title: Text(
          usuario.nome,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true, // Centraliza o título
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return BlocProvider(
                  create: (context) => AccountManagementBloc(),
                  child: AccountManagementPage(),
                );
              }));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 18,
            ),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  usuario.profilePictureUrl ??
                      'https://firebasestorage.googleapis.com/v0/b/seringueiroapp.appspot.com/o/profilePictures%2Fvecteezy_illustration-of-human-icon-vector-user-symbol-icon-modern_8442086.jpg?alt=media&token=cdadba3c-68db-4d1b-ace3-b18d7b4733a2',
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              usuario.nome,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              '@${usuario.idPersonalizado}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Divider(),
            Text(
              "Desempenho profissional".toUpperCase(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "São considerados dados das duas últimas safras, ou mais recentes.",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: <Widget>[
                PercentageCircle(
                  titulo: "Rotina",
                  valor: 56,
                ),
                PercentageCircle(
                  titulo: "Técnica",
                  valor: 65,
                ),
                PercentageCircle(
                  titulo: "Manejo",
                  valor: 100,
                ),
                PercentageCircle(
                  titulo: "Reposição",
                  valor: 87,
                ),
                PercentageCircle(
                  titulo: "Consumo",
                  valor: 18,
                )
              ],
            ),
            Divider(),
            // Adicione mais widgets conforme necessário
          ],
        ),
      ),
    );
  }
}
