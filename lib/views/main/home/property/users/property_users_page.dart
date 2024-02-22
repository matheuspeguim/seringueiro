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
                                onRolesEdit: () => _editRoles(
                                    context, propertyUser, propertyId),
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

void _editRoles(
    BuildContext context, DocumentSnapshot propertyUser, String propertyId) {
  final Map<String, dynamic> funcoes = propertyUser['funcoes'];
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        // Use StatefulBuilder para atualizar o estado dos checkboxes
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Editar Papéis do Usuário'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  CheckboxListTile(
                    value: funcoes['seringueiro'],
                    title: Text('Seringueiro'),
                    onChanged: (value) {
                      setState(() {
                        funcoes['seringueiro'] = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    value: funcoes['agronomo'],
                    title: Text('Agrônomo'),
                    onChanged: (value) {
                      setState(() {
                        funcoes['agronomo'] = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    value: funcoes['proprietario'],
                    title: Text('Proprietário'),
                    onChanged: (value) {
                      setState(() {
                        funcoes['proprietario'] = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    value: funcoes['admin'],
                    title: Text('Administrador'),
                    onChanged: (value) {
                      setState(() {
                        funcoes['admin'] = value!;
                      });
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      _deletePropertyUser(context, propertyUser, propertyId);
                    },
                    child: Text(
                      "Excluir usuário",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Salvar'),
                onPressed: () {
                  propertyUser.reference.update(
                      {'funcoes': funcoes}); // Atualiza os papéis no Firestore
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  );
}

void _deletePropertyUser(
    BuildContext context, DocumentSnapshot propertyUser, String propertyId) {
  // Primeiro, apresente um diálogo de confirmação
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Excluir Usuário'),
        content: Text(
            'Tem certeza de que deseja excluir este usuário da propriedade?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              // Apenas feche o diálogo de confirmação
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: Text('Excluir',
                style: TextStyle(
                  color: Colors.red,
                )),
            onPressed: () {
              // Verifica se é o último usuário
              FirebaseFirestore.instance
                  .collection('properties')
                  .doc(propertyId)
                  .collection('property_users')
                  .get()
                  .then((QuerySnapshot querySnapshot) {
                if (querySnapshot.docs.length > 1) {
                  // Proceder com a exclusão
                  propertyUser.reference.delete().then((_) {
                    Navigator.of(dialogContext)
                        .pop(); // Fecha o diálogo de confirmação
                    Navigator.of(context)
                        .pop(); // Fecha o diálogo de edição de roles, se estiver aberto
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Usuário excluído com sucesso.'),
                      ),
                    );
                  });
                } else {
                  // Mostrar um aviso de que não se pode excluir o último usuário
                  Navigator.of(dialogContext)
                      .pop(); // Fecha o diálogo de confirmação
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Não é possível excluir o último usuário da propriedade!'),
                    ),
                  );
                }
              });
            },
          ),
        ],
      );
    },
  );
}
