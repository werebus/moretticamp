# frozen_string_literal: true

%w[setup deploy rails bundler passenger pending].each do |lib|
  require "capistrano/#{lib}"
end

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
