// Classe base para todos os eventos de configurações da propriedade.
abstract class PropertySettingsEvent {}

// Evento para carregar as configurações de uma propriedade específica.
// Necessita do ID da propriedade para buscar as configurações relevantes.
class LoadPropertySettings extends PropertySettingsEvent {
  final String propertyId;

  LoadPropertySettings(this.propertyId);
}

// Evento para gerenciar os usuários de uma propriedade específica.
// Este evento pode ser usado para iniciar a lógica que busca os usuários
// da propriedade para que possam ser gerenciados pelo administrador.
class ManageUsers extends PropertySettingsEvent {
  final String propertyId;

  ManageUsers(this.propertyId);
}

// Evento para atualizar as permissões de um usuário específico dentro da propriedade.
// Requer o ID da propriedade, o ID do usuário cujas permissões serão atualizadas,
// e um mapa das permissões e seus valores (true/false).
class UpdateUserPermissions extends PropertySettingsEvent {
  final String propertyId;
  final String userId;
  final Map<String, bool> permissions;

  UpdateUserPermissions(this.propertyId, this.userId, this.permissions);
}

// Evento emitido quando um usuário decide deixar uma propriedade.
// Requer o ID da propriedade da qual o usuário está saindo e o ID do usuário.
class LeaveProperty extends PropertySettingsEvent {
  final String propertyId;
  final String userId;

  LeaveProperty(this.propertyId, this.userId);
}

// Evento para deletar uma propriedade inteira.
// Isso provavelmente exigirá permissões administrativas e afetará todos os usuários
// associados à propriedade. Requer apenas o ID da propriedade a ser deletada.
class DeleteProperty extends PropertySettingsEvent {
  final String propertyId;

  DeleteProperty(this.propertyId);
}
