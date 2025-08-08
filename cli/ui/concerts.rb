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
  end
end
