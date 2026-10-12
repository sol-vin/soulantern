require "lapis"

module Soulantern
  # Autoload singleton for executing, hooking, and binding global trigger functions,
  # game lifecycle, player death flow, pause menu, and audio bus volume settings.
  alias FunctionCallback = Proc(Variant)

  @[Autoload(name: "Functions")]
  node Functions < Node do
    signal function_called(function_name : String)
    signal function_executed(function_name : String, result : Variant)

    property is_dead : Bool = false
    property last_level_path : String = "res://node_3d.tscn"
    property active_pause_menu : Godot::Node? = nil
    
    @death_audio_player : AudioStreamPlayer? = nil
    @is_opening_pause_menu : Bool = false
    @bound_callables : Hash(String, FunctionCallback) = Hash(String, FunctionCallback).new

    def _enter_tree : Void
      self.process_mode = Node::ProcessMode::ProcessModeAlways
    end

    def _ready : Void
      self.process_mode = Node::ProcessMode::ProcessModeAlways

      unless Engine.is_editor_hint
        if tree = Godot.get_tree?
          if root = tree.get_root?
            root.focus_exited.connect do
              handle_focus_loss
            end
          end
        end
      end
    end

    def _notification(what : Int32) : Void
      return if Engine.is_editor_hint
      if what == 1004 || what == 1007 # NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_WM_WINDOW_FOCUS_OUT
        handle_focus_loss
      end
    end

    def handle_focus_loss : Void
      tree = Godot.get_tree?
      return unless tree
      if can_pause && !tree.paused && !@is_opening_pause_menu && @active_pause_menu.nil?
        call_deferred("open_pause_menu")
      end
    end

    def _input(event : InputEvent) : Void
      return if Engine.is_editor_hint

      is_esc = false
      if key_event = event.as?(InputEventKey)
        if key_event.pressed && !key_event.echo
          is_esc = (key_event.keycode == 4194305 || key_event.physical_keycode == 4194305) # KEY_ESCAPE
        end
      elsif event.is_action_pressed("ui_cancel")
        is_esc = true
      end

      if is_esc
        if menu = @active_pause_menu
          close_pause_menu
          if vp = get_viewport?
            vp.set_input_as_handled
          end
        elsif can_pause
          open_pause_menu
          if vp = get_viewport?
            vp.set_input_as_handled
          end
        end
      end
    end

    # --------------------------------------------------------------------------
    # Player Lifecycle & Game State
    # --------------------------------------------------------------------------

    def play_death_sound : Void
      if dap = @death_audio_player
        dap.stop
        dap.queue_free
        @death_audio_player = nil
      end

      if ResourceLoader.exists("res://sounds/death.mp3")
        res = ResourceLoader.load("res://sounds/death.mp3")
        if stream = res.as?(AudioStream)
          if mp3 = stream.as?(AudioStreamMP3)
            mp3.loop = false
          end

          asp = AudioStreamPlayer.new
          asp.name = "DeathAudioPlayer"
          asp.stream = stream
          asp.bus = "Master"
          
          if root = Godot.get_tree?.try(&.get_root?)
            root.add_child(asp)
          else
            add_child(asp)
          end

          asp.finished.connect do
            asp.queue_free
            if @death_audio_player == asp
              @death_audio_player = nil
            end
          end
          
          @death_audio_player = asp
          asp.play
        end
      end
    end

    def reset_game_state : Void
      @is_dead = false
      if dap = @death_audio_player
        dap.stop
        dap.queue_free
        @death_audio_player = nil
      end
    end

    def kill : Void
      return if @is_dead
      @is_dead = true

      Godot.log_info("Functions", "kill() called! Playing death sound and disabling player...")
      play_death_sound

      tree = Godot.get_tree?
      return unless tree

      # Lock players in group "player"
      if p = tree.get_first_node_in_group?("player")
        p.call("turn_off") rescue nil
        p.call("lock_movement", true) rescue nil
      end

      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      if curr = tree.current_scene
        path = curr.scene_file_path
        if !path.empty? && !path.ends_with?("gameover.tscn") && !path.ends_with?("mainmenu.tscn")
          @last_level_path = path
        end
      end

      # Dismiss pause menu if open
      @is_opening_pause_menu = false
      if menu = @active_pause_menu
        menu.queue_free
        @active_pause_menu = nil
      end
      tree.paused = false

      tree.call_deferred("change_scene_to_file", "res://gameover.tscn")
    end

    def restart_level : Void
      reset_game_state
      tree = Godot.get_tree?
      return unless tree

      tree.paused = false
      @is_opening_pause_menu = false
      if menu = @active_pause_menu
        menu.queue_free
        @active_pause_menu = nil
      end

      path = @last_level_path.empty? ? "res://node_3d.tscn" : @last_level_path
      tree.call_deferred("change_scene_to_file", path)
    end

    def end_game : Void
      reset_game_state
      Godot.log_info("Functions", "end_game() triggered!")
      tree = Godot.get_tree?
      return unless tree

      if p = tree.get_first_node_in_group?("player")
        p.call("turn_off") rescue nil
        p.call("lock_movement", true) rescue nil
      end

      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      @is_opening_pause_menu = false
      if menu = @active_pause_menu
        menu.queue_free
        @active_pause_menu = nil
      end
      tree.paused = false

      tree.call_deferred("change_scene_to_file", "res://endgame.tscn")
    end

    # --------------------------------------------------------------------------
    # Pause Menu Management
    # --------------------------------------------------------------------------

    def can_pause : Bool
      tree = Godot.get_tree?
      return false unless tree && (scene = tree.current_scene)

      path = scene.scene_file_path.downcase
      name = scene.name.downcase
      blocked = ["mainmenu", "credits", "gameover", "endgame", "opening"]
      blocked.each do |b|
        return false if path.includes?(b) || name.includes?(b)
      end
      true
    end

    def open_pause_menu : Void
      return unless can_pause
      return if @is_opening_pause_menu
      return if @active_pause_menu

      @is_opening_pause_menu = true
      unless ResourceLoader.exists("res://pausemenu.tscn")
        @is_opening_pause_menu = false
        return
      end

      res = ResourceLoader.load("res://pausemenu.tscn")
      packed = res.as?(PackedScene)
      return unless packed

      tree = Godot.get_tree?
      return unless tree && (root = tree.get_root?)

      menu = packed.instantiate
      return unless menu

      menu.tree_exited.connect do
        @is_opening_pause_menu = false
      end

      root.call_deferred("add_child", menu)
      @active_pause_menu = menu
      tree.paused = true
      Input.mouse_mode = Input::MouseMode::MouseModeVisible
    end

    def close_pause_menu : Void
      @is_opening_pause_menu = false
      if menu = @active_pause_menu
        menu.queue_free
        @active_pause_menu = nil
      end

      if tree = Godot.get_tree?
        tree.paused = false
      end
      Input.mouse_mode = Input::MouseMode::MouseModeCaptured
    end

    # --------------------------------------------------------------------------
    # Global Audio Volume Settings
    # --------------------------------------------------------------------------

    def get_master_volume : Float32
      AudioServer.get_master_volume
    end

    def set_master_volume(linear_val : Float32) : Void
      AudioServer.set_master_volume(linear_val)
    end

    # --------------------------------------------------------------------------
    # Dynamic Binding & Execution
    # --------------------------------------------------------------------------

    def bind(function_name : String, callback : FunctionCallback) : Void
      @bound_callables[function_name.strip] = callback
    end

    def unbind(function_name : String) : Void
      @bound_callables.delete(function_name.strip)
    end

    def has_function(function_name : String) : Bool
      fn = function_name.strip
      return true if @bound_callables.has_key?(fn)
      return true if has_method(fn)
      false
    end

    def execute_function(function_name : String) : Variant
      fn = function_name.strip
      return Variant.new if fn.empty?

      emit(function_called, fn)

      if cb = @bound_callables[fn]?
        res = cb.call
        emit(function_executed, fn, res)
        return res
      end

      # Built-in sample / test functions
      case fn
      when "test_function"
        Godot.log_info("Functions", "test_function() invoked successfully!")
      when "print_hello"
        Godot.log_info("Functions", "Hello from trigger_function!")
      when "kill"
        kill
      when "end_game"
        end_game
      when "restart_level"
        restart_level
      else
        if has_method(fn)
          res = call(fn)
          emit(function_executed, fn, res)
          return res
        else
          Godot.log_warn("Functions", "Function '#{fn}' is not registered or found in Functions singleton.")
        end
      end

      Variant.new
    end

    def execute_trigger_function(function_name : String) : Variant
      execute_function(function_name)
    end
  end
end
