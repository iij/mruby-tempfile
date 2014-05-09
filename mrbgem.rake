MRuby::Gem::Specification.new('mruby-tempfile') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Internet Initiative Japan Inc.'

  spec.add_dependency 'mruby-dir'
  #spec.add_dependency 'mruby-env'      # not mandatory
  spec.add_dependency 'mruby-io'
  #spec.add_dependency 'mruby-random'   # or 'mruby-simple-random'
end
