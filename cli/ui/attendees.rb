module UI
  class Attendees
    attr_reader :api_client

    def initialize
      @api_client = APIClient.new
    end

    def view_all_attendees
      puts "\n=== All Attendees ==="
      response = api_client.get_attendees

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

    def create_attendee
      puts "\n=== Create New Attendee ==="

      print "Name: "
      name = gets.chomp

      data = { name: name }

      response = api_client.new_attendee(data)
      if response[:error]
        puts "Error: #{response[:error]}"
      else
        puts "attendee created successfully!"
        display_attendee(response)
      end
    end

    private

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
end
