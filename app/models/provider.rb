class Provider
  delegate :id, :created_at, :updated_at,
           to: :@local

  delegate :name, :email, :website, :ukprn,
           to: :@external

  def initialize(local:, external:)
    @local = local
    @external = external
  end

  def self.all
    all_local = Local::Provider.all
    all_external = External::Provider.all.index_by(&:ukprn)

    all_local.map do |local|
      new(
        local:,
        external: all_external[local.ukprn]
      )
    end
  end

  def self.find(ukprn)
    new(
      local: Local::Provider.find_by!(ukprn:),
      external: External::Provider.find(ukprn),
    )
  end
end
