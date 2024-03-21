// Classe base para todos os estados do BLoC de configurações da propriedade.
import 'package:flutter_seringueiro/common/models/property_user.dart';

abstract class PropertySettingsState {}

// Estado inicial do BLoC, antes de qualquer ação ser tomada.
class PropertySettingsInitial extends PropertySettingsState {}

// Estado que representa o carregamento de dados.
// Usado quando as informações estão sendo carregadas do Firestore ou outra fonte de dados.
class PropertySettingsLoading extends PropertySettingsState {}

// Estado para usuários com permissões de administrador.
// Contém uma lista de usuários associados à propriedade e o ID da propriedade,
// permitindo que o administrador gerencie esses usuários.
class PropertySettingsAdmin extends PropertySettingsState {
  final List<PropertyUser> users;
  final String propertyId;

  PropertySettingsAdmin(this.users, this.propertyId);
}

// Estado para usuários sem permissões de administrador.
// Contém apenas o ID da propriedade, permitindo ações limitadas ao usuário,
// como sair da propriedade.
class PropertySettingsUser extends PropertySettingsState {
  final String propertyId;

  PropertySettingsUser(this.propertyId);
}

// Estado que representa um erro.
// Contém uma mensagem de erro que pode ser exibida ao usuário,
// indicando problemas como falha no carregamento ou permissões insuficientes.
class PropertySettingsError extends PropertySettingsState {
  final String message;

  PropertySettingsError(this.message);
}

// Estado após a atualização bem-sucedida das permissões de um usuário.
// Pode ser usado para indicar que a ação foi completada e, possivelmente,
// para disparar uma atualização na UI.
class PropertySettingsUserPermissionsUpdated extends PropertySettingsState {}

// Estado após um usuário sair com sucesso de uma propriedade.
// Pode ser usado para redirecionar o usuário para uma tela anterior
// ou atualizar a lista de propriedades disponíveis.
class PropertySettingsLeftProperty extends PropertySettingsState {}

// Estado após uma propriedade ser deletada com sucesso.
// Assim como o estado anterior, pode ser usado para atualizar a UI
// e redirecionar o usuário conforme necessário.
class PropertySettingsDeletedProperty extends PropertySettingsState {}
