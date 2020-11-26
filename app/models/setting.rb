class Setting < ApplicationRecord
  validates :name, uniqueness: true


  # 得到模型里相应name的布尔值
  def self.setting_status(name)
    if settle = Setting.find_by(name: name)
      settle.status
    else
      false
    end
  end

end
