<cfquery name="qgetpokeman" datasource="pokemon">
	select * from CUPIDMEDIA_POKEMON.POKEMON where id=37
</cfquery>

<cfquery name="qgetitem" datasource="pokemon">
	select * from CUPIDMEDIA_POKEMON.ITEM where pokemonid=37
</cfquery>
<cfdump var="#qgetpokeman#">
<cfdump var="#qgetitem#" abort>
<cfset response = "I've fetched and recordcount for Pokemon with id: #qgetpokeman.recordcount# and item count is #qgetitem.recordcount#">