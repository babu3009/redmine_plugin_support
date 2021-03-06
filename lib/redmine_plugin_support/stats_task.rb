module RedminePluginSupport
  class StatsTask < GeneralTask

    STATS_DIRECTORIES = [
                         %w(Controllers        app/controllers),
                         %w(Helpers            app/helpers), 
                         %w(Models             app/models),
                         %w(Libraries          lib/),
                         %w(APIs               app/apis),
                         %w(Integration\ tests test/integration),
                         %w(Functional\ tests  test/functional),
                         %w(Unit\ tests        test/unit)
                        ]

    def stats_directories
      STATS_DIRECTORIES.collect { |name, dir| [ name, "#{RedmineHelper.plugin_root}/#{dir}" ] }.select { |name, dir| File.directory?(dir) }
    end
    
    def define
      # TODO: Need to get rspec stats to work
      
      namespace :spec do
        task :statsetup do
          require 'code_statistics'
          STATS_DIRECTORIES << %w(Model\ specs spec/models) if File.exist?("#{RedmineHelper.plugin_root}/spec/models")
          STATS_DIRECTORIES << %w(View\ specs spec/views) if File.exist?("#{RedmineHelper.plugin_root}/spec/views")
          STATS_DIRECTORIES << %w(Controller\ specs spec/controllers) if File.exist?("#{RedmineHelper.plugin_root}/spec/controllers")
          STATS_DIRECTORIES << %w(Helper\ specs spec/helpers) if File.exist?("#{RedmineHelper.plugin_root}/spec/helpers")
          STATS_DIRECTORIES << %w(Library\ specs spec/lib) if File.exist?("#{RedmineHelper.plugin_root}/spec/lib")
          STATS_DIRECTORIES << %w(Routing\ specs spec/routing) if File.exist?("#{RedmineHelper.plugin_root}/spec/routing")
          STATS_DIRECTORIES << %w(Integration\ specs spec/integration) if File.exist?("#{RedmineHelper.plugin_root}/spec/integration")
          ::CodeStatistics::TEST_TYPES << "Model specs" if File.exist?("#{RedmineHelper.plugin_root}/spec/models")
          ::CodeStatistics::TEST_TYPES << "View specs" if File.exist?("#{RedmineHelper.plugin_root}/spec/views")
          ::CodeStatistics::TEST_TYPES << "Controller specs" if File.exist?("#{RedmineHelper.plugin_root}/spec/controllers")
          ::CodeStatistics::TEST_TYPES << "Helper specs" if File.exist?("#{RedmineHelper.plugin_root}/spec/helpers")
          ::CodeStatistics::TEST_TYPES << "Library specs" if File.exist?("#{RedmineHelper.plugin_root}/spec/lib")
          ::CodeStatistics::TEST_TYPES << "Routing specs" if File.exist?("#{RedmineHelper.plugin_root}/spec/routing")
          ::CodeStatistics::TEST_TYPES << "Integration specs" if File.exist?("#{RedmineHelper.plugin_root}/spec/integration")
        end
      end



      desc "Report code statistics (KLOCs, etc) from the application"
      task :stats do
        require 'code_statistics'
        CodeStatistics.new(*stats_directories).to_s
      end
      
      self
    end
    
  end
end

