class Param < ApplicationRecord

  validates :name, uniqueness: true



  # 得到模型里相应name的布尔值
  def self.param_status(name)
    if settle = Param.find_by(name: name)
      settle.status
    else
      false
    end
  end

end
