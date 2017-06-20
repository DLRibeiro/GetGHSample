require 'fileutils'
require 'csv'
require 'rubygems'

class WriteResult

	def initialize()
		@projectList = createProjectList()
		createCSVResult()
	end

	def createProjectList()
		return File.new("projectList.txt", "a+")
	end

	def writeNewProject(projectName)
		@projectList.puts("\"#{projectName}\"")
	end

	def closeProjectListFile()
		@projectList.close
	end

	def createCSVResult()
		CSV.open("ProjectMetrics.csv", "ab") do |csv|
			csv << ["ProjectName", "NumberForks", "NumberStars", "Minimum Pushed","NumberContributors"]
		end
	end

	def writeProjectMetrics(projectName, numberForks, numberStars, pushed, numberContributors)
		CSV.open("ProjectMetrics.csv", "ab") do |csv|
			csv << [projectName, numberForks, numberStars, pushed, numberContributors]
		end
	end

end