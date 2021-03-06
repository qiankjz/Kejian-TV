# P.S.V.R modified
# More info at https://github.com/guard/guard#readme
# Guard shows a Pry console whenever it has nothing to do and comes with some Guard specific Pry commands:
#
# ↩, a, all: Run all plugins.
# h, help: Show help for all interactor commands.
# c, change: Trigger a file change.
# n, notification: Toggles the notifications.
# p, pause: Toggles the file listener.
# r, reload: Reload all plugins.
# s, show: Show all Guard plugins.
# e, exit: Stop all plugins and quit Guard
# The all and reload commands supports an optional scope, so you limit the Guard action to either a Guard plugin or a Guard group like:


guard 'spork',:test_unit => false,:minitest => true,:wait=>180 do
  watch(%r{^config/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('test/test_helper.rb') { :minitest }
end

guard 'minitest', :drb => true do
  # with Minitest::Unit
  watch(%r|^test/(.*)\/?(.*)_test\.rb|)
  watch(%r|^lib/(.*)([^/]+)\.rb|) { |m| "test/lib/#{m[1]}test_#{m[2]}.rb" }
  watch(%r|^test/test_helper\.rb|) { "test" }
  watch(%r|^test/factories\.rb|)

  # Rails 3.2
  watch(%r|^app/controllers/(.*)\.rb|) { |m| "test/controllers/#{m[1]}_test.rb" }
  watch(%r|^app/models/(.*)\.rb|) { |m| "test/models/#{m[1]}_test.rb" }
  # watch(%r|^app/models/user.rb|) { "test/models/play_list_test.rb" }
  watch(%r|^app/controllers/application_controller\.rb|) { "test/controllers" }
  watch(%r|^app/models/base_model\.rb|) { "test/models" }
  watch(%r|^app/models/active_base_model\.rb|) { "test/models" }
end