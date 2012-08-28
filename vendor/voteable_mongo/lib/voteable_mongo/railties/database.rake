namespace :mongo do
  namespace :voteable do
    desc 'Update up_votes_count, down_votes_count, votes_count and votes_point'
    task :remake_stats => :environment do
      Mongo::Voteable::Tasks.remake_stats(:log)
    end

    desc 'Set counters and point to 0 for uninitizized voteable objects'
    task :init_stats => :environment do
      Mongo::Voteable::Tasks.init_stats(:log)
    end

    desc 'Migrate vote data created by version < 0.7.0 to new vote data storage'
    task :migrate_old_votes => :environment do
      Mongo::Voteable::Tasks.migrate_old_votes(:log)
    end
  end
end
