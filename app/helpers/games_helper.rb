p.games.firstmodule GamesHelper
  def game_thumbnail(game)
    begin
      if game.game_type != 'word search' && game.thumbnail
        game.url.match(/\=.*(\.jpg|\.png|\.svg)/i)[0].gsub("=", "")
      elsif !game.place.photos.empty?
        game.place.photos.first.path_url(:small)
      else
        ''
      end
    rescue
      ""
    end
  end
end
