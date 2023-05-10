# == Schema Information
#
# Table name: ai_messages
#
#  id         :integer          not null, primary key
#  content    :string
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
class AiMessage < ApplicationRecord
  belongs_to(:user, { :required => true, :class_name => "User", :foreign_key => "user_id" })

  enum role: {
    :user => "user",
    :system => "system",
    :assistant => "assistant",
  }

  
end
