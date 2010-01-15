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
    file_object.puts "node [fontname=Arial]\n"
    file_object.puts "edge [fontname=Arial,fontsize=9,style=dashed,color=brown]\n"
    ActiveRecord::Base.send(:subclasses).each do |klass|
      klass.reflect_on_all_associations.each { |a|
        if klass.name == a.class_name.to_s.camelize.singularize
          file_object.puts  klass.name + " -> " + klass.name + " [label="+a.macro.to_s+"_#{a.name.to_s.camelize.singularize}]" 
        else
          file_object.puts  klass.name + " -> " + a.name.to_s.camelize.singularize + " [label="+a.macro.to_s+"]" 
        end  
      }
    end
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

