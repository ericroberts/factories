require 'active_record'
require 'logger'

ActiveRecord::Base.logger = Logger.new('db/debug.log')
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/data.sqlite3')
