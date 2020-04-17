# This is the standard control gallery, based off of the one
# at https://github.com/Fusion/libui.cr/blob/master/examples/controlgallery/main.cr

require "../src/cru"
include Cru

# Bootstrap the app
app = App.new
app.should_quit.on do
  exit(0)
end

file_menu = Menu.new "File"

open_item = file_menu.append_item "Open"
open_item.clicked.on do |window|
  filename = window.open_file
  if !filename
    window.show_error("No file selected!", "This is an error.")
  else
    window.show_message("File selected", filename)
  end
end

save_item = file_menu.append_item "Save"
save_item.clicked.on do |window|
  filename = window.save_file
  if !filename
    window.show_error("No file selected!", "This is an error.")
  else
    window.show_message("File selected", filename)
  end
end

file_menu.append_quit_item

edit_meu = Menu.new "Edit"
edit_meu.append_check_item "Checkable Item"
disabled_item = edit_meu.append_item "Disabled Item"
disabled_item.disable
edit_meu.append_preferences_item

help_menu = Menu.new "Help"
help_menu.append_item "Help"
help_menu.append_about_item

window = Window.new "Cru Control Gallery", 640, 480, true
window.margined = true

box = VerticalBox.new
box.padded = true
window.child = box

hbox = HorizontalBox.new
hbox.padded = true
box.append hbox, true

group = Group.new "Basic Controls"
group.margined = true
hbox.append group

inner = VerticalBox.new
inner.padded = true
group.child = inner

inner.append Button.new("Button")
inner.append Checkbox.new("Checkbox")
entry = Entry.new
entry.text = "Entry"
inner.append entry
inner.append Label.new("Label")

inner.append HorizontalSeparator.new

inner.append DatePicker.new
inner.append TimePicker.new
inner.append DateTimePicker.new

inner.append FontButton.new
inner.append ColorButton.new

inner2 = VerticalBox.new
inner2.padded = true
hbox.append inner2, true

group = Group.new "Numbers"
group.margined = true
inner2.append group

inner = VerticalBox.new
inner.padded = true
group.child = inner

progress_bar = ProgressBar.new
spinbox = Spinbox.new 0, 100
slider = Slider.new 0, 100

spinbox.changed.on do
  value = spinbox.value.to_i
  slider.value = value
  progress_bar.value = value
end

slider.changed.on do
  value = slider.value.to_i
  spinbox.value = value
  progress_bar.value = value
end

inner.append spinbox
inner.append slider
inner.append progress_bar

group = Group.new "Lists"
group.margined = true
inner2.append group

inner = VerticalBox.new
inner.padded = true
group.child = inner

cbox = ComboBox.new([
  "Item 1",
  "Item 2",
  "Item 3",
])
inner.append cbox

ecbox = EditableComboBox.new([
  "Item 1",
  "Item 2",
  "Item 3",
])
inner.append ecbox

rb = RadioButtons.new([
  "Button 1",
  "Button 2",
  "Button 3",
])
inner.append rb, true

tab = Tab.new
tab.append "Page 1", HorizontalBox.new
tab.append "Page 2", HorizontalBox.new
tab.append "Page 3", HorizontalBox.new
inner2.append tab, true

window.show

app.start
