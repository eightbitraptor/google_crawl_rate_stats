#!/usr/bin/env ruby

require 'date'
require 'rubygems'
require 'net/http'
require 'activerecord'

require 'models/google_visit'
require 'db_connection'

class googleRateMonitor
  #(1..28).each do |num|
    @server='localhost'
    @date = (Date.today-1).strftime("%Y%m%d")
    @filename="/merged/merged.access.#{@date}"
    @carry_on = true

    def get_logfile(logfile)
      Net::HTTP.start("#{@server}") do |http|
        files= [#{logfile}.log.tar.gz, #{logfile}.log]
      
        files.each do |f|
          resp = http.get(f)
          if resp.is_a? Net::HTTPSuccess and f.include?(".tar.gz")
            open("/tmp/temp.log.gz","wb") do |file|
              file.write(r.body)
            end
          elsif resp.is_a? Net::HTTPSuccess and f.include?(".tar.gz") == false
            open("/tmp/temp.log","wb") do |file|
              file.write(r.body)
            end
          elsif resp.is_a? Net::HTTPNotFound and @carry_on 
            @date = (Date.today).strftime("%Y%m00")
            @carry_on = false
            get_logfile
          else
            raise "Error"
          end
        end
    end

    def unzip_logfile
      raise "file could not be unzipped correctly" unless
        `gunzip /tmp/temp.log.gz`
    end

    def count_googlebot(date)
      visits=`grep Googlebot /tmp/temp.log | wc -l`
      p=GoogleVisit.new(:date => "#{date}", :visits => "#{visits}")
      raise "insert failed" unless p.save
    end

    def cleanup
      `rm /tmp/temp.log`
    end

end

g=googleRateMonitor.new 
puts @filename
g.get_logfile(@filename)
g.unzip_logfile if @filename.includes? "tar.gz"
g.count_googlebot(@date)
g.cleanup
#end