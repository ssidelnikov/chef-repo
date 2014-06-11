name 'sidekiq'
description 'This role configures a sidekiq server to run'
run_list "recipe[redisio::install]", "recipe[redisio::enable]", "recipe[monit]", "recipe[monit::ubuntu12fix]", "recipe[sidekiq]"

