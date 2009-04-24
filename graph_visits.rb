#!/usr/bin/env ruby

require 'activerecord'
require 'rubygems'
require 'gruff'

require 'db_connection.rb'
require 'models/google_visit.rb'

[7,28,365].each do |interval|
  
  graph=Gruff::Bar.new('950x300')

  graph.title = "Daily Googlebot visits (#{interval} days)"

  graph.title_font_size=12
  graph.legend_font_size=10
  graph.marker_font_size=8
  graph.theme_greyscale
  graph.sort=false

  keys={}
  values=[]
  index=0
  
  GoogleVisit.find(:all, :order => :date, :conditions => {:date => (Date.today-interval)..Date.today }).each do |v|
    keys[index] = v.date.strftime("%d-%m")
    values << v.visits
    index+=1
  end

  graph.data("visits", values)
  graph.labels = keys

  Dir.mkdir('graphs') unless File.directory?('graphs')
  graph.write('./graphs/' + graph.title.gsub(' ','_') + "_#{interval}.png" )
end