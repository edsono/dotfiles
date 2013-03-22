#!/usr/bin/ruby
=begin
Usage: rtftomarkdown.rb FILENAME.rtf

Uses textutil, available on Mac only (installed by default)
Outputs to STDOUT

Notes:

Links are replaced with Markdown references (duplicate links combined).
This works fine on RTF files, but the markup that the Word/textutil
combination produces seems impossible to work with. Most links disappear
when converting from a DOC or DOCX file, and even Word's RTF export is
unworkable.

List levels converted by textutil can not be changed at a given depth.
If you start a second-level nested list as an ordered list, the next
second-level list will be ordered. It's a textutil/RTF thing.
=end
write_file = false # for Services set to true to write out files with .md extension

if ARGV.length == 0
	puts "#{__FILE__} expects an input file (RTF or DOC) as an argument"
	exit
end

def remove_empty(input)
	input.gsub!(/(<(\w+)( class=".*?")?>\s*<\/\2>)/,'')
	input = remove_empty(input) if input =~ /(<(\w+)( class=".*")?>\s*<\/\2>)/
	return input.strip
end

ARGV.each do |infile|
	file = infile.sub(/\/$/,'')
	if File.exists?(File.expand_path(file))
		ext = file.match(/\.(\w+)$/)[1]
		input = %x{/usr/bin/textutil -convert html -stdout "#{file}"}.strip


		input.gsub!(/.*?<body>(.*?)<\/body>.*/m,"\\1")

		# remove span/br tags, unneccessary
		input.gsub!(/<br>/,'')
		input.gsub!(/<\/?span( class=".*?")?>/,'')

		# substitute headers
		input.gsub!(/<p class="p1">(?:<b>)?(.+?)(?:<\/b>)?<\/p>/,'# \\1')
		input.gsub!(/<p class="p2"><b>(.+?)<\/b><\/p>/,'## \\1')
		input.gsub!(/<p class="p3"><b>(.+?)<\/b><\/p>/,'## \\1')
		input.gsub!(/<p class="p4"><b>(.+?)<\/b><\/p>/,'### \\1')
		input.gsub!(/<p class="p5"><b>(.+?)<\/b><\/p>/,'### \\1')

		input = input.split("\n").map { |line|
			remove_empty(line)
		}.join("\n")

		# remove paragraph tags
		input.gsub!(/<p class="p\d">(.*?)<\/p>/,'\\1')
		# emphasis
		input.gsub!(/<\/?b>/,'**')
		input.gsub!(/<\/?i>/,'*')
		# links
		links = {}
		footer = ''
		input.gsub!(/<a href="(.*?)">(.*?)<\/a>/) do |match|
			if links.has_key? $1
				marker = links[$1]
			else
				links[$1] = links.length + 1
				footer += "\n[#{links[$1]}]: #{$1}"
			end
			"[#{$2}][#{links[$1]}]"
		end

		input = input.split("\n").map { |line|
			line.strip
		}.join("\n")

		# handle lists
		list_level = 0
		list_type = []
		input = input.split("\n").map { |line|
			if line =~ /<([uo])l.*?>/
				list_level += 1
				list_type[list_level] = $1 =~ /u/ ? "*" : "1."
				"*REMOVEME"
			elsif line =~ /<\/[uo]l>/
				list_level -= 1
				"*REMOVEME"
			else
				indent = ""
				(list_level -1).times do indent += "    " end
				line.gsub(/<li.*?>(.*?)<\/li>/,"#{indent}#{list_type[list_level]} \\1")
			end
		}.delete_if {|line|
			line =~ /\*REMOVEME/
		}.join("\n")

		if write_file
			open(file+".md", 'w+') { |f|
				f.puts input
				f.puts footer
			}
		else
			puts input
			puts footer
		end
	else
		puts "File not found: #{file}"
	end
end
