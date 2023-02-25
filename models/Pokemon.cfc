component accessors="true" {

  property name="response";
  property name="pokemon";

  function init()
  {
    variables.response = "I've downloaded and stored data for Pokemon with id: ";
  }

  function getPokemonProperties(pokemonId)
  {
    cfhttp(url="https://pokeapi.co/api/v2/pokemon/#pokemonId#", result="result");

    if(result.responseHeader.status_code == 200) {
      variables.pokemon = DESERIALIZEJSON(result.filecontent);
      return true;
    }
    else {
      variables.response = "No result found";
      return false;
    }
  }

  function checkExist(required pokemonId)
  {
    //check if pokemon id exists in the database already
    result = queryExecute(
      "SELECT * FROM CUPIDMEDIA_POKEMON.POKEMON where id = :pokemonId", 
      {pokemonId: {value: arguments.pokemonId}},
      {datasource:"pokemon"});

    return result.recordcount eq 1;
  }

  function insertPokemon()
  {
    queryExecute(
      "INSERT INTO CUPIDMEDIA_POKEMON.POKEMON(ID, SPECIES, URL, HEIGHT)
       VALUES (
        :pokemonId,
        :species,
        :url,
        :height
       )", 
      {pokemonId: {value: variables.pokemon.id, cfsqltype: "integer"},
       species: {value: variables.pokemon.species.name, cfsqltype: "varchar"},
       url: {value: variables.pokemon.species.url, cfsqltype: "varchar"},
       height: {value: variables.pokemon.height, cfsqltype: "integer"}
      },
      {datasource:"pokemon"});

      insertHeldItems();
  }

  function updatePokemon()
  {
    queryExecute(
      "UPDATE CUPIDMEDIA_POKEMON.POKEMON
          SET SPECIES = :species,
              URL = :url,
              HEIGHT = :height
        WHERE ID = :pokemonId", 
      {pokemonId: {value: variables.pokemon.id, cfsqltype: "integer"},
       species: {value: variables.pokemon.species.name, cfsqltype: "varchar"},
       url: {value: variables.pokemon.species.url, cfsqltype: "varchar"},
       height: {value: variables.pokemon.height, cfsqltype: "integer"}
      },
      {datasource:"pokemon"});

      updateHeldItems();
  }

  function insertHeldItems()
  {
    variables.pokemon.held_items.each(function (key){
      queryExecute(
        "INSERT INTO CUPIDMEDIA_POKEMON.ITEM(POKEMONID, NAME, URL)
         VALUES (
          :pokemonId,
          :itemName,
          :url
        )", 
        {pokemonId: {value: variables.pokemon.id, cfsqltype: "integer"},
         itemName: {value: arguments.key.item.name, cfsqltype: "varchar"},
         url: {value: arguments.key.item.url, cfsqltype: "varchar"}
        },
        {datasource:"pokemon"});
    });
  }

  function updateHeldItems()
  {
    queryExecute(
      "DELETE FROM CUPIDMEDIA_POKEMON.ITEM WHERE POKEMONID = :pokemonId", 
      {pokemonId: {value: variables.pokemon.id}},
      {datasource:"pokemon"});

    insertHeldItems();
  }

  function getResponse()
  {
    if(isDefined("variables.pokemon.id"))
    {
      returndata = {"message": variables.response & variables.pokemon.id,
              "pokemon": { "name": variables.pokemon.species.name, "height": variables.pokemon.height, "itemsHeldCount": ArrayLen(variables.pokemon.held_items)}};
    }
    else
    {
      returndata = {"message": variables.response};
    }
    return returndata;
  }
}