module GamesHelper
  def game_thumbnail(game)
    if game.game_type != 'word search' && game.thumbnail
      game.thumbnail_url
    elsif !game.place.photos.empty?
      game.place.photos.find_by(priority: 1) ? game.place.photos.find_by(priority: 1).path_url(:medium) : game.place.photos.first.path_url(:medium)
    else
      ''
    end
  end
end
