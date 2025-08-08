require "rest-client"
require "json"
require_relative "api_client"
require_relative "ui/attendees"
require_relative "ui/concerts"

class CLIInterface
  def initialize
    @api_client = APIClient.new
    @attendees_ui = UI::Attendees.new
    @concerts_ui = UI::Concerts.new
  end

  def display_menu
    puts "\n=== Concert Tracker CLI ==="
    puts "1. View all concerts"
    puts "2. View all attendees"
    puts "3. Create a new concert"
    puts "4. Create a new attendee"
    puts "5. Update a concert"
    puts "6. Update an attendee"
    puts "7. Delete a concert"
    puts "8. Delete an attendee"
    puts "9. Add an attendee ticket"
    puts "10. Delete an attendee ticket"
    puts "q. Quit"
    print "\nEnter your choice: "
  end

  def run
    puts "Welcome to the Concert Tracker CLI!"
    puts "This application connects to your Sinatra API."
    puts "Make sure your API server is running on http://localhost:9292"
    puts

    loop do
      display_menu
      choice = gets.chomp.downcase

      case choice
      when "1"
        @concerts_ui.view_all_concerts
      when "2"
        @attendees_ui.view_all_attendees
      when "3"
        @concerts_ui.create_concert
      when "4"
        @attendees_ui.create_attendee
      when "5"
        @concerts_ui.update_concert
      when "6"
        @attendees_ui.update_attendee
      when "7"
        @concerts_ui.delete_concert
      when "8"
        @attendees_ui.delete_attendee
      when "9"
        @attendees_ui.add_attendee_ticket
      when "10"
        @attendees_ui.delete_attendee_ticket
      when "q", "quit", "exit"
        puts "Goodbye!"
        break
      else
        puts "Invalid choice. Please try again."
      end
    end
  end
end

CLIInterface.new.run if __FILE__ == $0
