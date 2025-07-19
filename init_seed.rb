po = PermissionObject.create!(
  name: 'Criar temas de questões',
  identifier: 'create-questions-themes',
  object_type: 'tests-and-questions'
)

ua = UserAuthorization.find_by(email: "vitor.rafaeldeveloper@gmail.com")

up = UserPermission.create!(
  is_active: true,
  user_authorization_id: ua.id,
  permission_object_id: po.id
)

po = PermissionObject.create!(
  name: 'Criar questões',
  identifier: 'create-questions',
  object_type: 'tests-and-questions'
)
