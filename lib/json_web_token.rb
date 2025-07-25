class JsonWebToken
  # Padronizando para a forma mais comum de aceder à chave em desenvolvimento
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  # Codifica um payload para gerar o token
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Decodifica um token para obter o payload
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  end
end