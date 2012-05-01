require "bundler"
Bundler.require(:default, :development)

ActiveRecord::Base.establish_connection(:adapter => "sqlite3",
                                        :database => ":memory:")
                                        #:database => File.dirname(__FILE__) + "/sl3.sqlite3")

load File.dirname(__FILE__) + '/support/schema.rb'
load File.dirname(__FILE__) + '/support/models.rb'
load File.dirname(__FILE__) + '/support/data.rb'

RSpec.configure do |config|
  # RSpec automatically cleans stuff out of backtraces;
  # sometimes this is annoying when trying to debug something e.g. a gem
  config.backtrace_clean_patterns = [
    /\/lib\d*\/ruby\//,
    /bin\//,
    /gems/,
    /spec\/spec_helper\.rb/,
    /lib\/rspec\/(core|expectations|matchers|mocks)/
  ]
end

RSpec::Matchers.define :eq_scope do |relation2|
  match do |relation1|
    relation1.to_sql.squeeze(' ').downcase == relation2.to_sql.squeeze(' ').downcase
  end
  failure_message_for_should do |relation1|
    "expected\n#{relation2.to_sql.squeeze(' ')}\nto equal\n#{relation1.to_sql.squeeze(' ')}"
  end
  failure_message_for_should_not do |relation1|
    "expected\n#{relation2.to_sql.squeeze(' ')}\nto not equal\n#{relation1.to_sql.squeeze(' ')}"
  end
end

