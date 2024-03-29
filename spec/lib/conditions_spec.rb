require "spec_helper"

describe Sl3::Conditions do
  it "should be dynamically created and then cached" do
    User.age_less_than(5)
    User.should_receive(:method_missing).never
    User.age_less_than(5)
  end

  it "should not allow conditions on non columns" do
    lambda { User.whatever_equals(2) }.should raise_error(NoMethodError)
  end

  context "comparison conditions" do
    it "should have equals" do
      User.age_equals(6).all.should == User.find_all_by_age(6)
      User.age_equals(5..6).all.should == User.find_all_by_age(5..6)
      User.age_equals([5, 7]).all.should == User.find_all_by_age([5, 7])
    end

    it "should have does not equal" do
      User.age_does_not_equal(6).all.should == User.find_all_by_age([5,7])
    end

    it "should have less than" do
      User.age_less_than(6).all.should == User.find_all_by_age(5)
    end

    it "should have less than or equal to" do
      User.age_less_than_or_equal_to(6).all.should == User.find_all_by_age([5, 6])
    end

    it "should have greater than" do
      User.age_greater_than(6).all.should == User.find_all_by_age(7)
    end

    it "should have greater than or equal to" do
      User.age_greater_than_or_equal_to(6).all.should == User.find_all_by_age([6, 7])
    end
  end

  context "wildcard conditions" do
    it "should have like" do
      User.username_like("john").all.should == User.where("username LIKE '%john%'").all
    end

    it "should have not like" do
      User.username_not_like("john").all.should == User.where("username NOT LIKE '%john%'").all
    end

    it "should have begins with" do
      User.username_begins_with("bj").all.should == User.where("username LIKE 'bj%'").all
    end

    it "should have not begin with" do
      User.username_not_begin_with("bj").all.should == User.where("username NOT LIKE 'bj%'").all
    end

    it "should have ends with" do
      User.username_ends_with("son").all.should == User.where("username LIKE '%son'").all
    end

    it "should have not end with" do
      User.username_not_end_with("son").all.should == User.where("username NOT LIKE '%son'").all
    end
  end

  context "boolean conditions" do
    it "should have scopes for boolean columns" do
      User.male.all.should == User.where(:male => true)
      User.not_male.all.should == User.where(:male => false)
    end

    it "should have null" do
      User.username_null.all.should == User.where(:username => nil)
    end

    it "should have not null" do
      User.username_not_null.all.should == User.where("username IS NOT NULL").all
    end

    it "should have empty" do
      User.username_empty.all.should == User.where(:username => "").all
    end

    it "should have blank" do
      User.username_blank.all.should =~ [User.where(:username => "").all, User.where(:username => nil)].flatten
    end

    it "should have not blank" do
      User.username_not_blank.all.should == User.where("username != '' and username IS NOT NULL").all
    end
  end

  context "any and all conditions" do
    it "should treat an array and multiple arguments the same" do
      User.username_like_any("bjohnson", "thunt").should == User.username_like_any(["bjohnson", "thunt"])
    end

    it "should have equals any" do
      User.username_equals_any("bjohnson", "thunt").all.should == User.find_all_by_username(["bjohnson", "thunt"])
    end

    it "should have does not equal any (same as .all)" do
      # this produces (foo != 'bar' OR foo != 'baz'), obviously the same as unrestricted find
      User.username_does_not_equal_any("bjohnson", "thunt").all.should == User.all
    end

    it "should have does not equal all" do
      User.username_does_not_equal_all("bjohnson", "thunt").all.should == User.where("username NOT IN ('bjohnson', 'thunt')").all
    end

    it "should have less than any" do
      User.age_less_than_any(7,6).all.should == User.find_all_by_age([5, 6])
    end

    it "should have less than all" do
      User.age_less_than_all(7,6).all.should == User.find_all_by_age(5)
    end

    it "should have less than or equal to any" do
      User.age_less_than_or_equal_to_any(7,6).all.should == User.find_all_by_age([5, 6, 7])
    end

    it "should have less than or equal to all" do
      User.age_less_than_or_equal_to_all(7,6).all.should == User.find_all_by_age([5, 6])
    end

    it "should have less than any" do
      User.age_greater_than_any(5,6).all.should == User.find_all_by_age([6, 7])
    end

    it "should have greater than all" do
      User.age_greater_than_all(5,6).all.should == User.find_all_by_age(7)
    end

    it "should have greater than or equal to any" do
      User.age_greater_than_or_equal_to_any(5,6).all.should == User.find_all_by_age([5, 6, 7])
    end

    it "should have greater than or equal to all" do
      User.age_greater_than_or_equal_to_all(5,6).all.should == User.find_all_by_age([6, 7])
    end

    it "should have like all" do
      User.username_like_all("bjohnson", "thunt").all.should == []
      User.username_like_all("n", "o").all.should == User.find_all_by_username(["bjohnson", "dgainor"])
    end

    it "should have like any" do
      User.username_like_any("bjohnson", "thunt").all.should == User.find_all_by_username(["bjohnson", "thunt"])
    end

    it "should have begins with all" do
      User.username_begins_with_all("bjohnson", "thunt").all.should == []
    end

    it "should have begins with any" do
      User.username_begins_with_any("bj", "th").all.should == User.find_all_by_username(["bjohnson", "thunt"])
    end

    it "should have ends with all" do
      User.username_ends_with_all("n", "r").all.should == []
    end

    it "should have ends with any" do
      User.username_ends_with_any("n", "r").all.should == User.find_all_by_username(["bjohnson", "dgainor"])
    end
  end

  context "alias conditions" do
    it "should have is" do
      User.age_is(5).to_sql.squeeze.should == User.age_equals(5).to_sql.squeeze
    end

    it "should have eq" do
      User.age_eq(5).to_sql.squeeze.should == User.age_equals(5).to_sql.squeeze
    end

    it "should have not_equal_to" do
      User.age_not_equal_to(5).to_sql.squeeze.should == User.age_does_not_equal(5).to_sql.squeeze
    end

    it "should have is_not" do
      User.age_is_not(5).to_sql.squeeze.should == User.age_does_not_equal(5).to_sql.squeeze
    end

    it "should have not" do
      User.age_not(5).to_sql.squeeze.should == User.age_does_not_equal(5).to_sql.squeeze
    end

    it "should have ne" do
      User.age_ne(5).to_sql.squeeze.should == User.age_does_not_equal(5).to_sql.squeeze
    end

    it "should have lt" do
      User.age_lt(5).to_sql.squeeze.should == User.age_less_than(5).to_sql.squeeze
    end

    it "should have lte" do
      User.age_lte(5).to_sql.squeeze.should == User.age_less_than_or_equal_to(5).to_sql.squeeze
    end

    it "should have gt" do
      User.age_gt(5).to_sql.squeeze.should == User.age_greater_than(5).to_sql.squeeze
    end

    it "should have gte" do
      User.age_gte(5).to_sql.squeeze.should == User.age_greater_than_or_equal_to(5).to_sql.squeeze
    end

    it "should have contains" do
      User.username_contains(5).to_sql.squeeze.should == User.username_like(5).to_sql.squeeze
    end

    it "should have contains" do
      User.username_includes(5).to_sql.squeeze.should == User.username_like(5).to_sql.squeeze
    end

    it "should have bw" do
      User.username_bw(5).to_sql.squeeze.should == User.username_begins_with(5).to_sql.squeeze
    end

    it "should have ew" do
      User.username_ew(5).to_sql.squeeze.should == User.username_ends_with(5).to_sql.squeeze
    end

    it "should have nil" do
      User.username_nil.to_sql.squeeze.should == User.username_nil.to_sql.squeeze
    end
  end

  context "group conditions" do
    it "should have in" do
      User.age_in([5,6]).all.should == User.find(:all, :conditions => ["users.age IN (?)", [5, 6]])
    end

    it "should have not_in" do
      User.age_not_in([5,6]).all.should == User.find(:all, :conditions => ["users.age NOT IN (?)", [5, 6]])
    end
  end

#  context "searchlogic lambda" do
#    it "should be a string" do
#      User.username_like("test")
#      User.named_scope_options(:username_like).searchlogic_options[:type].should == :string
#    end
#
#    it "should be an integer" do
#      User.id_gt(10)
#      User.named_scope_options(:id_gt).searchlogic_options[:type].should == :integer
#    end
#
#    it "should be a float" do
#        Order.total_gt(10)
#      Order.named_scope_options(:total_gt).searchlogic_options[:type].should == :float
#    end
#  end

  it "should have priorty to columns over conflicting association conditions" do
    Company.users_count_gt(10)
    User.company_id_null.count.should == User.where(:company_id => nil).count
    User.company_id_not_null.count.should == 0
  end

  it "should fix bug for issue 26" do
    count1 = User.id_ne(10).username_not_like("root").count
    count2 = User.id_ne(10).username_not_like("root").count
    count1.should == count2
  end
end
