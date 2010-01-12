require File.join(File.dirname(__FILE__), "../lib/model_diagram.rb")

namespace :model_diagram do

    desc "Generates Model relationship diagram in a rails application"
    task :generate => :environment do
      ModelDiagram.generate_relationship_view      
    end
end

