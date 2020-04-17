module Cru
  class App
    Cute.signal should_quit(app : App)

    # Create a new Cru app
    def initialize
      options = UI::InitOptions.new
      err = UI.init pointerof(options)

      if !ui_nil?(err)
        puts "Failed to initialize Cru application: #{err}"
        exit 1
      end

      set_on_should_quit { should_quit.emit(self); 0 }
    end

    # Start the application main loop
    def start
      UI.main
    end

    # Stop the application main loop
    def stop
      UI.quit
    end

    # Close the application and free resources
    def close
      UI.uninit
    end

    @on_should_quit_cb : Proc(Int32)?
    private def set_on_should_quit(&cb : -> Int32)
      @on_should_quit_cb = cb
      UI.on_should_quit ->(data) {
        data.as(typeof(cb)*).value.call
      }, pointerof(@on_should_quit_cb)
    end
  end
end
