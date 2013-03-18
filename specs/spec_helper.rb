$:.push File.expand_path("../../lib", __FILE__)
require 'minitest/autorun'

if ENV['USE_SPECS']
  require 'minitest/reporters'
  MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new
end
