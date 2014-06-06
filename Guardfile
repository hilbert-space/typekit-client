guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/(.+)\.rb$}) { 'spec' }
  watch(%r{^lib/(.+)\.rb$}) do |match|
    result = "spec/#{ match[1] }_spec.rb"
    loop do
      break if File.exist?(result)
      result = File.dirname(result)
      break if result.empty?
    end
    result
  end
end
# vim: ft=ruby
