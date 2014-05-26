require "date"
require "rexml/document"
require "FileUtils"
require "nokogiri"
require "URI"
require "open-uri"
require "colorize"
require "./file_helpers"


class BlogImage
	
	@@imageno = 1
	attr_accessor :original, :local, :folder

	@original = ""
	@local = ""
	@folder = ""

	def initialize(original, folder)

		@original = original
		@folder = folder

		urlFileName = URI.parse(original).path[%r{[^/]+\z}]
		extension = File.extname(urlFileName)
		@local = "image-%04d#{extension}" % [@@imageno]
		@@imageno = @@imageno + 1

    end

    def ==(img)

    	comp = @original <=> img.original
    	if( comp == 0 )
    		comp = @folder <=> img.folder
    	end

    	return comp == 0
    end

    def localFull
    	"harvested_images/" + @folder + "/" + @local
    end

    def htmlFull
    	"/assets/migrated/" + @folder + "/" + @local
    end

end


def do_harvest_images

	# Delete and recreate working folders
	puts "> Setting up folders"
	reset_dir "harvested_images"

	# Open the atom file
	puts "> Loading ATOM articles"
	xml_data = File.read("ArgumentException.atom")
	atom = REXML::Document.new(xml_data)

	# Find images in all posts
	images = []
	postCount = 0
	atom.elements.each('/feed/entry') do |entry|
	
		# Ensure this entry is a post and add to the list
		if entry.elements["category[@term='http://schemas.google.com/blogger/2008/kind#post']"] 

			postCount = postCount+1
			postedDate = DateTime.parse entry.elements["published"].text
			postFolder = postedDate.strftime("%Y-%m-%d")

			# Get all the image tags
			page = Nokogiri::HTML(entry.elements["content"].text)
			pageImages = page.css("img")
			
			pageImages.each do |i|


				trackImage = BlogImage.new( i['src'], postFolder)

				if not images.include?(trackImage)
					images << trackImage

					create_image_dir postFolder

					puts "> Downloading #{trackImage.original} to #{trackImage.localFull}"
					begin
=begin
						open(trackImage.original) do | f |
							File.open(trackImage.localFull, "wb") do | localFile |
								localFile.puts f.read
							end
						end
=end						
					rescue OpenURI::HTTPError => e
	  					if e.message == '404 Not Found'
	    					# handle 404 error
	    					puts "     404 not found".red
						else
							raise e
						end
					end
				end
			end
		end
	end

	puts "  Parsed #{postCount} posts and downloaded #{images.length} images"
	images
end
