# == Schema Information
#
# Table name: posts
#
#  id         :integer(4)      not null, primary key
#  content    :text
#  user_id    :integer(4)
#  topic_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Post < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user
  belongs_to :topic
  
  validates :content, :presence => true
  validates :user_id, :presence => true
  
end
