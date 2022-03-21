# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'convolver/version'

Gem::Specification.new do |spec|
  spec.name          = 'convolver-light'
  spec.version       = Convolver::VERSION
  spec.authors       = ['Dima Ermilov']
  spec.email         = ['wlaer@wlaer.com']
  spec.description   = 'Simplification of convolver gem, FFTW removed, suitable only for smaller kernels. Convolver gem author is Neil Slater, slobo777@gmail.com, https://github.com/neilslater'
  spec.summary       = 'Convolution for NArray simplified.'
  spec.homepage      = 'http://github.com/adworse/convolver-light'
  spec.license       = 'MIT'

  spec.add_dependency "narray", ">= 0.6.0.8"

  spec.add_development_dependency "yard", ">= 0.8.7.2"
  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rspec", ">= 2.13.0"
  spec.add_development_dependency "rake", ">= 1.9.1"
  spec.add_development_dependency "rake-compiler", ">= 0.8.3"
  spec.add_development_dependency "coveralls", ">= 0.6.7"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.extensions    = spec.files.grep(%r{/extconf\.rb$})
  spec.require_paths = ["lib"]
end
