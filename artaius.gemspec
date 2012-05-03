require './lib/artaius/version'

Gem::Specification.new do |s|
  s.name         = 'artaius'
  s.version      = Artaius::VERSION
  s.date         = Time.now.strftime('%Y-%m-%d')
  s.summary      = "IRC bot serving King Arthur's Gold players."
  s.author       = 'Kyrylo Silin'
  s.email        = 'kyrylosilin@gmail.com'
  s.homepage     = 'https://github.com/kyrylo/artaius'
  s.license      = 'zlib'

  s.require_path = 'lib'
  s.files        = `git ls-files`.split "\n"
  s.test_files   = `git ls-files -- spec`.split "\n"

  s.extra_rdoc_files = %W{README.md LICENSE}
  s.rdoc_options     = ["--charset=UTF-8"]

  s.add_runtime_dependency     'cinch',          '~>2.0'
  s.add_runtime_dependency     'kag',            '~>0.1'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest', '>=2.12.1'
  s.add_development_dependency 'fivemat', '>=1.0.0'

  s.required_ruby_version = '~>1.9'

  s.description  = <<description
    Artaius is an IRC (Internet Relay Chat) bot for KAG (King Arthur's Gold)
    game. It cannot everything for the time being.
description
end
