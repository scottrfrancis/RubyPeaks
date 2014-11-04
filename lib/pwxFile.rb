

require 'nokogiri'


class PWXFile
  
  def initialize( aFileName = nil )
    @doc = nil
    
    @doc = loadFile( aFileName )
  end
  
  def loadFile( aFileName )
    if !aFileName.nil? && aFileName != ""
      File.open( aFileName ) do |f|
        @doc = Nokogiri::XML( f ).remove_namespaces!
      end
    end
    
    @doc
  end
  
  def getSummary()
    
    
  end
  
end