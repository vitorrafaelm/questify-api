class Questify::QuestionSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :id, :title, :content, :is_public, :question_type, :created_at

  attribute :type do |record|
    'question'
  end

  attribute :themes do |record|
    Questify::ThemeSerializer.new(record.themes).sanitized_hash
  end

  attribute :question_alternatives do |record|
    Questify::QuestionAlternativeSerializer.new(record.question_alternatives).sanitized_hash
  end
end
