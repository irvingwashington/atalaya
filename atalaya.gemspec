
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'atalaya/version'

Gem::Specification.new do |spec|
  spec.name          = 'atalaya'
  spec.version       = Atalaya::VERSION
  spec.authors       = ['Maciek Dubiński']
  spec.email         = ["maciek@dubinski.net"]

  spec.summary       = %q{A watchtower type Rack application}
  spec.description   = %q{Rack application to provide a detailed inspection endpoints}
  spec.homepage      = 'https://github.com/irvingwashington/atalaya'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = nil
  spec.executables   = []
  spec.require_paths = ['lib']
  spec.bindir        = ['exe']
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
