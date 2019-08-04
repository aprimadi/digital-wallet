# == Schema Information
#
# Table name: entities
#
#  id         :bigint           not null, primary key
#  type       :string           not null
#  name       :string           not null
#  status     :string           default("active"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Entity < ApplicationRecord
  has_one :wallet
end
