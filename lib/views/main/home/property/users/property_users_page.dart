import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/widgets/custom_button.dart';
import 'package:flutter_seringueiro/widgets/user_card.dart';

class PropertyUsersPage extends StatelessWidget {
  final String propertyId;

  PropertyUsersPage({required this.propertyId});

  @override
  Widget build(BuildContext context) {
    // Stream que escuta as mudanças na coleção 'property_users' relativas a esta propriedade
    Stream<QuerySnapshot> propertyUsersStream = FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId) // 'propertyId' é o ID do documento da propriedade
        .collection('property_users')
        .snapshots();

    Stream<DocumentSnapshot> propertyDataStream = FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.green.shade900,
          title: Text(
            'Gerenciar Propriedade',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: propertyDataStream,
            builder:
                (context, AsyncSnapshot<DocumentSnapshot> propertySnapshot) {
              if (propertySnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (propertySnapshot.hasError) {
                return Center(
                    child: Text('Ocorreu um erro ao carregar a propriedade'));
              }

              if (!propertySnapshot.hasData) {
                return Center(
                    child: Text('Dados da propriedade não encontrados'));
              }

              // Aqui você constrói o cartão com os dados da propriedade
              var propertyData =
                  propertySnapshot.data!.data() as Map<String, dynamic>;
              var propertyCard = Card(
                elevation: 4.0,
                color: Colors.green,
                margin: EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        title:
                            Text("Nome: ${propertyData['nomeDaPropriedade']}"),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              );

              return StreamBuilder<QuerySnapshot>(
                stream: propertyUsersStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Ocorreu um erro'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Nenhum usuário encontrado'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var propertyUser = snapshot.data!.docs[index];
                      var userId = propertyUser['uid'];

                      // Stream para buscar os dados do usuário com base no UID
                      Stream<DocumentSnapshot> userStream = FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(userId)
                          .snapshots();

                      return StreamBuilder<DocumentSnapshot>(
                        stream: userStream,
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Card(
                                child: ListTile(title: Text('Carregando...')));
                          }

                          if (userSnapshot.hasError) {
                            return Card(
                                child: ListTile(
                                    title: Text('Erro ao carregar usuário')));
                          }

                          if (!userSnapshot.hasData) {
                            return Text('Usuários não encontrados');
                          }

                          var user = userSnapshot.data!;
                          return SingleChildScrollView(
                              child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 16,
                              ),
                              propertyCard,
                              Divider(),
                              UserCard(
                                userData: user,
                                propertyUserData: propertyUser,
                                onRolesEdit: () =>
                                    _editRoles(context, propertyUser),
                                onDelete: () =>
                                    _deletePropertyUser(context, propertyUser),
                              ),
                              CustomButton(
                                onPressed: () {},
                                label: "Adicionar usuário",
                                backgroundColor: Colors.green,
                                icon: Icons.add,
                              )
                            ],
                          ));
                        },
                      );
                    },
                  );
                },
              );
            }));
  }
}

void _editRoles(BuildContext context, DocumentSnapshot propertyUser) {
  // Implementar a lógica para editar os papéis do usuário
}

void _deletePropertyUser(BuildContext context, DocumentSnapshot propertyUser) {
  // Implementar a lógica para excluir o usuário da propriedade
}
