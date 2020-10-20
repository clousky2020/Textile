module UserHelper

  def role_to_chinese(en)
    roles = ['admin' => "管理员", 'leader' => "领导", 'editor' => "编辑员", 'employee' => "员工"]
    out = roles[0][en]
  end
end
