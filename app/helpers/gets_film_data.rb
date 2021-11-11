module GetsFilmData
  def get_films_from_actor(actor)
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
    result.each {|solution| puts solution.to_h}
  end

  def get_actors_from_film(film)
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
    puts result
  end
end