module BoardGameGeek
  class Expansion < BoardGameGeek::Thing
    attr_reader :expandables

    def initialize(id: nil, name: nil, thumbnail_url: nil, image_url: nil)
      super

      @expandables = {}
    end

    def add_expandable(expandable, add_as_expansion: true)
      raise "Specified record is not a thing." unless expandable.is_a?(BoardGameGeek::Thing)

      @expandables[expandable.id] = expandable
      expandable.add_expansion(self, add_as_expandable: false) if add_as_expansion

      @expandables
    end
  end
end
