#!/usr/bin/ruby

# Set up empty array for targets
wavTargets = []
# Start to loop through all inputs
ARGV.each do |target|
	# Check to see if input is directory - if it is search for files ending in ".wav" and add them to targets
  if File.directory?(target)
    wavSearch = Dir.glob(target + "/**/*.wav")
    wavSearch.each {|foundWav| wavTargets << foundWav}
   #Otherwise check if input is a valid file that ends in '.wav' (and add it to targets if it is)
  elsif File.exist?(target) && File.extname(target) == '.wav'
    wavTargets << target
  else
  	puts "Skipping invalid target"
  end
end


# FFmpeg loop for targets discovered in previous loop
wavTargets.each do |target|
	# set up output file path to use in FFmpeg command
  outputDir = File.dirname(target)
  baseName = File.basename(target,".*")
  outputFile = outputDir + '/' + baseName + '.mp3'
  # FFmpeg command adapted from example at https://amiaopensource.github.io/ffmprovisr/#wav_to_mp3
  system('ffmpeg', '-i', target, '-write_id3v1', '1', '-id3v2_version', '3', '-dither_method', 'triangular', '-out_sample_rate', '48k', '-n', outputFile)
end

NOTE TO SELF ADD ARRAY TO CONFIRM ALL INPUTS WERE TARGETTED AND WARN OF ANY SKIPS OR ERRORS
