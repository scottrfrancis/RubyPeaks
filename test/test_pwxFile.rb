#require 'trainingpeaks'

pf = PWXFile.new()

#testFile = '963.pwx'
testFile = "195102461.pwx"
pf.loadFile( testFile )

summ = pf.getSummary
puts summ.inspect

segs = pf.getSegments
puts segs.inspect

samps = pf.getSamples
puts samps.inspect
[0..9].each do |i|
  puts samps[i].inspect
end
