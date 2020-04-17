require "./control"

module Cru
  abstract class Box < Control
    getter children : Array(Control)

    def initialize(@box : UI::Box*)
      super(@box)
      @children = [] of Control
    end

    # Appends a child to the box.
    def append(child, stretchy = false)
      UI.box_append(@box, child, stretchy)
      @children << child
    end

    # Delete a child from the box.
    def delete(index)
      UI.box_delete(@box, index)
      @children[index].destroy
      @children.delete_at(index)
    end

    # Returns true if this box is padded.
    def padded?
      UI.box_padded(@box)
    end

    # Sets whether this box is padded.
    def padded=(value : Bool)
      UI.box_set_padded(@box, value)
    end
  end

  class HorizontalBox < Box
    def initialize
      @box = UI.new_horizontal_box
      super(@box)
    end
  end

  class VerticalBox < Box
    def initialize
      @box = UI.new_vertical_box
      super(@box)
    end
  end
end
