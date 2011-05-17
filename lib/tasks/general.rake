namespace :do do

  desc 'Nuke the app clean. DANGER!'
  task :nuke => ['db:drop', 'db:create', 'db:migrate', 'db:seed']

end
