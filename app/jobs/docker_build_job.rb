class DockerBuildJob < ActiveJob::Base
  queue_as :default

  DockerfileName = 'Dockerfile'
  Configs = {
    ruby: File.expand_path('../../data/Dockerfile.ruby', __FILE__),
    node: File.expand_path('../../data/Dockerfile.node', __FILE__),
    default: File.expand_path('../../data/Dockerfile.default', __FILE__)
  }

  def perform(repo, branch)
    Dir.tmpdir do |dir|
      system('git', 'clone', repo, '-b', branch, dir)
      Dir.chdir dir do
        if File.exist? 'docker-compose.yml'
          system('docker-compose', 'build')
        else
          copy_dockerfile
          system('docker', 'build', '-t', tag_name, '.')
        end
      end
    end
  end

  def copy_dockerfile
    return if File.exist? DockerfileName

    if File.exist? 'Gemfile'
      FileUtils.cp Configs[:ruby], DockerfileName
    elsif File.exist? 'package.json'
      FileUtils.cp Configs[:node], DockerfileName
    else
      FileUtils.cp Configs[:default], DockerfileName
    end
  end
end
