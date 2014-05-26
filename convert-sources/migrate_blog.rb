
require "./harvest_images"
require "./convert-atom"


images = do_harvest_images

convert_posts images

	# TODO: Comment migration to disqus?
