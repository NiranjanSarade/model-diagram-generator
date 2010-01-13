require "config/environment"
Dir.glob("app/models/*rb") { |f|
    require f
}

class ModelDiagram

  def self.generate_relationship_view
    doc_filepath = "#{RAILS_ROOT}/" + "model_relationship.dot"
    File.delete(doc_filepath) if File.exists?(doc_filepath)
    file_object = File.new(doc_filepath, 'a')

    file_object.puts "digraph model_relationship {"    
    Dir.glob("app/models/*rb") { |f|
      f.match(/\/([a-z_]+)\./)
      classname = $1.camelize
      klass = Kernel.const_get classname
      if klass.superclass == ActiveRecord::Base
        klass.reflect_on_all_associations.each { |a|
            file_object.puts  classname + " -> " + a.name.to_s.camelize.singularize + " [label="+a.macro.to_s+"]" 
         }
      end
    }
    file_object.puts "}"
    file_object.close 
    system "dot -Tpng model_relationship.dot -o model_relationship.png" 
    if $?.success? 
      puts "model_relationship.png created successfully."
    else
      puts "Could not create model_relationship.png. Please install graphviz (http://www.graphviz.org)." 
    end 
  end
end

