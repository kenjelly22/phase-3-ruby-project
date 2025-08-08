module UI
  class Concerts
    attr_reader :api_client

    def initialize
      @api_client = APIClient.new
    end

    def view_all_concerts
      puts "\n=== All Concerts ==="
      response = api_client.get_concerts

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

      response = api_client.new_concert(data)
      if response[:error]
        puts "Error: #{response[:error]}"
      else
        puts "Concert created successfully!"
        display_concert(response)
      end
    end

    def update_concert
      view_all_concerts
      print "\nEnter the ID of the concert to update: "
      id = gets.chomp.to_i

      current_concert = api_client.get_concert(id)
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

      response = api_client.change_concert(id, data)

      if response[:error]
        puts "Error: #{response[:error]}"
      else
        puts "Concert updated successfully!"
        display_concert(response)
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
end
