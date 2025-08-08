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
        delete_concert
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

  def delete_concert
    view_all_concerts
    print "\nEnter the ID of the concert to delete: "
    id = gets.chomp.to_i

    print "Are you sure you want to delete this concert? (y/n): "
    confirmation = gets.chomp.downcase

    if %w[y yes].include?(confirmation)
      response = @api_client.remove_concert(id)

      if response[:error]
        puts "Error: #{response[:error]}"
      else
        puts "Concert deleted successfully!"
      end
    else
      puts "Deletion cancelled."
    end
  end

  def display_concert(concert)
    puts "Concert ID:  #{concert['id']}"
    puts "Band Name: #{concert['band_name']}"
    puts "Event Date: #{concert['event_date']}"
    puts "Venue: #{concert['venue']}"
    puts "City: #{concert['city']}"

    if concert["attendees"]&.any?
      puts "Attendees:"
      concert["attendees"].each do |attendee|
        puts " - #{attendee['name']}"
      end
    else
      puts " - No attendees yet"
    end
  end
end

CLIInterface.new.run if __FILE__ == $0
