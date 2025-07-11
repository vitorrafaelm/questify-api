module ExceptionHandler
  # Erro para quando as credenciais são inválidas
  class InvalidCredentialsError < StandardError; end

  # Erro para quando o utilizador não está ativo
  class UserNotActiveError < StandardError; end

end