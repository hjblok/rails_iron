options = {
  failed_mode: :none,
  cmd: :rspec,
  all_on_start: false,
  all_after_pass: false
}

guard :rspec, options do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
