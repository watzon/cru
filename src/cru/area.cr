require "./control"

module Cru
  abstract class Area < Control
    @on_draw_cb : Proc(UI::AreaHandler*, UI::Area*, UI::AreaDrawParams*, Nil)
    @on_mouse_event_cb : Proc(UI::AreaHandler*, UI::Area*, UI::AreaMouseEvent*, Nil)
    @on_mouse_crossed_cb : Proc(UI::AreaHandler*, UI::Area*, LibC::Int, Nil)
    @on_drag_broken_cb : Proc(UI::AreaHandler*, UI::Area*, Nil)
    @on_key_event_cb : Proc(UI::AreaHandler*, UI::Area*, UI::AreaKeyEvent*, Nil)

    def initialize(width = nil, height = width)
      @on_draw_cb = ->(h : UI::AreaHandler*, a : UI::Area*, p : UI::AreaDrawParams*) {
        on_draw(p.value)
        nil
      }

      @on_mouse_event_cb = ->(h : UI::AreaHandler*, a : UI::Area*, e : UI::AreaMouseEvent*) {
        on_mouse_event(e.value)
        nil
      }

      @on_mouse_crossed_cb = ->(h : UI::AreaHandler*, a : UI::Area*, left : LibC::Int) {
        on_mouse_crossed(left == 1)
        nil
      }

      @on_drag_broken_cb = ->(h : UI::AreaHandler*, a : UI::Area*) {
        on_drag_broken
        nil
      }

      @on_key_event_cb = ->(h : UI::AreaHandler*, a : UI::Area*, e : UI::AreaKeyEvent*) {
        on_key_event(e.value)
        nil
      }

      @handler = UI::AreaHandler.new
      @handler.draw = @on_draw_cb
      @handler.mouse_event = @on_mouse_event_cb
      @handler.mouse_crossed = @on_mouse_crossed_cb
      @handler.drag_broken = @on_drag_broken_cb
      @handler.key_event = @on_key_event_cb

      if width && height
        @area = UI.new_scrolling_area(pointerof(@handler), width, height)
      else
        @area = UI.new_area(pointerof(@handler))
      end

      super(@area.not_nil!)
    end

    abstract def on_draw(params : UI::AreaDrawParams)
    abstract def on_mouse_event(mouse_event : UI::AreaMouseEvent)
    abstract def on_mouse_crossed(left : Bool)
    abstract def on_drag_broken
    abstract def on_key_event(key_event : UI::AreaKeyEvent) : Int32

    def set_size(width : Int32, height : Int32)
      UI.area_set_size(@area, width, height)
    end

    def redraw_all
      UI.area_queue_redraw_all(@area)
    end

    def scroll_to(x : Float64, y : Float64, width : Float64, height : Float64)
      UI.area_scroll_to(@area, x, y, width, height)
    end

    # Can only be used within the `on_mouse_event` and `on_mouse_crossed` handlers.
    def begin_user_window_move
      UI.area_begin_user_window_move(@area)
    end

    # Can only be used within the `on_mouse_event` and `on_mouse_crossed` handlers.
    def begin_user_window_resize(edge : UI::WindowResizeEdge)
      UI.area_begin_user_window_resize(@area)
    end
  end
end
