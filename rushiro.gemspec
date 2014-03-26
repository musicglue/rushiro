Gem::Specification.new do |s|
  s.name        = 'rushiro'
  s.version     = '2.0.0'
  s.date        = '2014-03-26'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Lee Henson', 'Guy Boertje']
  s.email       = ['lee.m.henson@gmail.com', 'guyboertje@gmail.com']
  s.homepage    = "http://github.com/guyboertje/rushiro"
  s.summary     = %q{Explicit permissions inspired by Apache Shiro}
  s.description = %q{}

  # = MANIFEST =
  s.files = %w[
    Gemfile
    Guardfile
    Rakefile
    lib/rushiro.rb
    lib/rushiro/acl.rb
    lib/rushiro/modes/allow_by_default.rb
    lib/rushiro/modes/deny_by_default.rb
    lib/rushiro/rule.rb
    lib/rushiro/rules.rb
    lib/rushiro/version.rb
    readme.md
    rushiro.gemspec
    spec/acl_spec.rb
    spec/allowed_by_default_rules_spec.rb
    spec/denied_by_default_rules_spec.rb
    spec/rule_spec.rb
    spec/spec_helper.rb
  ]
  # = MANIFEST =

  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
end
