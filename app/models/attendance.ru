class Attendance < ActiveRecord::Base
  belongs_to :person
  belongs_to :concert
end
