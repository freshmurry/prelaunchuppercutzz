require 'users_helper'

class User < ActiveRecord::Base
  belongs_to :referrer, class_name: 'User', foreign_key: 'referrer_id'
  has_many :referrals, class_name: 'User', foreign_key: 'referrer_id'

  validates :email, presence: true, uniqueness: true, format: {
    with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
    message: 'Invalid email format.'
  }
  validates :referral_code, uniqueness: true

  before_create :create_referral_code
  after_create :send_welcome_email

  REFERRAL_STEPS = [
    {
      'count' => 5,
      'html' => 'Eyebrows',
      'class' => 'two',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/eebrows.png')
    },
    {
      'count' => 10,
      'html' => 'Makeup',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/makeup.png')
    },
    {
      'count' => 25,
      'html' => 'Lashes',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/lashes.png')
    },
    {
      'count' => 50,
      'html' => '<b>Pamper Me</b><br>(1) Free Eyebrows, Makeup, Lashes, and Hairstyle service',
      'class' => 'five',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/pamperme.jpg')
    }
  ]
  
  private

  def create_referral_code
    self.referral_code = UsersHelper.unused_referral_code
  end

  def send_welcome_email
    UserMailer.delay.signup_email(self)
  end
end