# Purpose: Acquire their municipal internal ID from the voting page, where
# it can be scraped from a <SELECT> box. Using this procedure, we can
# later acquire their voting records.
#
# Uses: http://app.toronto.ca/tmmis/getAdminReport.do?function=prepareMemberVoteReport

# This is required to download remote files. It's part of the ruby standard library.'
require 'open-uri'

# Download the voting reporting page. It comes back as a bunch of HTML
puts 'Downloading voting record page...'
page = '';
page = open('http://app.toronto.ca/tmmis/getAdminReport.do?function=prepareMemberVoteReport').read
puts 'Download complete.'

# Regular expressions tested at: 
# http://rubular.com/

# First job is to get the <select> contents
html_select = page.scan /<select name="memberId">(.*?)<\/select>/m
# Now, get the individual results
matches = html_select[0][0].to_s.scan /<option value="(\d+)">(.*?)<\/option>/m
puts "Found #{matches.count} matches."
matches.each do |match|
    # The results are:
    # 1. Municipal ID
    # 2. Councillor name
    
    # First find out if we already have the councillor's name
    p = Person.find_by_name match[1]
    if p.nil?
        puts "Found nil councillor named #{match[1]}, ignoring..."
        next
    else 
        # The councillor exists. Now, update their municipal ID.
        p.municipal_id = match[0]
    end
    p.save
end

puts "... done."

