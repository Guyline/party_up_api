# Represents a version of a playable, i.e. a released edition from a specific
# publisher at a specific time
module BoardGameGeek
  class Version
    attr_reader :id, :name, :publication_year

    def initialize(id, name: nil, publication_year: nil)
      @id = id
      @name = name
      @publication_year = publication_year
    end
  end
end
