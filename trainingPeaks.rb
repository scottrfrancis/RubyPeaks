require "savon"

class TrainingPeaks
  TPWSDL= 'http://www.trainingpeaks.com/tpwebservices/service.asmx?WSDL'
  
  def initialize( user=nil, password=nil )
    @user= user
    @password= password
    
    @client= openClient
    
    @personID= getPersonID
  end
  
  def openClient
    client= nil
       
    if ( !@user.nil? && !@password.nil? )
      client = Savon.client( wsdl: TPWSDL )
      
     resp = callTP( :authenticate_account )
    #  resp = client.call( :authenticate_account, message: { username: @user, password: @password })
      @guid = resp.body[:authenticate_account_response][:authenticate_account_result]  
    end
    
    client
  end
  
  def callTP( method, params=nil )
    @client = openClient if @client.nil?
    
    msg = { username: @user, password: @password }
    msg.each_with_object( params ) { |(k,v), h| h[k] = v } if !params.nil?
      #    resp.body[:authenticate_account_response][:authenticate_account_result]
    puts( method )
    puts( msg )
    resp = @client.call( method.to_sym, message: msg )
  end
  
  def getPersonID
    id = nil
   
    
    id
  end
  
end