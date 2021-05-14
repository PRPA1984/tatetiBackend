El backend se expone en localhost:3000

Los endpoints son:

# USER

## Login:

Path: POST /users/login

Body

```
{
  "username": "user",
  "password": "pass"
}
```

### Success Response

Response

```
{
  "token" : "token"
}
```


### Error Response


400 Bad Request

```
{
   "error" : "User not Found"
}
```

## Logout:

Path: GET /users/logout

Header Autorización

```
Authorization={token}
```

### Success Response

Response Status 200


### Error Response


400 Bad Request

```
{
   "error" : "User not Found"
}
```

## Crear nuevo usuario:

Path: POST /users

Body

```
{
    "username": "user",
    "password": "pass",
    "name": "nombre"
}
```

### Success Response

Response

```
{
  "token" : "token"
}
```


### Error Response


400 Bad Request

```
{
   "error" : "errors"
}
```

## Current User:

Path: GET /users/current

Header Autorización

```
Authorization={token}
```

### Success Response

```
{
    "id": id,
    "name": "name",
    "matchmaking": true
}
```
### Error Response


400 Bad Request

```
{
   "error" : "User not Found"
}
```



# BOARD

## Nuevo Juego:

Path: GET /boards/newGame

Header Autorización

```
Authorization={token}
```

### Success Response

Si no encuentra un usuario con quien jugar, el usuario queda en cola con matchmaking = true
```
{
    "state" : "In queue
}
```
Si había alguien en cola, ambos empìezan a jugar. En este JSON, el atributo board es un hash que contiene valores del 1 al 9 como llaves para señalar las posiciones dentro de la tabla de tateti. La llave está asociada a 2 valores: nil en caso de que no esté ocupada, caso contrario, el nombre del usuario que la ocupa.
```
{
            "id": id,
            "board": board,
            "turn": "turn",
            "winner": "winner",
            "greenPlayer": "GreenPlayer",
            "redPlayer": "RedPlayer"
}
```
### Error Response


400 Bad Request

```
{
   "error" : "User not Found"
}
```

## Última board:

Devuelve el último juego del usuario current.

Path: GET /boards/lastBoard

Header Autorización

```
Authorization={token}
```

### Success Response

```
{
            "id": id,
            "board": board,
            "turn": "turn",
            "winner": "winner",
            "greenPlayer": "GreenPlayer",
            "redPlayer": "RedPlayer"
}
```
### Error Response


400 Bad Request

```
{
   "error" : "User not Found"
}
```

```
{
   "error" : "Board not Found"
}
```

## Estado del usuario:

Devuelve el estado del usuario según su matchmaking

Path: GET /boards/userState

Header Autorización

```
Authorization={token}
```

### Success Response

Si matchmaking = true, el usuario está esperando un jugador:
```
{
     "state" : "In queue"
}
```

Si no está esperando un jugador:

```
{
     "state" : "Not in queue"
}
```
### Error Response


400 Bad Request

```
{
   "error" : "User not Found"
}
```

## Nuevo Turno:

El usuario hace un nuevo movimiento a una tabla con el id enviado en el path

Path: POST /boards/:id/newTurn

Header Autorización

```
Authorization={token}
```

### Success Response
Si el movimiento se realiza con éxito:
```
{
            "id": id,
            "board": board,
            "turn": "turn",
            "winner": "winner",
            "greenPlayer": "GreenPlayer",
            "redPlayer": "RedPlayer"
}
```
### Error Response


400 Bad Request

```
{
   "error" : "User not Found"
}
```
```
{
   "error" : "Board not Found"
}
```
Si ya hay un ganador:
```
{
   "error" : "There is already a winner"
}
```
Si no es el turno del usuario que manda la petición:
```
{
   "error" : "This is not your turn"
}
```
Si la posición seleccionada ya está ocupada:
```
{
   "error" : "This row is not available"
}
```

## Obtener tabla según Id:

Path: GET /boards/:id

Header Autorización

```
Authorization={token}
```


### Success Response
```
{
            "id": id,
            "board": board,
            "turn": "turn",
            "winner": "winner",
            "greenPlayer": "GreenPlayer",
            "redPlayer": "RedPlayer"
}
```
### Error Response


400 Bad Request

```
{
   "error" : "Board not Found"
}
```


## Historial de partidas:

Path: GET /boards/matchHistory


### Success Response
```
[
    {
        "id": id,
        "greenPlayer": "GreenPlayer",
        "redPlayer": "RedPlayer",
        "winner": "Winner"
    }
]
```
### Error Response


400 Bad Request

```
{
   "error" : "Boards not Found"
}
```
```
{
   "error" : "User not Found"
}
```

