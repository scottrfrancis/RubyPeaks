require "savon"

class TrainingPeaks
  TPWSDL= 'http://www.trainingpeaks.com/tpwebservices/service.asmx?WSDL'
  
  def initialize( user, password )
    @user= user
    @password= password
    
    @client= openClient
    
    @personID= getPersonID
  end
  
  def openClient
    if ( @client.nil? && !@user.nil? && !@password.nil? )
      @client = Savon.client( wsdl: TPWSDL )
      
      resp = callTP( :authenticate_account )
      @guid = resp.body[:authenticate_account_response][:authenticate_account_result]  
    end
    
    @client
  end
  
  def callTP( method, params=nil )
    @client = openClient if @client.nil?
    
    msg = { username: @user, password: @password }
    msg = msg.each_with_object( params ) { |(k,v), h| h[k] = v } if !params.nil?
    resp = @client.call( method.to_sym, message: msg )
  end
  
  def getPersonID
    id = nil
    
    resp = callTP( :get_accessible_athletes, 
      { types: [ #"CoachedPremium",         # call fails if CoachedPremium is included
        "SelfCoachedPremium", 
        "SharedSelfCoachedPremium",
        "SharedCoachedPremium",
        "CoachedFree",
        "SharedFree",
        "Plan"
        ] } )
    
    id = resp.body[:get_accessible_athletes_response][:get_accessible_athletes_result][:person_base][:person_id]
  end
  
  def getWorkouts( start, stop )
    resp = callTP( :get_workouts_for_accessible_athlete,
        { personId: @personID, startDate: start, endDate: stop } )
  
  end
end