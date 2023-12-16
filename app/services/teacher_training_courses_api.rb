require 'net/http'

class TeacherTrainingCoursesApi
  BASE_URL = "https://api.publish-teacher-training-courses.service.gov.uk/api/public/v1"
  CACHE_REQUESTS_FOR = 1.hour

  def self.get(endpoint)
    request(method: :get, endpoint:)
  end

private

  def self.request(method:, endpoint:)
    key = cache_key(method:, endpoint:)
    response = Rails.cache.fetch(key, expires_in: CACHE_REQUESTS_FOR) do
      Net::HTTP.public_send method, uri(endpoint)
    end
    JSON.parse(response)
  end

  def self.cache_key(method:, endpoint:)
    endpoint_hash = Digest::MD5.hexdigest(endpoint)
    "#{name}_#{method}_#{endpoint_hash}"
  end

  def self.uri(endpoint)
    URI("#{BASE_URL}/#{endpoint}")
  end

end
