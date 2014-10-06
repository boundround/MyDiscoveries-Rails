module GamesHelper
  def game_thumbnail(game)
    if !game.place.photos.empty?
      game.place.photos.find_by(priority: 1) ? game.place.photos.find_by(priority: 1).path_url(:medium) : game.place.photos.first.path_url(:medium)
    elsif !game.place.photos.empty?
      game.place.area.photos.first.path_url(:medium)
    else
      ''
    end
  end
end
