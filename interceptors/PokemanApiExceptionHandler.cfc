component extends="coldbox.system.Interceptor"{

    function onException(event, interceptData){
        // Get the exception
        var exception = arguments.interceptData.exception;

        //check if pokeman api and log to pokeman database and pokeman email group alerts right now just logging to default
        if(Lcase(event.getCurrentHandler()) == 'pokemon')
        { 
           log.error( exception.message & exception.detail, exception );

           relocate( "Pokemon.error" );
        }
        else
        {
            //global exception handling
        }

    }

}