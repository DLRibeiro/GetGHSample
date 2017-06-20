require 'octokit'
require_relative "WriteResult"

class GHSearch

	def initialize(login, password, language, numberForks, numberStars, pushed, contributors)
		@login = login
		@password = password
		@language = language
		@numberForks = numberForks
		@numberStars = numberStars
		@pushed = pushed
		@contributors = contributors
		@writeResult = WriteResult.new()
	end

	def runSearch()
		print("language = #{@language}, pushed at = #{@pushed}, numerStars = #{@numberStars}\n")
		client = runAuthentication()
		queryGeneral = "language:#{@language} forks:\">#{@numberForks}\" stars:\">#{@numberStars}\" pushed:\">=#{@pushed}\""
		results = client.search_repositories(queryGeneral,:per_page => 100)
		total_count = results.total_count

		last_response = client.last_response
		number_of_pages = last_response.rels[:last].href.match(/page=(\d+).*$/)[1]

		puts "There are #{total_count} results, on #{number_of_pages} pages!"
		puts "And here's the first path for every set"
		puts last_response.data.items.first.path

		until last_response.rels[:next].nil?
			last_response = last_response.rels[:next].get
			#sleep 4 # back off from the API rate limiting; don't do this in Real Life
			break if last_response.rels[:next].nil?
			last_response.data.items.each do |project|
				name = project["full_name"]
				contributorsList = client.contributors_stats(name)
				numberContributors = contributorsList.length
				if (numberContributors >= @contributors.to_i)
					queryByFileName = "in:path repo:#{name} filename:routes.rb"
					queryResult = client.search_code(queryByFileName)

					if (queryResult.total_count > 0)
						print name #debugging
						print " number of contributors= #{numberContributors}\n" #debugging
						print "\n"
						@writeResult.writeNewProject(name.to_s)
						@writeResult.writeProjectMetrics(name.to_s, project["forks_count"].to_s, project["stargazers_count"].to_s, @pushed, numberContributors )
						#sleep 4
					end
				end
				#end
				#sleep 10
			end
		end
		@writeResult.closeProjectListFile()
	end

	def runAuthentication()
		return Octokit::Client.new \
	  		:login    => @login,
				:password => @password
	end

end
