module Cru
  record Font, family : String,
    size : Float64,
    weight : UI::UITextWeight,
    italic : UI::UITextItalic,
    stretch : UI::UITextStretch do
    def self.from_descriptor(d : UI::UIFontDescriptor)
      font = new(String.new(d.family),
                 d.weight.to_f64,
                 d.weight,
                 d.italic,
                 d.stretch)
      UI.free_font_button_font(pointerof(d))
      font
    end
  end
end
