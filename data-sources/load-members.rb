# Purpose: Get the list of all the councillors from the Toronto website
# and add them into the database. Also scrape for other personal
# information.
#
# Uses: http://app.toronto.ca/im/council/councillors.jsp

# This is required to download remote files. It's part of the ruby standard library.'
require 'open-uri'

# Download the list of members. It comes back as a bunch of HTML
puts 'Downloading list of councillors...'
members_list = '';
members_list = open('http://app.toronto.ca/im/council/councillors.jsp').read
puts 'Download complete.'

# Regular expression tested at: 
# http://rubular.com/
result = members_list.scan /<td valign="top" align="left"><font face="Arial,Helvetica,sans-serif" size="2"><a href="(.+)">(.+)<\/a><br>\s+<font face="Arial,Helvetica,sans-serif" size="1"><a href=".+">(.*?)<\/a>/

result.each do |match|
   # Each member should be a result, with two parts:
   #    1. The member's web URL for their personal page
   #    2. The member's name
   #    3. The member's ward's name
   
   # Check to see if we already have a person by that name
   person = Person.find_by_name match[1]
   # if not, we'll make a new person.
   person = Person.new if person.nil?
   
   person.name = match[1]
   person.website = match[0]
   person.title = 'Councillor for ' + match[2]
   person.save
end

