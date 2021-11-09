class MainController < ApplicationController
  include GetsFilmData
  def home
    if params.has_key? :actor
      get_films_from_actor(params[:actor])
    elsif params.has_key? :film
      get_actors_from_film(params[:film])
    end
    first = Rails.cache.fetch('hi') do
      'there'
    end
    render json: {first: first}
  end
end
