#require 'trainingpeaks'

tp= TrainingPeaks.new

# set username and password before calling script
isGood= tp.authenticateAccount(username,password)
puts( "account is good " + isGood.to_s )

workouts= tp.getWorkouts('2014-10-17','2014-10-24')
#puts( "got workouts: " + workouts.to_s )
workouts.map{|w| puts( w[:workout_id] + " " + w[:workout_day].to_s + " " + w[:workout_type_description] + " " + w[:time_total_in_seconds].to_s )}

tp.saveWorkoutDataToFile( workouts.last[:workout_id], "test.pwx" )
puts("check test.pwx")
