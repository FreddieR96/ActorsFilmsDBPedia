class FilmData
  def self.get_film_data(actor:nil, film:nil)
    if actor
      get_films_from_actor(actor)
    elsif film
      get_actors_from_film(film)
    end
  end

  private

  def self.get_films_from_actor(actor)
    query = "
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    SELECT ?film where {
    ?film dbo:director ?director  .
    ?film dbo:gross ?gross  .
    ?film dbo:starring dbr:#{actor}  .
    }
    "
    sparql = SPARQL::Client.new("http://dbpedia.org/sparql")
    result = sparql.query(query)
    films = []
    result.each do |solution|
      filmUri = solution[:film]
      filmString = /(?<=resource\/).+/.match(filmUri)[0]
      filmString = filmString.gsub(/_/, " ")
      films << filmString if !(filmString == films.last)
    end
    {films: films}
  end
    
  def self.get_actors_from_film(film)
    query = "
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX dbp: <http://dbpedia.org/property/>
    SELECT ?starring where {
    ?film dbo:director ?director  .
    ?film dbo:gross ?gross  .
    ?film dbo:starring ?starring  .
    ?film dbp:name '#{film}'@en
    }
    "
    sparql = SPARQL::Client.new("http://dbpedia.org/sparql")
    result = sparql.query(query)
    actors = []
    result.each do |solution| 
      actorUri = solution[:starring]
      actorString = /(?<=resource\/).+/.match(actorUri)[0]
      actorString = actorString.gsub(/_/, " ")
      actors << actorString if !(actorString == actors.last)
    end
    {actors: actors}
  end
end