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
      'html' => 'Gift Card<br>$10',
      'class' => 'two',
      'image' =>  ActionController::Base.helpers.asset_path(
        'refer/cream-tooltip.png')
    },
    {
      'count' => 10,
      'html' => 'Gift Card<br>$20',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/truman.png')
    },
    {
      'count' => 25,
      'html' => 'Gift Card<br>$50',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/winston.png')
    },
    {
      'count' => 50,
      'html' => 'Gift Card<br>$100',
      'class' => 'five',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/blade-explain@2x.png')
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
