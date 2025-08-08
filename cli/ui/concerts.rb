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
  end
end
