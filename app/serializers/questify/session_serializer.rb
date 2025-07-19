class Questify::SessionSerializer
  include FastJsonapi::ObjectSerializer
  include SerializerHelper

  attribute :authorizable do |record|
    authorizable = record.user_authorizable
    serializer = authorizable_serializer(authorizable)

    serializer.sanitized_hash
  end

  attribute :permissions do |record|
    grouped_permission_objects = record.permission_objects.group_by { |obj| obj.object_type }

    Hash.new.tap do |hsh|
      grouped_permission_objects.each do |object_type, objects|
        hsh.store(object_type,
          objects.map { |obj|
            {
              identifier: obj.identifier,
              name: obj.name
            }.compact
          }
        )
      end
    end
  end

  attribute :user do |record|
    Questify::UserAuthorizationSerializer.new(record).sanitized_hash
  end

  # Aux Methods ================================================================
  class << self
    def authorizable_serializer(authorizable)
      authorizable_classname = authorizable.class.name.underscore
      serializer_name = "questify/#{authorizable_classname}_serializer"
      serializer_klass = serializer_name.classify.safe_constantize

      raise AuthorizableSerializerNotFound.new(authorizable_classname) if serializer_klass.blank?
      return serializer_klass.new(authorizable, { params: { additional_data: true, add_associations: false }})
    end
  end
end
