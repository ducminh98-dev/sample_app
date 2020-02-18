class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  validates :name, presence: true, length: {maximum: Settings.name_maximum}
  validates :email, presence: true,
    length: {maximum: Settings.email_maximum},
      format: {with: Settings.email_valid},
        uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.minimum_pass}

  validates :password, presence: true, length: {minimum: Settings.minimum_pass}, allow_nil: true


  before_save :downcase_email
  before_create :create_activation_digest


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

  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def downcase_email
   email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_columns(activated: true , activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

end
