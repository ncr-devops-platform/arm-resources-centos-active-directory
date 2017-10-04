require 'bump'

namespace :release do
  task :bump do
    Bump::Bump.run('patch', commit: true, bundle: false, tag: false)
  end

  task :push do
    version = Bump::Bump.current
    sh <<-PUSH
      git tag -a v#{version} -m \"Releasing v#{version}\"
      git push
      git push origin v#{version}
    PUSH
  end

  desc 'releases this package'
  task all: [:bump, :push]
end
