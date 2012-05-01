Post.create!(:body => "the greatest post evar!", :rating => 10)
Post.create!(:body => nil, :rating => -1)

(5..7).each { |age| User.create(:age => age) }
%w(bjohnson thunt dgainor fisons).each { |username| User.create(:username => username) }
User.create(:username => nil)
User.create(:username => "")
User.create
User.create(:male => false)
User.create(:male => true)
