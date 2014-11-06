#require 'trainingpeaks'

pf = PWXFile.new()

testFile = '963.pwx'
pf.loadFile( testFile )

summ = pf.getSummary
puts summ.inspect

segs = pf.getSegments
puts segs.inspect
