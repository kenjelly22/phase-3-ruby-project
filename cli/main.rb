require "rest-client"
require "json"
require_relative "api_client"

class CLIInterface
  def initialize
    @api_client = APIClient.new
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
    puts "Welcome to the Pet Tracker CLI!"
    puts "This application connects to your Sinatra API."
    puts "Make sure your API server is running on http://localhost:9292"
    puts

    loop do
      display_menu
      choice = gets.chomp.downcase

      case choice
      when "1"
        view_all_concerts
      when "2"
        view_all_attendees
      when "3"
        create_concert
      when "4"
        create_attendee
      when "5"
        update_concert
      when "6"
        update_attendee
      when "7"
        delete_concert
      when "8"
        delete_attendee
      when "9"
        add_attendee_ticket
      when "10"
        delete_attendee_ticket
      when "q", "quit", "exit"
        puts "Goodbye!"
        break
      else
        puts "Invalid choice. Please try again."
      end
    end
  end

  private

  def view_all_concerts
    puts "\n=== All Concerts ==="
    response = @api_client.get_concerts

    return unless response.is_a?(Array)

    if response.empty?
      puts "No concerts found"
    else
      response.each do |concert|
        display_concert(concert)
        puts "-" * 50
      end
    end
  end

  def view_all_attendees
    puts "\n=== All Attendees ==="
    response = @api_client.get_attendees

    return unless response.is_a?(Array)

    if response.empty?
      puts "No attendees found"
    else
      response.each do |attendee|
        display_attendee(attendee)
        puts "-" * 50
      end
    end
  end

  def create_concert
    puts "\n=== Create New Concert ==="

    print "Band Name: "
    band_name = gets.chomp

    print "Event Date: "
    event_date = gets.chomp

    print "Venue: "
    venue = gets.chomp

    print "City (city, state): "
    city = gets.chomp

    data = {
      band_name: band_name,
      event_date: event_date,
      venue: venue,
      city: city,
    }

    response = @api_client.new_concert(data)
    if response[:error]
      puts "Error: #{response[:error]}"
    else
      puts "Concert created successfully!"
      display_concert(response)
    end
  end

  def create_attendee
    puts "\n=== Create New Attendee ==="

    print "Name: "
    name = gets.chomp

    data = { name: name }

    response = @api_client.new_attendee(data)
    if response[:error]
      puts "Error: #{response[:error]}"
    else
      puts "attendee created successfully!"
      display_attendee(response)
    end
  end

  def update_concert
    view_all_concerts
    print "\nEnter the ID of the concert to update: "
    id = gets.chomp.to_i

    current_concert = @api_client.get_concert(id)
    if current_concert[:error]
      puts "Error: #{current_concert[:error]}"
      return
    end

    puts "\nCurrent Concert Data:"
    display_concert(current_concert)

    puts "\nEnter new values (press Enter to keep current value):"

    print "Band Name: (#{current_concert['band_name']})"
    band_name = gets.chomp
    band_name = current_concert["band_name"] if band_name.empty?

    print "Event Date (YYYY-MM-DD): (#{current_concert['event_date']})"
    event_date = gets.chomp
    event_date = current_concert["event_date"] if event_date.empty?

    print "Venue: (#{current_concert['venue']})"
    venue = gets.chomp
    venue = current_concert["venue"] if venue.empty?

    print "City (city, state): (#{current_concert['city']})"
    city = gets.chomp
    city = current_concert["city"] if city.empty?

    data = {
      band_name: band_name,
      event_date: event_date,
      venue: venue,
      city: city,
    }

    response = @api_client.change_concert(id, data)

    if response[:error]
      puts "Error: #{response[:error]}"
    else
      puts "Concert updated successfully!"
      display_concert(response)
    end
  end

  def update_attendee
    view_all_attendees
    print "\nEnter the ID of the attendee to update: "
    id = gets.chomp.to_i

    current_attendee = @api_client.get_attendee(id)
    if current_attendee[:error]
      puts "Error: #{current_attendee[:error]}"
      return
    end

    puts "\nCurrent Attendee Data:"
    display_attendee(current_attendee)

    puts "\nEnter new values (press Enter to keep current value):"

    print "Name: (#{current_attendee['name']})"
    name = gets.chomp
    name = current_attendee["name"] if name.empty?

    data = { name: name }

    response = @api_client.change_attendee(id, data)

    if response[:error]
      puts "Error: #{response[:error]}"
    else
      puts "Attendee updated successfully!"
      display_attendee(response)
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

  def delete_attendee
    view_all_attendees
    print "\nEnter the ID of the attendee to delete: "
    id = gets.chomp.to_i

    print "Are you sure you want to delete this attendee? (y/n): "
    confirmation = gets.chomp.downcase

    if %w[y yes].include?(confirmation)
      response = @api_client.remove_attendee(id)

      if response[:error]
        puts "Error: #{response[:error]}"
      else
        puts "Attendee deleted successfully!"
      end
    else
      puts "Deletion cancelled."
    end
  end

  def add_attendee_ticket
    view_all_attendees
    print "\nEnter the ID of the attendee who purchased a ticket: "
    attendee_id = gets.chomp.to_i

    current_attendee = @api_client.get_attendee(attendee_id)
    if current_attendee[:error]
      puts "Error: #{current_attendee[:error]}"
    else
      view_all_concerts
      print "\nEnter the ID of the concert the attendee purchased ticket for: "
      concert_id = gets.chomp.to_i

      response = @api_client.add_ticket(attendee_id, concert_id)

      if response[:error]
        puts "Error: #{response[:error]}"
      else
        puts "Ticket successfully added!"
      end

    end
  end

  def delete_attendee_ticket
    view_all_attendees
    print "\nEnter the ID of the attendee who sold their ticket: "
    attendee_id = gets.chomp.to_i

    current_attendee = @api_client.get_attendee(attendee_id)
    if current_attendee[:error]
      puts "Error: #{current_attendee[:error]}"
      return
    end

    print "\nEnter the ID of the concert the attendee sold their ticket for: "
    concert_id = gets.chomp.to_i

    print "Are you sure you want to delete this ticket? (y/n): "
    confirmation = gets.chomp.downcase

    if %w[y yes].include?(confirmation)
      response = @api_client.remove_ticket(attendee_id, concert_id)

      if response[:error]
        puts "Error: #{response[:error]}"
      else
        puts "Ticket successfully deleted."
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

  def display_attendee(attendee)
    puts "Attendee ID: #{attendee['id']}"
    puts "Name: #{attendee['name']}"

    if attendee["concerts"]&.any?
      puts "Concerts:"
      attendee["concerts"].each do |concert|
        puts " - Concert ID: #{concert['id']} - #{concert['band_name']} - #{concert['event_date']}"
      end
    else
      puts " - No concerts yet"
    end
  end
end

CLIInterface.new.run if __FILE__ == $0
