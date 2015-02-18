#!/usr/bin/env ruby

require 'rss'
require "json"

def addpodcast(filename,url)
  urls = Array.new()
  if File.exist?(filename) then
    File.open(filename,"r") do |file|
      urls =  JSON.parse(file.read)
      urls.push(url)
      urls.uniq!
    end

    File.open(filename,"w") do |file|
      file.puts JSON.dump(urls)
    end

  else
    urls = [url]
    File.open(filename,"w") do |file|
      file.puts  JSON.dump(urls)
    end
  end
end

def viewpodcast(filename)
  urls = Array.new()
  if File.exist?(filename) then
    File.open(filename,"r") do |file|
      urls =  JSON.parse(file.read)
    end
  end

  urls.each_with_index{|podcast , index|
    rss = RSS::Parser.parse(podcast)
    print "\e[35m"
    print "No.#{index+1}"
    puts "\e[0m"
    puts "Title:\t\t" + rss.channel.title.gsub(/(\s)/,"")
    	puts "Description:\t" + rss.channel.description.gsub(/(\s)/,"")
  }
    puts
  print "\e[35m"
  print "何番のポッドキャストを聞きますか？(半角数字のみ)："  
  print "\e[0m"
  num = gets.chomp
  urls[num.to_i - 1 ]
end

def viewItems(url)
  rss = RSS::Parser.parse(url)
  rss.items.each_with_index{|item , index|
    print "\e[35m"
if  (defined? (item.enclosure.url) )
    print "No.#{index+1}"
else 
    print "No.#{index+1}"
    print "\e[33m"
    print "音声ファイルがないようです。。"
end
puts "\e[0m"
    puts "Title:\t\t" + item.title.gsub(/(\s)/,"")
    puts "Description:\t" + item.description.gsub(/(\s)/,"")
  }
    puts
  print "\e[35m"
  print "何番のエピソードを聞きますか？(半角数字のみ)："  
  print "\e[0m"
  num = gets.chomp
 rss.items[num.to_i - 1 ].enclosure.url
end

filename = File.expand_path('~') + "/.Podterm/urls";
tmpurl = File.expand_path('~') + "/.Podterm/mp3url";

if ARGV[0] == nil then
    url = viewpodcast(filename)
    mp3url = viewItems(url)
    File.open(tmpurl,"w") do |file|
            file.puts mp3url
    end
else
   addpodcast(filename,ARGV[0])
end


