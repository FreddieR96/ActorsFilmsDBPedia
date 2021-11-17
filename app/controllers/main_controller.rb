class MainController < ApplicationController
  def home
    results = 
    if params.has_key? :actor
      Rails.cache.fetch("actor-#{params[:actor]}") do
        FilmData.get_film_data(actor: params[:actor])
      end
    elsif params.has_key? :film
      Rails.cache.fetch("film-#{params[:film]}") do
        FilmData.get_film_data(film: params[:film])
      end
    end
    render json: results
  end
end
