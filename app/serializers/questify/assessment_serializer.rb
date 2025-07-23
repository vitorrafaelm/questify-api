class Questify::AssessmentSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :id, :title, :description, :created_at

  attribute :type do |record|
    'assessment'
  end

  attribute :questions do |record|
    Questify::QuestionSerializer.new(record.reload.questions).sanitized_hash
  end

  attribute :students do |record|
    Questify::StudentSerializer.new(record.reload.students).sanitized_hash
  end
end
