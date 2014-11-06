

require 'nokogiri'


class PWXFile
  
  def initialize( aFileName = nil )
    @doc = nil
    
    @doc = loadFile( aFileName );
  end
  
  def getDoc
    @doc
  end
  
  def loadFile( aFileName )
    if !aFileName.nil? && aFileName != ""
      File.open( aFileName ) do |f|
        @doc = Nokogiri::XML( f )
      end
    end
    
    @doc
  end
  
  def getNodeFloatAndAttrHash( node )
    result = nil
    
    if node.attributes.length <= 0
     result = node.text.to_f
    else
     result = {}
     node.attributes.each do |k,v|
       result[k] = v.value.to_f
     end
    end
           
    result
  end
  
  def getSummary()
    summary = {}
    
    if !@doc.nil?
      workoutSummary = @doc.xpath( "//xmlns:workout/xmlns:summarydata" )
      
      workoutSummary.children.each do |n|
        next if n.class != Nokogiri::XML::Element
        
        summary[n.name] = getNodeFloatAndAttrHash( n )
      end
    end
      
    summary
  end
  
  def getSegments()
    segments = []
    
    if !@doc.nil?
      @doc.xpath( "//xmlns:workout/xmlns:segment" ).each do |s|
        sh = {}
        s.xpath( "xmlns:summarydata" ).children.each do |c|
          next if c.class != Nokogiri::XML::Element
          
          sh[c.name] = getNodeFloatAndAttrHash( c )
        end 
        
        segments << { s.xpath( "xmlns:name" ).text=> sh }
      end
    end
      
    segments
  end
  
  def getSamples
  	samples = []
  
  	if !@doc.nil?
  		@doc.xpath( "//xmlns:workout/xmlns:sample" ).each do |s|
  			sa = {}
  			s.children.each do |c|
  			  next if c.class != Nokogiri::XML::Element
  				sa[c.name] = c.text.to_f
  			end
  			
  			samples << sa
  		end
  	end
  	
  	samples
  end
  
end