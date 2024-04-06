import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_seringueiro/common/models/property_user.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_user/property_user_page/property_user_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_user/property_user_page/property_user_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_user/property_user_page/property_user_page.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_user/property_users_widgets/property_users_badge.dart';

class PropertyUsersIconRow extends StatelessWidget {
  final String propertyId;

  const PropertyUsersIconRow({
    Key? key,
    required this.propertyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Membros da Propriedade",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        FutureBuilder<List<PropertyUser>>(
          future: _fetchPropertyUsers(propertyId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Nenhum usuário encontrado.",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return Container(
              height:
                  120, // Ajuste a altura conforme necessário para acomodar os badges
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final propertyUser = snapshot.data![index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<PropertyUserBloc>(
                                create: (context) => PropertyUserBloc()
                                  ..add(
                                      LoadPropertyUserDetails(propertyUser.id)),
                                child: PropertyUserPage(
                                    propertyUserId: propertyUser.id),
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 33,
                          backgroundImage: NetworkImage(
                              propertyUser.usuario.profilePictureUrl),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        propertyUser.usuario.nome.split(" ").first,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 2),
                      PropertyUserBadge(
                        isSeringueiro: propertyUser.seringueiro,
                        isAgronomo: propertyUser.agronomo,
                        isProprietario: propertyUser.proprietario,
                        isAdministrador: propertyUser.administrador,
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Future<List<PropertyUser>> _fetchPropertyUsers(String propertyId) async {
    final propertyUserSnapshot = await FirebaseFirestore.instance
        .collection('property_users')
        .where('propertyId', isEqualTo: propertyId)
        .get();

    List<PropertyUser> propertyUsers = [];
    for (var doc in propertyUserSnapshot.docs) {
      PropertyUser propertyUser = await PropertyUser.fromFirestore(doc);
      propertyUsers.add(propertyUser);
    }
    return propertyUsers;
  }
}
