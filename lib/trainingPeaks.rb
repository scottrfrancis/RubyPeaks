require "savon"

class TrainingPeaks
  TPWSDL= 'http://www.trainingpeaks.com/tpwebservices/service.asmx?WSDL'
  
  attr_accessor :user, :password, :client, :guid, :athletes, :personID
  
  
  #
  # you can init the class without a user/password, but you'll need one soon enough
  # use the user & password setters 
  def initialize( aUser=nil, aPassword=nil )
    @user= aUser
    @password= aPassword
    
    @client= openClient
    
    @guid=nil          # returned from authenticate
    @athletes=nil
    @personID=nil      # needed for lots of calls
  end
  
  def openClient
    if ( @client.nil? ) #&& !@user.nil? && !@password.nil? )
      @client = Savon.client( wsdl: TPWSDL )
    end
    
    if ( @client.nil? )
      puts( "TrainingPeaks.authenticateAccount:\tCan't open Client" )
    end
    
    @client
  end
  
  #
  # callTP depends on the client being open.  Be sure to check that outside of this function
  #
  def callTP( method, params=nil )
    msg = { username: @user, password: @password }
    msg = msg.each_with_object( params ) { |(k,v), h| h[k] = v } if !params.nil?
    resp = @client.call( method.to_sym, message: msg )
  end
  
  def authenticateAccount( aUser=nil, aPassword=nil )
    @user = aUser if !aUser.nil?; @password = aPassword if !aPassword.nil?
    
    if @client.nil?
      puts( "TrainingPeaks.authenticateAccount:\tClient class not available" )
    elsif ( @user.nil? || @password.nil? )
      puts( "TrainingPeaks.authenticateAccount:\tCan't authenticate without user and password non-nil" )
    else
      resp = callTP( :authenticate_account )
      @guid = resp.body[:authenticate_account_response][:authenticate_account_result]  
    end
    
    !@guid.nil?   # if guid is non-nil, it worked!
  end
  
  def getAccessibleAthletes( athTypes= 
    [ # "CoachedPremium",         # TODO: adding this selector returns null results
      "SelfCoachedPremium", 
       "SharedSelfCoachedPremium",
       "SharedCoachedPremium",
       "CoachedFree",
       "SharedFree",
       "Plan"
     ] )
    athletes=nil
    
    if !@client.nil?
      resp = callTP( :get_accessible_athletes, { types: athTypes } )
      athletes = resp.body[:get_accessible_athletes_response][:get_accessible_athletes_result]
    end
    
    @athletes = athletes
  end
  
  #
  # reads array of accessible athletes for the account, @user to find the matching athlete with username
  # returns the personID for that athlete
  # if username is nil, will attempt to match an athlete where username == @user
  #
  def usePersonIDfromUsername( username=nil )
    id = nil
    
    matchuser = username.nil? ? @user : username

    if @athletes.nil? 
      getAccessibleAthletes() 
    end
    
    if @athletes.length() != 1
      puts( "TrainingPeaks.getPersonID:\tathletes has length other than 1")
    end
    
    person = @athletes[:person_base]
    if person[:username] == matchuser
      id = person[:person_id]
    end
      
    @personID = id
  end
  
  #
  # retrieves historical or future scheduled workouts for the current personID (set with usePersonIDfromUsername)
  # for date range.  dates are of format YYYY-MM-DD, e.g. "2014-10-24"
  #
  def getWorkouts( start, stop )
    workouts = nil 
    
    if ( @personID.nil? )
      # personID not set... try for current user
      usePersonIDfromUsername()
    end
    
    resp = callTP( :get_workouts_for_accessible_athlete,
        { personId: @personID, startDate: start, endDate: stop } )
  
          
    workouts = resp.body[:get_workouts_for_accessible_athlete_response][:get_workouts_for_accessible_athlete_result][:workout]      
  end
end
