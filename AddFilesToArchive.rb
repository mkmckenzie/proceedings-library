require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'capybara'
require_relative 'myswana'


class MoveDocs

  def initialize
    puts "Link to Library (file view)?"
    @link = gets.chomp
    puts "Moving from?:"
    @origin_folder = gets.chomp
    puts "Moving to?:"
    @destination_folder = gets.chomp
    

    @session = Capybara::Session.new(:selenium)     
    MySWANA.login(@session)
  end

  def add_one_file_to_archive(entry_number)
    print entry_number
    title_link = '.library-list:nth-child(' + entry_number.to_s + ') h3'

    @session.visit @link

    print @session.find(title_link)['innerHTML']
    @session.find(title_link).click
    
    @session.visit(URI.parse(current_url))
    @session.click_button('Actions', exact: false)
    @session.click_link('Edit')
    @session.click_button(@origin_folder)
    @session.find(:xpath,"//*[text()='#{@destination_folder}']").click
    @session.select('2015', :from => 'Folder')
    @session.click_button('Next')
    print "... Complete \n"
  end

  def add_all_files_to_archive 
    @session.visit @link
    elem = @session.find('#LibaryEntryCountDiv')['innerHTML']
    number_of_entries = elem.split[0].to_i

    number_of_entries.times do |entry_number|
        print entry_number
        add_one_file_to_archive(entry_number)
    end
    
  end

end


lfg = MoveDocs.new

#lfg.add_one_file_to_archive

#lfg.add_all_files_to_archive

#     http://community.swana.org/communities/community-home/librarydocuments?LibraryKey=d7064fad-ca73-45b2-b65f-fc08612987d5
#     5 - 2015 Landfill Symposium Proceedings
#     6 - Landfill Symposium Proceedings Archive



