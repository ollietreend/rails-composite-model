class External::Provider
  ATTRIBUTES = %i[code name email website ukprn]

  attr_reader *ATTRIBUTES

  def initialize(code, attributes)
    @code = code
    @name = attributes["name"]
    @email = attributes["email"]
    @website = attributes["website"]
    @ukprn = attributes["ukprn"]
  end

  def self.all
    providers_from_api.map { |code, attributes| new(code, attributes) }
  end

  def self.find(code)
    if attributes = providers_from_api[code]
      new(code, attributes)
    else
      raise ProviderNotFound.new(code)
    end
  end

  class ProviderNotFound < StandardError
    def initialize(code)
      super("Couldn't find provider with code '#{code}'")
    end
  end

private

  def self.providers_from_api
    @providers_from_api ||= Rails.cache.fetch("providers_from_api", expires_in: 1.hour) do
      # Fetch all providers from the API
      providers = TeacherTrainingCoursesApi.get_all_pages("/recruitment_cycles/2023/providers")

      # Drop attributes we don't need
      providers = providers.map do |provider|
        provider["attributes"].select { |key, _value| ATTRIBUTES.include?(key.to_sym) }
      end

      # Transform to a Hash indexed by provider code
      providers.index_by { |provider| provider["code"] }
    end
  end
end
