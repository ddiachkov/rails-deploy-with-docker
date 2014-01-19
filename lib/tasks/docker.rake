namespace :docker do
  task :checkout do
    system 'cd tmp && rm -rf clean-copy && git clone --depth 1 --single-branch --branch master git@github.com:amuino/rails-deploy-with-docker.git clean-copy'
  end

  desc "Builds a docker image from the repository"
  task :build => 'checkout' do
    puts "-- Executing workaround for ADD cache using file timestamps, not only content"
    puts "-- reseting all timestamps to 2000-01-01 (random date)"
    system 'find tmp/clean-copy/ -exec touch -t 200001010000.00 {} ";"'
    system 'docker build -rm -t "amuino/learn-rails-app" tmp/clean-copy'
  end
end
