ActiveRecord::Schema.define do
  self.verbose = false

  create_table :posts, :force => true do |t|
    t.string :body
    t.integer :rating, :default => 0
    t.timestamps
  end

  create_table :audits do |t|
    t.string :auditable_type
    t.integer :auditable_id
  end
  
  create_table :companies do |t|
    t.datetime :created_at
    t.datetime :updated_at
    t.string :name
    t.string :description
    t.integer :users_count, :default => 0
  end
  
  create_table :user_groups do |t|
    t.string :name
  end
  
  create_table :user_groups_users, :id => false do |t|
    t.integer :user_group_id, :null => false
    t.integer :user_id, :null => false
  end
  
  create_table :users do |t|
    t.datetime :created_at
    t.datetime :updated_at
    t.integer :company_id
    t.string :username
    t.string :name
    t.integer :age
    t.boolean :male
    t.string :some_type_id
    t.datetime :whatever_at
  end
  
  create_table :carts do |t|
    t.datetime :created_at
    t.datetime :updated_at
    t.integer :user_id
  end
  
  create_table :orders do |t|
    t.datetime :created_at
    t.datetime :updated_at
    t.integer :user_id
    t.date :shipped_on
    t.float :taxes
    t.float :total
  end
  
  create_table :fees do |t|
    t.datetime :created_at
    t.datetime :updated_at
    t.string :owner_type
    t.integer :owner_id
    t.float :cost
  end
  
  create_table :line_items do |t|
    t.datetime :created_at
    t.datetime :updated_at
    t.integer :order_id
    t.float :price
  end
end
