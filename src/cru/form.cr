require "./control"

module Cru
  class Form < Control
    getter children : Array(Control)

    def initialize
      @form = UI.new_form
      super(@form)
      @children = [] of Control
    end

    # Appends a child to the form.
    def append(child, stretchy = false)
      UI.form_append(@form, child, stretchy)
      @children << child
    end

    # Delete a child from the form.
    def delete(index)
      UI.form_delete(@form, index)
      @children[index].destroy
      @children.delete_at(index)
    end

    # Returns true if this form is padded.
    def padded?
      UI.form_padded(@form)
    end

    # Sets whether this form is padded.
    def padded=(value : Bool)
      UI.form_set_padded(@form, value)
    end
  end
end
