class Post < ActiveRecord::Base
  scope :foo, where(:body => nil)
end

class Audit < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
end

class Company < ActiveRecord::Base
  has_many :orders, :through => :users
  has_many :users, :dependent => :destroy
end

class UserGroup < ActiveRecord::Base
  has_and_belongs_to_many :users
end

class User < ActiveRecord::Base
  belongs_to :company, :counter_cache => true
  has_many :orders, :dependent => :destroy
  has_many :orders_big, :class_name => 'Order', :conditions => 'total > 100'
  has_and_belongs_to_many :user_groups

  self.skip_time_zone_conversion_for_attributes = [:whatever_at]
end

class Order < ActiveRecord::Base
  belongs_to :user
  has_many :line_items, :dependent => :destroy
end

class Fee < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
end

class LineItem < ActiveRecord::Base
  belongs_to :order
end
