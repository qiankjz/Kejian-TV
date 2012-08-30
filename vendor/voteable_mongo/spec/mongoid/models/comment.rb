require File.join(File.dirname(__FILE__), 'post')

class Comment
  include Mongoid::Document
  include Mongo::Voteable

  field :content

  belongs_to :post
  
  voteable self, :up => +1, :down => -3
  voteable Post, :up => +2, :down => -1
end
