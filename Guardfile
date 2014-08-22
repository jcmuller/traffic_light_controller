# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'rspec', cmd: "rspec" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/support/.+_spec\.rb$}) { "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard 'ctags-bundler', src_path: ["lib", "spec/support"] do
  watch(%r{^(lib|spec\/support)/.*\.rb$})
  watch('Gemfile.lock')
end
