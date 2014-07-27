guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/.+_helper\.rb$}) { 'spec' }
  watch(%r{^lib/(.+)\.rb$}) do |match|
    result = "spec/lib/#{match[1]}_spec.rb"
    begin
      break if File.exist?(result)
      result = File.dirname(result)
    end until result.empty?
    result
  end
  watch(%r{^lib/[^/]+/(.+)\.rb$}) do |match|
    result = "spec/features/#{match[1]}"
    begin
      break if File.exist?(result)
      result = File.dirname(result)
    end until result.empty?
    result
  end
end

require 'guard/plugin'

module ::Guard
  class Whatever < ::Guard::Plugin
    def run_all; end
    def run_on_changes(*); end
  end
end

guard :whatever do
  watch(%r{^lib/.*\.rb$})
  watch(%r{^.*\.md$})

  callback(:run_all_end) { system 'yardoc' }
  callback(:run_on_changes_end) { system 'yardoc' }
end

# vim: ft=ruby
