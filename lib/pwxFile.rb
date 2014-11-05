

require 'nokogiri'


class PWXFile
  
  def initialize( aFileName = nil )
    @doc = nil
    
    @doc = loadFile( aFileName )
  end
  
  def loadFile( aFileName )
    if !aFileName.nil? && aFileName != ""
      File.open( aFileName ) do |f|
        @doc = Nokogiri::XML( f )
      end
    end
    
    @doc
  end
  
  def getSummary()
    summary = {}
    
    if !@doc.nil?
      workoutSummary = @doc.xpath( "//xmlns:workout/xmlns:summarydata" )
      
      workoutSummary.children.each do |n|
        next if n.class != Nokogiri::XML::Element
        
        if n.attributes.length <= 0
          summary[n.name] = n.text.to_f
        else
          summary[n.name] = {}
          n.attributes.each do |k,v|
            summary[n.name][k] = v.value.to_f
          end
        end
      end
    end
      
    summary
  end
  
end