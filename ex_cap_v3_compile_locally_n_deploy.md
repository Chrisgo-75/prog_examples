Below example is from (https://stackoverflow.com/questions/43911610/deploy-rails-5-1-webpacker-app-with-capistrano/45236293)

For use with Capistrano -v 3 series.

Below, compiles assets locally and then copy to the production servers with rsync. Of course, you need node and yarn installed locally.

```
# lib/capistrano/tasks/precompile.rake
namespace :assets do
  desc 'Precompile assets locally and then rsync to web servers'
  task :precompile do
    run_locally do
      with rails_env: stage_of_env do
        execute :bundle, 'exec rake assets:precompile'
      end
    end

    on roles(:web), in: :parallel do |server|
      run_locally do
        execute :rsync,
          "-a --delete ./public/packs/ #{fetch(:user)}@#{server.hostname}:#{shared_path}/public/packs/"
        execute :rsync,
          "-a --delete ./public/assets/ #{fetch(:user)}@#{server.hostname}:#{shared_path}/public/assets/"
      end
    end

    run_locally do
      execute :rm, '-rf public/assets'
      execute :rm, '-rf public/packs'
    end
  end
end

# config/deploy.rb
after 'deploy:updated', 'assets:precompile'
```

In your Capfile you need to include all the capistrano tasks:

```
# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/**/*.rake').each { |r| import r }
```

This eliminates the need to install node and yarn on the production servers. :)

