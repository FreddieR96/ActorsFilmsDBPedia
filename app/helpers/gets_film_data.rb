module GetsFilmData
  def get_films_from_actor(actor)
    query = SPARQL.parse("
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    SELECT ?name where {
    ?film dbo:director ?director  .
    ?film dbo:gross ?gross  .
    ?film dbo:starring dbr:#{actor}  .
    ?film dbp:name ?name
    }
    ")
    sparql = SPARQL::Client.new("http://dbpedia.org/sparql")
    result = sparql.select.where([:s, :p, :o]).offset(100).limit(10)
    result.each_solution do |solution|
      puts solution.inspect
    end
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