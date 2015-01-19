set :stage, :staging
set :rails_env, :staging

server 'de-sr-beta.alpha.vmp.ru', user: 'deploy', roles: %w{app db web}
