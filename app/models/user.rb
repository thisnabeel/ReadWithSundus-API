class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :students, foreign_key: 'guardian_id', dependent: :destroy
  validates :roles, inclusion: { in: %w[guardian student admin teacher] }
end
