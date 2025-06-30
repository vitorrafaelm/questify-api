# frozen_string_literal: true
module SerializerHelper
  extend ActiveSupport::Concern

  # Método de instância
  def sanitized_hash
    data = to_hash[:data]
    return {} if data.blank?

    if data.is_a?(Array)
      data.map! { |hsh| hsh[:attributes] }
    else
      data = data[:attributes]
    end

    return data
  end
end
