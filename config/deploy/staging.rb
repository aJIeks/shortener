set :stage, :staging

server 'de-sr-beta.alpha.vmp.ru', user: 'deploy', roles: %w{app db web}
