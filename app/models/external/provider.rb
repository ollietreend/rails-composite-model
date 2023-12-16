class External::Provider
  attr_reader :name, :email, :website, :ukprn

  def initialize(attributes)
    @name = attributes["name"]
    @email = attributes["email"]
    @website = attributes["website"]
    @ukprn = attributes["ukprn"]
  end

  def self.all
    api_response = TeacherTrainingCoursesApi.get("/recruitment_cycles/2023/providers")
    api_response.fetch("data").map { |provider| new(provider["attributes"]) }
  end

  def self.find(ukprn)
    self.all.detect { |p| p.ukprn == ukprn } or raise ProviderNotFound.new(ukprn)
  end

  class ProviderNotFound < StandardError
    def initialize(ukprn)
      super("Couldn't find provider with UKPRN '#{ukprn}'")
    end
  end
end
