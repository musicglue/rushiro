guard :bundler do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard :minitest do
  watch(%r{^lib/(.+)\.rb}) { 'spec' }
  watch(%r{^spec/(.*)_spec\.rb})
  watch(%r{^spec/spec_helper\.rb}) { 'spec' }
end

guard :reek do
  watch(%r{^lib/(.+)\.rb$})
end

guard :rubocop, cli: ['--auto-correct'] do
  watch(%r{^lib/(.+)\.rb$})
end
