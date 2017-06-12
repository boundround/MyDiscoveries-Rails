namespace :db do

  desc 'Dumps the database to backups'
  task dump: :environment do
    cmd = nil
    with_config do |db, user|
      dump_path = "#{Rails.root}/../shared/backups/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{db}.psql"
      cmd = "pg_dump -F c -v -d #{db} -f #{dump_path}"
    end
    puts cmd
    exec cmd
  end

  # e.g. rake rake db:restore[20170612143343_mydiscoveries.psql]
  desc 'Restores the database from backups'
  task :restore, [:name] => :environment do |task, args|
    dump_path = "#{Rails.root}/../shared/backups/#{args.name}"

    if args.name.present? && File.exist?(dump_path)
      cmd = "pg_restore -F c -v -c -C #{dump_path}"
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      puts cmd
      exec cmd
    else
      puts 'Please pass a correct dump name'
    end
  end

  private

  def with_config
    yield ActiveRecord::Base.connection_config[:database],
    ActiveRecord::Base.connection_config[:username]
  end

end
