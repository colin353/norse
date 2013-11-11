class PersonController < ApplicationController
    # This controller is for showing people, e.g. elected officials.
    
   def index
       # Show a big list of people
       @people = Person.all
   end 
   
   def view
       # Show a big list of people
       @person = Person.find params[:id]
       @rob = Person.first
       @paul = Person.find 3
   end
   
end
