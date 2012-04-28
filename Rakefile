# vim: set filetype=ruby et sw=2 ts=2:

require 'gem_hadar'

GemHadar do
  name        'simplenote-client'
  path_name   'simplenote/client'
  author      'Florian Frank'
  email       'flori@ping.de'
  homepage    "http://github.com/flori/#{name}"
  summary     'Client application for the Simplenote API'
  description 'This gem provides a CLI program to send commands to the Simplenote API.'
  bindir      'bin'
  executables Dir['bin/*'].map(&File.method(:basename))
  test_dir    'tests'
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock', '.rvmrc', '.AppleDouble'
  readme      'README.rdoc'

  dependency  'tins',           '~>0.4.2'
  dependency  'term-ansicolor', '~>1.0'
  dependency  'dslkit',         '~>0.2.10'
  dependency  'json',           '~>1.7.0'
  dependency  'httparty',       '~>0.8.0'
end
