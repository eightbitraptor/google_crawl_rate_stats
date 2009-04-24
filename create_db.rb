#!/usr/bin/env ruby

require 'rubygems'
require 'activerecord'
require 'db_connection'

class CreateGoogleVisits < ActiveRecord::Migration
  def self.up
    create_table :google_visits do |t|
      t.column :date, :date
      t.column :visits, :int
    end
  end
  
  def self.down
    drop_table :GoogleVisits
  end
end

CreateGoogleVisits.migrate(:up)