
# Some simple utils for emptying and re-creating
# directories and creating folders by date for 
# harvested images

def reset_dir(pathname)
	puts "    Deleting and recreating #{pathname} folder"
	FileUtils.rm_rf(pathname) unless not Dir.exist?(pathname)
	Dir.mkdir(pathname)
end

def create_image_dir(folderName)
	fullFolder = "harvested_images/" + folderName
	FileUtils.mkdir(fullFolder) unless Dir.exist?(fullFolder)
end