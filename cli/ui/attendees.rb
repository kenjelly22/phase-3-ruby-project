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

    def update_attendee
      view_all_attendees
      print "\nEnter the ID of the attendee to update: "
      id = gets.chomp.to_i

      current_attendee = api_client.get_attendee(id)
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

      response = api_client.change_attendee(id, data)

      if response[:error]
        puts "Error: #{response[:error]}"
      else
        puts "Attendee updated successfully!"
        display_attendee(response)
      end
    end

    def delete_attendee
      view_all_attendees
      print "\nEnter the ID of the attendee to delete: "
      id = gets.chomp.to_i

      print "Are you sure you want to delete this attendee? (y/n): "
      confirmation = gets.chomp.downcase

      if %w[y yes].include?(confirmation)
        response = api_client.remove_attendee(id)

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

      current_attendee = api_client.get_attendee(attendee_id)
      if current_attendee[:error]
        puts "Error: #{current_attendee[:error]}"
      else
        view_all_concerts
        print "\nEnter the ID of the concert the attendee purchased ticket for: "
        concert_id = gets.chomp.to_i

        response = api_client.add_ticket(attendee_id, concert_id)

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

      current_attendee = api_client.get_attendee(attendee_id)
      if current_attendee[:error]
        puts "Error: #{current_attendee[:error]}"
        return
      end

      print "\nEnter the ID of the concert the attendee sold their ticket for: "
      concert_id = gets.chomp.to_i

      print "Are you sure you want to delete this ticket? (y/n): "
      confirmation = gets.chomp.downcase

      if %w[y yes].include?(confirmation)
        response = api_client.remove_ticket(attendee_id, concert_id)

        if response[:error]
          puts "Error: #{response[:error]}"
        else
          puts "Ticket successfully deleted."
        end
      else
        puts "Deletion cancelled."
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
