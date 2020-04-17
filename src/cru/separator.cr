require "./control"

module Cru
  class HorizontalSeparator < Control
    def initialize
      @separator = UI.new_horizontal_separator
      super(@separator)
    end
  end

  class VerticalSeparator < Control
    def initialize
      @separator = UI.new_vertical_separator
      super(@separator)
    end
  end
end
