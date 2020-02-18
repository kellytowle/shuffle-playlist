# frozen_string_literal: true

# class PlaylistShuffler
# Create shuffled playlists, given an array of tracks and a maximum number of
# playlists to generate
class PlaylistShuffler
  def initialize(tracks = [], max_playlists = nil)
    assign_attribute_values(tracks, max_playlists)
    until @shuffled_playlists.length >= @playlist_limit
      @shuffled_playlists.push(generate_playlist)
    end
  end

  def shuffled
    @shuffled_playlists
  end

  private

  def generate_playlist
    playlist = []
    tracks = @tracks.dup
    until tracks.empty? || @shuffled_playlists.length == @playlist_limit
      random_number = rand(tracks.length)
      playlist.push(tracks[random_number])
      tracks.slice!(random_number, 1)
    end
    de_dupe_playlist(playlist)
  end

  def de_dupe_playlist(playlist)
    if @shuffled_playlists.length < @permutations
      playlist = generate_playlist if duped_playlist?(playlist)
    end
    playlist
  end

  def duped_playlist?(new_playlist)
    @shuffled_playlists.include? new_playlist
  end

  def assign_attribute_values(tracks, max_playlists)
    @shuffled_playlists = []

    default_tracks = *1..9
    @tracks = tracks.empty? ? default_tracks : tracks

    @permutations = Math.gamma(@tracks.length + 1).to_i
    default_limit = @permutations < 1000 ? @permutations : 999

    @playlist_limit = max_playlists.nil? ? default_limit : max_playlists
  end
end
