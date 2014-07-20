guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/.+_helper\.rb$}) { 'spec' }
  watch(%r{^lib/(.+)\.rb$}) do |match|
    result = "spec/#{ match[1] }_spec.rb"
    begin
      break if File.exist?(result)
      result = File.dirname(result)
    end until result.empty?
    result
  end
  watch(%r{^lib/[^/]+/(.+)\.rb$}) do |match|
    result = "spec/features/#{ match[1] }"
    begin
      break if File.exist?(result)
      result = File.dirname(result)
    end until result.empty?
    result
  end
end
# vim: ft=ruby
