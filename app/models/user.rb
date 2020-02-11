class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: Settings.name_maximum}
  validates :email, presence: true,
    length: {maximum: Settings.email_maximum},
      format: {with: Settings.email_valid},
        uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.minimum_pass}
  before_save{self.email = email.downcase}
  has_secure_password
end
