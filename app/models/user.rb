class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookmarks, dependent: :destroy
  has_many :contents, through: :bookmarks

  # Custom email format validation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # Ensure custom validation doesn't conflict with Devise's validatable
  validate :custom_email_validator

  private

  def custom_email_validator
    errors.add(:email, :invalid, message: "is not a valid email") unless email =~ VALID_EMAIL_REGEX
  end
end
