import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/usuario.dart';
import 'package:flutter_seringueiro/common/widgets/add_user_to_property_widget.dart';
import 'package:flutter_seringueiro/views/user/account_management/account_management_bloc.dart';
import 'package:flutter_seringueiro/views/user/account_management/account_management_page.dart';
import 'package:flutter_seringueiro/common/widgets/percentage_circle.dart';

class ProfilePage extends StatelessWidget {
  final Usuario usuario;
  final String? propertyId;

  ProfilePage({Key? key, required this.usuario, this.propertyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nome),
        actions: [_buildEditIconButton(context)],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 18),
            _buildProfilePicture(context),
            const SizedBox(height: 20),
            _buildUserName(context),
            const SizedBox(height: 2),
            _buildUserId(context),
            const SizedBox(height: 2),
            AddUserToPropertyWidget(
              usuario: usuario,
              propertyId: propertyId,
            ),
            const Divider(),
            _buildPerformanceIndicators(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEditIconButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (_) => AccountManagementBloc(),
              child: AccountManagementPage()))),
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(usuario.profilePictureUrl),
      ),
    );
  }

  Widget _buildUserName(BuildContext context) {
    return Text(usuario.nome, style: Theme.of(context).textTheme.headlineSmall);
  }

  Widget _buildUserId(BuildContext context) {
    return Text('@${usuario.idPersonalizado}',
        style: Theme.of(context).textTheme.titleMedium);
  }

  Widget _buildPerformanceIndicators(BuildContext context) {
    final themeColor = Theme.of(context);

    return Container(
      height: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: themeColor.colorScheme.surface,
      ),
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(8),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          Text("Desempenho profissional".toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 10),
          Text(
              "São considerados dados das duas últimas safras, ou mais recentes.",
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 10),
          PercentageCircle(
              titulo: "Frequência",
              valor: 56,
              themeColor: themeColor.textTheme.bodyLarge!.color!),
          PercentageCircle(
              titulo: "Técnica",
              valor: 65,
              themeColor: themeColor.textTheme.bodyLarge!.color!),
          PercentageCircle(
              titulo: "Manejo",
              valor: 100,
              themeColor: themeColor.textTheme.bodyLarge!.color!),
          PercentageCircle(
              titulo: "Reposição",
              valor: 87,
              themeColor: themeColor.textTheme.bodyLarge!.color!),
          PercentageCircle(
              titulo: "Consumo",
              valor: 18,
              themeColor: themeColor.textTheme.bodyLarge!.color!),
        ],
      ),
    );
  }
}
