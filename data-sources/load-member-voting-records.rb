# Purpose: Acquire councillor voting record CSV files from the voting page, where
# it can be scraped for data relating to items. 

# Uses: http://app.toronto.ca/tmmis/getAdminReport.do?function=getMemberVoteReport&download=csv&memberId=15

# This is required to download remote files. It's part of the ruby standard library.'
require 'open-uri'
# This is required to parse the dates properly
require 'chronic'
# This is required to process CSV files automatically
require 'csv'

Person.all.each do |person|
    puts "Downloading the report for #{person.name}..."
    csv_voting_record = open("http://app.toronto.ca/tmmis/getAdminReport.do?function=getMemberVoteReport&download=csv&memberId=#{person.municipal_id}").read 
    puts "Download complete."
    puts "The number of lines in this report is: #{csv_voting_record.lines.count}" 
    
    Item.all.each do |item|
        vote_results = csv_voting_record.scan /(^.*?,"#{Regexp.escape(item.item_number)}",.*?$)/
        vote_results.each do |vote|
            vote = vote[0].parse_csv
            # The CSV column headers are: 
            # 0. Committee name
            # 1. Vote date
            # 2. Vote agenda ID
            # 3. Vote title
            # 4. Motion
            # 5. Vote ("Yes", "No" or "Absent")
            # 6. Carried or lost? Plus, the vote ratio.
            # 7. Some extra metainformation
            
            
            #puts "Investigating vote for agenda item #{item.item_number}, motion '#{vote[4]}'..."
            
            # For now we will only consider if the vote was to adopt the item.
            if /^Adopt/ =~ vote[4] 
                puts "Motion to adopt #{item.item_number}"
                # Create a new vote, or pick it up from the DB if it exists already
                v = person.votes.find_by_item_id item.id
                v = person.votes.new if v.nil?
                
                if item.vote_date.nil? || item.vote_date > Chronic.parse(vote[1])
                    puts "Most recent vote, recording..."
                    # Record the vote
                    v.vote = vote[5]
                    # Update the vote completion date for the item
                    item.vote_date = Chronic.parse(vote[1])
                    # Set the item, in case this vote is new and doesn't have one yet
                    v.item_id = item.id
                    # Save and go to the next one.
                    v.save
                end
                
            end
        end
    end
    
end