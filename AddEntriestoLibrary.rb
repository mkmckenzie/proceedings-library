require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'capybara'
require 'csv'
require_relative 'myswana'


class MakeEntry
  def initialize(file_with_info)
    @file_with_info = file_with_info
    @session = Capybara::Session.new(:selenium)
    MySWANA.login(@session)  
  end

  def add_one_entry_to_library(session_title, description)
    @session.click_button('Create New Library Entry')
    @session.fill_in('Title', :with => session_title)
    @session.click_button('Tools')
    @session.find('#mceu_36-body').click
    @session.find(".mce-textbox").set description
    @session.click_button('Ok')
    @session.select('Standard File Upload', :from => 'Entry Type')
    @session.click_button('Next')    
  end

  def go_through_file
    CSV.foreach(@file_with_info, :headers => true) do |row|
      link = determine_library_link(row[2])
      unless link == "Not Valid"
        @session.visit link
        add_one_entry_to_library(row[0], row[1].encode('UTF-8', :invalid => :replace, :undef => :replace))
      end
    end
  end

  def determine_library_link(session_track)
    link = if session_track.include?("LGB")
            "http://community.swana.org/communities/community-home/librarydocuments?LibraryKey=6096642f-fe87-45dc-b678-ba39436fb3ad"
          elsif session_track.include?("LF")
            "http://community.swana.org/communities/community-home/librarydocuments?LibraryKey=d7064fad-ca73-45b2-b65f-fc08612987d5"
          elsif session_track.include?("RTZW")
            "http://community.swana.org/communities/community-home/librarydocuments?LibraryKey=a75594bf-1f7c-428d-9e73-7dc90763f661"
          elsif session_track.include?("LMOP")
            "http://community.swana.org/communities/community-home/librarydocuments?LibraryKey=813e4304-dd56-42e7-819b-5e833b001905"
          else
            "Not Valid"
          end
  end
end


`iconv -c -t utf8 info-from-page.csv > info-from-page.utf8.csv`
library = MakeEntry.new('info-from-page.utf8.csv')
library.go_through_file



