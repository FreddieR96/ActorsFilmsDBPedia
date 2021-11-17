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
    SELECT ?name where {
    ?film dbo:director ?director  .
    ?film dbo:gross ?gross  .
    ?film dbo:starring dbr:#{actor}  .
    ?film dbp:name ?name
    }
    "
    sparql = SPARQL::Client.new("http://dbpedia.org/sparql")
    result = sparql.query(query)
    films = []
    result.each {|solution| films << solution[:name].to_s if !(films.last == solution[:name].to_s)}
    {films: films}
  end
    
  def self.get_actors_from_film(film)
    query = "
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX dbp: <http://dbpedia.org/property/>
    SELECT ?starring where {
    ?film dbo:director ?director
    ?film dbo:gross ?gross
    ?film dbo:starring ?starring
    ?film dbp:name '#{film}'@en
    }
    "
    sparql = SPARQL::Client.new("http://dbpedia.org/sparql")
    result = sparql.query(query)
    actors = []
    result.each {|solution| actors << solution[:name].to_s if !(actors.last == solution[:name].to_s)}
    {actors: actors}
  end
end