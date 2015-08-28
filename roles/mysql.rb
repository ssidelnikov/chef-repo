name 'mysql'
description 'MySQL server for apps'
run_list "role[base]", "recipe[mysql::server]", "recipe[mysql::client]"
default_attributes("mysql" => { "bind_address" => "127.0.0.1", "collation" => "utf8_general_ci", "character_set" => "utf8" })
