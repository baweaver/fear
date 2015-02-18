require 'active_record'
require 'functional/active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

module Connections
  def self.extended(host)
    host.connection.execute <<-SQL
      CREATE TABLE #{host.table_name} (
        #{host.primary_key} integer PRIMARY KEY AUTOINCREMENT,
        value integer
      );
    SQL
  end
end

class TestModel < ActiveRecord::Base
  extend Connections
  prepend Functional::ActiveRecord

  validates :value, presence: true
end

