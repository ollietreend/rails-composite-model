require 'net/http'

class TeacherTrainingCoursesApi
  BASE_URL = "https://api.publish-teacher-training-courses.service.gov.uk/api/public/v1"

  def self.get(endpoint)
    response = Net::HTTP.get(uri(endpoint))
    JSON.parse(response)
  end

private

  def self.uri(endpoint)
    URI("#{BASE_URL}/#{endpoint}")
  end

end
