class Questify::ClassGroupSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  # CORREÇÃO: Removido o 'type' da lista de atributos
  attributes :name, :description, :class_identifier, :period, :created_at

  # O 'type' principal, no topo do objeto, é mantido
  attribute :type do |record|
    'class_group'
  end

  has_many :students, serializer: Questify::StudentSerializer

  meta do |record, params|
    params[:meta]
  end
end
