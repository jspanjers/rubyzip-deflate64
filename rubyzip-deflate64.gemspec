# frozen_string_literal: true

require_relative 'lib/zip/deflate64/version'

Gem::Specification.new do |spec|
  spec.name = 'rubyzip-deflate64'
  spec.version = Zip::Deflate64::VERSION
  spec.authors = [
    'Jan-Joost Spanjers'
  ]

  spec.summary = 'Extension of rubyzip to read deflate64 compressed files'
  spec.description =
    'The rubyzip-deflate64 gem provides an extension of the rubyzip gem ' \
    'for reading zip files compressed with deflate64 compression'
  spec.homepage = 'http://github.com/jspanjers/rubyzip-deflate64'
  spec.license = 'BSD 2-Clause'
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.0'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/jspanjers/rubyzip-deflate64/issues',
    'changelog_uri' => "https://github.com/jspanjers/rubyzip-deflate64/blob/v#{spec.version}/Changelog.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/rubyzip-deflate64/#{spec.version}",
    'source_code_uri' => "https://github.com/jspanjers/rubyzip-deflate64/tree/v#{spec.version}",
    'wiki_uri' => 'https://github.com/jspanjers/rubyzip-deflate64/wiki',
    'rubygems_mfa_required' => 'true'
  }

  spec.add_dependency 'ffi', '~> 1.0'
  spec.add_dependency 'rubyzip', '~> 3.0'
end
