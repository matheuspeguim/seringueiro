abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String senha;

  SignUpSubmitted({
    required this.email,
    required this.senha,
  });
}

class EmailVerificationSubmitted extends SignUpEvent {
  final String email;
  EmailVerificationSubmitted({required this.email});
}

class PersonalInfoSubmitted extends SignUpEvent {
  final String nome;
  final String idPersonalizado;
  final String dataDeNascimento;
  final String cpf;
  final String rg;

  PersonalInfoSubmitted({
    required this.nome,
    required this.idPersonalizado,
    required this.dataDeNascimento,
    required this.cpf,
    required this.rg,
  });
}

class CelularSubmitted extends SignUpEvent {
  final String celular;
  CelularSubmitted({required this.celular});
}

class ConfirmCelularSubmitted extends SignUpEvent {
  final String codigoConfirmarCelular;

  ConfirmCelularSubmitted({
    required this.codigoConfirmarCelular,
  });
}

class CepInfoSubmitted extends SignUpEvent {
  final String cep;

  CepInfoSubmitted({required this.cep});
}

class EnderecoInfoSubmitted extends SignUpEvent {
  final String cep;
  final String ruaOuSitio;
  final String complemento;
  final String bairro;
  final String numero;
  final String cidade;
  final String estado;

  EnderecoInfoSubmitted({
    required this.cep,
    required this.ruaOuSitio,
    required this.complemento,
    required this.bairro,
    required this.numero,
    required this.cidade,
    required this.estado,
  });
}
