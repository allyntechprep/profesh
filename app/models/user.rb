# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  aspiring_occupation :string
#  bio                 :string
#  display_name        :string
#  email               :string
#  employer            :string
#  occupation          :string
#  password_digest     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password

  has_many(:ai_messages, { :class_name => "AiMessage", :foreign_key => "user_id", :dependent => :destroy })

  def prompt
    <<~TEXT
      You are a business professional coach.
      The user will provide a statement.
      Please respond with a workplace appropriate version of that statement.
    TEXT
  end
end
