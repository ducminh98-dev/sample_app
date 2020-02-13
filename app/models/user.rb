class User < ApplicationRecord
  attr_accessor :remember_token
  validates :name, presence: true, length: {maximum: Settings.name_maximum}
  validates :email, presence: true,
    length: {maximum: Settings.email_maximum},
      format: {with: Settings.email_valid},
        uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.minimum_pass}
  before_save{self.email = email.downcase}
  has_secure_password

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated? _rember_token
    return false if remember_digest.nil?

    BCrypt::Password new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
