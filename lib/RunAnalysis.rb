require_relative 'GHSearch'

parameters = []
File.open("properties", "r") do |text|
	indexLine = 0
	text.each_line do |line|
		parameters[indexLine] = line[/\<(.*?)\>/, 1]
		print "lendo file = #{parameters[indexLine]}\n"
		indexLine += 1
	end
end

print "array size = #{parameters.length}\n"

search = GHSearch.new(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6])
#print "language = #{parameters[2]}, pushed_at = #{parameters[5]}, stars = #{parameters[4]}\n"
search.runSearch()