require "lapis"

module Soulantern
  # Sound registry and playback utility for 2D and positional 3D audio.
  class Sounds
    @@cached_sounds = Hash(String, AudioStream).new

    # Retrieves or dynamically loads an AudioStream by name.
    def self.get_sound(sound_name : String) : AudioStream?
      clean = sound_name.strip
      if stream = @@cached_sounds[clean]?
        return stream
      end

      candidates = [
        "res://sounds/#{clean}.wav",
        "res://sounds/#{clean}.ogg",
        "res://sounds/#{clean}.mp3",
        "res://sounds/#{clean}"
      ]

      candidates.each do |path|
        if ResourceLoader.exists(path)
          res = ResourceLoader.load(path)
          if stream = res.as?(AudioStream)
            @@cached_sounds[clean] = stream
            return stream
          end
        end
      end

      Godot.log_warn("Sounds", "Sound '#{clean}' not found in res://sounds/")
      nil
    end

    # Plays a sound by name. If from_node is a Node3D, an AudioStreamPlayer3D is spawned.
    # Otherwise, a global AudioStreamPlayer is spawned on the SceneTree root.
    def self.play(sound_name : String, from_node : Godot::Node? = nil, volume_db : Float32 = 0.0_f32, pitch_scale : Float32 = 1.0_f32) : Godot::Node?
      stream = get_sound(sound_name)
      return nil unless stream

      tree = Godot.get_tree?
      return nil unless tree

      if from_node && (node3d = from_node.as?(Node3D)) && node3d.is_inside_tree
        player_3d = AudioStreamPlayer3D.new
        player_3d.stream = stream
        player_3d.volume_db = volume_db
        player_3d.pitch_scale = pitch_scale
        player_3d.bus = "Master"
        player_3d.global_position = node3d.global_position
        
        if parent = node3d.get_parent?
          parent << player_3d
        elsif root = tree.get_root?
          root << player_3d
        end

        player_3d.finished >> ->{
          player_3d.queue_free
        }
        player_3d.play
        player_3d
      else
        player = AudioStreamPlayer.new
        player.stream = stream
        player.volume_db = volume_db
        player.pitch_scale = pitch_scale
        player.bus = "Master"

        if root = tree.get_root?
          root << player
        end

        player.finished >> ->{
          player.queue_free
        }
        player.play
        player
      end
    end
  end
end
