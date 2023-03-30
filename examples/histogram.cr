require "../src/cru"

class Histogram < Cru::Area
  XOffLeft    = 20.0
  YOffTop     = 20.0
  XOffRight   = 20.0
  YOffBottom  = 20.0
  PointRadius =  5.0

  ColorWhite      = 0xFFFFFF
  ColorBlack      = 0x000000
  ColorDodgerBlue = 0x1E90FF

  getter datapoints : Array(Int32)

  def initialize(@datapoints)
    super()
  end

  def on_draw(params : UI::AreaDrawParams)
    brush = Cru::DrawBrush.new(ColorWhite, 1.0)

    path = Cru::DrawPath.new(:winding)
    path.add_rectangle(0, 0, params.area_width, params.area_height)
    path.end
    path.fill(params.context, brush)

    graph_width = params.area_width - XOffLeft - XOffRight
    graph_height = params.area_height - YOffTop - YOffBottom

    brush.color = ColorBlack
    path = Cru::DrawPath.new(:winding)
    path.new_figure(XOffLeft, YOffTop)
    path.line_to(XOffLeft, YOffTop + graph_height)
    path.line_to(XOffLeft + graph_width, YOffTop + graph_height)
    path.end
    path.stroke(params.context, brush, thickness: 2.0)

    matrix = Cru::DrawMatrix.new
    matrix.translate(XOffLeft, YOffTop)
    matrix.transform(params.context)

    # color_button = Cru::ColorButton.new
    # color_button.changed.on do
    #   graph_colors = color_button.color
    #   brush.r = graph_colors[:red]
    #   brush.g = graph_colors[:green]
    #   brush.b = graph_colors[:blue]
    # end

    path = construct_graph(graph_width, graph_height, true)
    path.fill(params.context, brush)
  end

  def on_mouse_event(mouse_event : UI::AreaMouseEvent)
  end

  def on_mouse_crossed(left : Bool)
  end

  def on_drag_broken
  end

  def on_key_event(key_event : UI::AreaKeyEvent) : Int32
    return 0
  end

  def on_datapoint_changed

  end

  def construct_graph(width, height, ext)
    path = Cru::DrawPath.new(:winding)
    xs = @datapoints.dup.map{ 0.0 }
    ys = @datapoints.dup.map{ 0.0 }

    point_locations(width, height, xs, ys)

    path.new_figure(xs[0], ys[0])
    (1...@datapoints.size).each do |i|
      path.line_to(xs[i], ys[i])
    end

    if ext
      path.line_to(width, height)
      path.line_to(0, height)
      path.close_figure
    end

    path.end
    path
  end

  def point_locations(width, height, xs, ys)
    xincr = width / 9
    yincr = height / 100

    @datapoints.each_with_index do |n, i|
      # Because y=0 is the top but n=0 is the bottom, we need to flip
      n = 100 - n
      xs[i] = xincr * i
      ys[i] = yincr * n
    end
  end
end

app = Cru::App.new
window = Cru::Window.new("Histogram", 800, 600, false)

box = Cru::VerticalBox.new
box.padded = true
window.child = box

hbox = Cru::HorizontalBox.new
hbox.padded = true
box.append hbox, true

group = Cru::Group.new "Histogram"
group.margined = true
hbox.append group, true

inner = Cru::VerticalBox.new
inner.padded = true
group.child = inner

datapoints = [0, 23, 12, 43, 35, 32, 65, 87, 23]
histogram = Histogram.new(datapoints)
inner.append histogram, true

window.show
app.start
