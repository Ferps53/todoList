class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': "E-mail já cadastrado",
    "OPERATION_NOT_ALLOWED": 'Operação não permitida!',
    "TOO_MANY_REQUESTS_TRY_LATER":
        "Acesso bloqueado temporariamente. Tente mais tarde",
    "INVALID_EMAIL": "E-mail não encontrado",
    "INVALID_LOGIN_CREDENTIALS": "Senha incorreta",
    "USER_DISABLED": "A conta do usuário foi desabilitada!",
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? "Ocorreu um erro no processo de Autenticação";
  }
}
