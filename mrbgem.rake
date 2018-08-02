MRuby::Gem::Specification.new('mruby-tempfile') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Internet Initiative Japan Inc.'

  spec.add_dependency 'mruby-dir'
  spec.add_dependency 'mruby-env'
  spec.add_dependency 'mruby-io'
  spec.add_dependency 'mruby-random', core: 'mruby-random'
  spec.add_dependency 'mruby-sprintf', core: 'mruby-sprintf'
  spec.add_dependency 'mruby-time', core: 'mruby-time'
  spec.add_dependency 'mruby-errno'
  spec.add_dependency 'mruby-file-stat'
end
