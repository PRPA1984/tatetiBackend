# README

El backend se expone en localhost:3000

Los endpoints son:

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
