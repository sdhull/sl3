require "spec_helper"

describe Sl3::Ordering do
  it "should be dynamically created and then cached" do
    User.should_not respond_to(:ascend_by_username)
    User.ascend_by_username
    User.should respond_to(:ascend_by_username)
  end

  it "should have ascending" do
    User.ascend_by_username.all.should == User.order("username ASC")
  end

  it "should have descending" do
    User.descend_by_username.all.should == User.order("username DESC")
  end

  it "should have priorty to columns over conflicting association columns" do
    Company.ascend_by_users_count
  end
end
