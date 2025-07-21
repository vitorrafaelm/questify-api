class Questify::AssessmentByStudentSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  has_many :assessment_answers, serializer: Questify::AssessmentAnswerSerializer

  attributes :status, :score, :created_at

  attribute :type do |record|
    'assessment_attempt'
  end

  attribute :assessment do |record|
    assessment = record.assessment_to_class_group.assessment
    {
      id: assessment.id,
      title: assessment.title,
      description: assessment.description
    }
  end

  attribute :class_group do |record|
    class_group = record.assessment_to_class_group.class_group
    {
      id: class_group.id,
      name: class_group.name
    }
  end

end
