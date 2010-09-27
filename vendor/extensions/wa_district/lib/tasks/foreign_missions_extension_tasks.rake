namespace :radiant do
  namespace :extensions do
    namespace :foreign_missions do
      
      desc "Runs the migration of the Foreign Missions extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ForeignMissionsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ForeignMissionsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Foreign Missions to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from ForeignMissionsExtension"
        Dir[ForeignMissionsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(ForeignMissionsExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
