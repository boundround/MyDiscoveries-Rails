module GamesHelper
  def game_thumbnail(game)
    if game.game_type != 'word search' && game.thumbnail
      game.url.match(/\=.*(\.jpg|\.png|\.svg)/i)[0].gsub("=", "")
    elsif !game.place.photos.empty?
      game.place.photos.first.path_url(:small)
    else
      ''
    end
  end
end
