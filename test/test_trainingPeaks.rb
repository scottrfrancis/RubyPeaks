#require 'trainingpeaks'

tp= TrainingPeaks.new

isGood= tp.authenticateAccount('scottrfrancis','66Runn!!')
puts( "account is good " + isGood.to_s )

workouts= tp.getWorkouts('2014-10-17','2014-10-24')
puts( "got workouts: " + workouts.to_s )

tp.saveWorkoutDataToFile( workouts.last[:workout_id], "test.pwx" )
puts("check test.pwx")
