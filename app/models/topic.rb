# == Schema Information
#
# Table name: topics
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Topic < ActiveRecord::Base
    attr_accessible :title
 
    has_many :posts, :dependent => :destroy
    has_many :users, :through => :posts
    
    validates :title, :presence => true,
                      :uniqueness => true
end
