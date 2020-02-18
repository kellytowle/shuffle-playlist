require 'minitest/autorun'
require_relative 'playlist_shuffler'

class PlaylistShufflerTest < Minitest::Test
  def test_no_args_tracks
    detector = PlaylistShuffler.new
    playlist = detector.shuffled[0]
    assert(playlist.count(1), 1)
    assert(playlist.count(2), 1)
    assert(playlist.count(3), 1)
    assert(playlist.count(4), 1)
    assert(playlist.count(5), 1)
    assert(playlist.count(6), 1)
    assert(playlist.count(7), 1)
    assert(playlist.count(8), 1)
    assert(playlist.count(9), 1)
  end

  def test_no_args_limit
    detector = PlaylistShuffler.new
    playlists = detector.shuffled
    expected = 999
    assert_equal expected, playlists.length
  end

  def test_shuffles_playlist
    detector = PlaylistShuffler.new([*1..3], 9)
    playlists = detector.shuffled
    expected = 9
    assert_equal expected, playlists.length
  end

  def test_respects_playlist_limit
    sut = PlaylistShuffler.new([*'a'..'z'], 3)
    playlists = sut.shuffled
    assert_equal 3, playlists.length
  end

  def test_does_not_repeat_playlist
    sut = PlaylistShuffler.new([*'a'..'z'], 2000)
    playlists = sut.shuffled.uniq
    assert_equal 2000, playlists.length
  end

  def test_limit_overrides_no_repeat
    sut = PlaylistShuffler.new([*1..2], 10)
    playlists = sut.shuffled
    assert_equal 10, playlists.length
  end

  def test_each_track_in_playlist
    tracks = [*'a'..'l']
    sut = PlaylistShuffler.new(tracks, 10)
    playlists = sut.shuffled
    playlists.each do |playlist|
      assert_equal tracks.length, playlist.uniq.length
    end
  end

  def test_repeated_tracks_respected
    tracks = [*'a'..'l', 'a']
    sut = PlaylistShuffler.new(tracks, 10)
    playlists = sut.shuffled
    playlists.each do |playlist|
      assert_equal tracks.length, playlist.length
      assert_equal(playlist.count('a'), 2)
    end
  end
end