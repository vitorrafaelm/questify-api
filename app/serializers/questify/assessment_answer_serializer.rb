class Questify::AssessmentAnswerSerializer
  include JSONAPI::Serializer

  attributes :answer_text, :is_correct, :question_id, :question_alternative_id

  attribute :type do |record|
    'assessment_answer'
  end
end