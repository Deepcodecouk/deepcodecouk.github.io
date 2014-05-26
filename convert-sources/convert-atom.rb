require "date"
require "rexml/document"
require "FileUtils"
require "./file_helpers"
require "colorize"
require "Nokogiri"

class BlogPost
	attr_accessor :title, :published, :body, :tags
	
	@title = ""
	@published = DateTime.new
	@body = ""
	@tags = []
	
	def getFilename
		"%4d-%02d-%02d-%s" % [@published.year, @published.month, @published.day, @title.downcase.strip.gsub(" ", "-").gsub(/[^\w-]/, "")]
	end

	def getHtmlFilename
		"raw_html/%s.html" % [getFilename]
	end

	def getMarkdownFilename
		"outputs/%s.markdown" % [getFilename]
	end

	def writeOctopressHeader(f)
=begin
		---
		layout: post
		title: "Moving my blog to github pages"
		date: 2014-05-11 18:23:38 +0100
		comments: true
		categories: blogging
		---
=end
		f.puts("---")
		f.puts("layout: post")
		f.puts("title: \"%s\"" % [title.gsub("\"", "\'")])
		f.puts("date: %s" % [published.strftime("%Y-%m-%d %H:%M:%S %z")])
		f.puts("comments: true")
		f.puts("categories: %s" % [tags.join(",")])
		f.puts("---")

#title: Day 2 - 15:15 : How LINQ works: A deep dive into the C# implementation of LINQ.
#date: 2008-11-11T21:23:00+00:00
#categories: ["Tech-Ed", "LINQ", ".NET General"]
	end
end

def convert_posts(localImages)
	# Delete and recreate working folders
	puts "> Setting up folders"
	reset_dir "raw_html"
	reset_dir "outputs"

	# Open the atom file
	puts "> Loading ATOM articles"
	xml_data = File.read("ArgumentException.atom")
	atom = REXML::Document.new(xml_data)

	# Find posts only
	posts = []
	atom.elements.each('/feed/entry') do |entry|
		
		# Ensure this entry is a post and add to the list
		if entry.elements["category[@term='http://schemas.google.com/blogger/2008/kind#post']"] 

			post = BlogPost.new
			post.title = entry.elements["title"].text
			post.published = DateTime.parse entry.elements["published"].text
			post.body = entry.elements["content"].text
			post.tags = []

			entry.elements.each("category[@scheme='http://www.blogger.com/atom/ns#']") do | category |
				post.tags << category.attributes["term"]
			end

			posts << post
		end
	end
	puts "  Parsed %d posts" % [posts.length]

	# Enumerate each entry and create the raw html file
	puts "> Writing HTML articles"
	posts.each do |post|
		puts "    Title = #{post.title}"

		# do a gsub on the body to replace any known image urls
		localImages.each do |img|
			if post.body.gsub!(img.original, img.htmlFull) != nil
				puts "      Image replace #{img.original} with #{img.htmlFull}".yellow
			end
		end

		# find all images with a hyperlink, remove the hyperlink
		doc = Nokogiri::HTML(post.body)
		imagesWithLinks = 0
		doc.css("a img").each do | imageInLink |
			imageInLink.parent.swap(imageInLink)
			imagesWithLinks = imagesWithLinks + 1
		end
		puts "          Replaced #{imagesWithLinks} links on images".cyan unless imagesWithLinks == 0

		post.body = doc.to_s

		File.open(post.getHtmlFilename(), "w") do |file|
			file.write(post.body)
		end
	end
	puts "  Done"

	# Shell pandoc to convert to markdown
	# eg: pandoc -s -r html 2007-03-05-fluxnet-cms-v20-released.html -o sample.markdown
	puts "> Shelling out to pandoc for each article"
	posts.each do |post|
		puts "  Doing #{post.title}"
		htmlfile = post.getHtmlFilename
		markdownfile = post.getMarkdownFilename
		` pandoc -s -r html #{htmlfile} -o #{markdownfile}`
	end

	# Add octopress headers to each markdown post
	puts "> Appending octopress headers to posts"
	posts.each do |post|
		
		puts "  Writing #{post.title}"

		markdown = File.read(post.getMarkdownFilename())

		# overwrite the file
		File.open(post.getMarkdownFilename(), "w") do |file|
			post.writeOctopressHeader(file)
			file.write(markdown)
		end
	end

	puts ".....all done"
end




