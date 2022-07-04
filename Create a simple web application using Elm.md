---
theme: solarized
highlightTheme: monokai
---
<style>
code {
    font-family: JetBrains Mono, monospace, monospace;
    color: #ed143d;
    background-color: #f0f0f0;
    padding: 1px 2px;
    line-height: 1.4em;
}

blockquote {
    background-color: #f9f9f9;
    border-left: 10px solid #1A374D;
    margin: 1.5em 10px;
    padding: 0.5em 16px;
}

.left-al {
    text-align: left;
}
</style>

# Create a simple web application using Elm
---

> Using Elm, I can deploy and go to sleep!

\- Mario Uher, CTO, yodel.io

---

## What will you learn?
- Elm syntax and types.
- Build a simple static application and a simple single-page application.
- Handle HTTP requests and Web socket requests besides the Elm error handling technique.

---

## What is Elm?
- A functional language
- No runtime exceptions
- Small assets
- Javascript interop

---
# Types
---

## Premitives
- Int
-  Float
- Char
- String
- Bool (**True** or **False**)

---

```elm
> "hello"
"hello" : String

> not True
False : Bool

> round 3.1415
3 : Int
```

---

<!-- .slide: class="left-al"" -->
## List types

In Elm, a list is a data structure for storing multiple values of the _same_ kind. List is one of the most used data structures in Elm.

- List
- Tuples

---
```elm
> [ "Alice", "Bob" ]
["Alice","Bob"] : List String

> [ 1.0, 8.6, 42.1 ]
[1.0,8.6,42.1] : List Float
```
---

## Functions

```elm
> String.length
<function> : String -> Int
```

---

## Constrainted type variables

- `number` permits `Int` and `Float`
- `appendable` permits `String` and `List a`
- `comparable` permits `Int`, `Float`, `Char`, `String`, and lists/tuples of `comparable` values
- `compappend` permits `String` and `List comparable`

---
# Write your first function
---
<!-- .slide: class="left-al"" -->

Write a function to count the number of members in a list.

**Hint**: (use `foldl`). Check Elm's core packages: https://package.elm-lang.org/packages/elm/core/latest

---

```elm
> List.foldl
<function> : (a -> b -> b) -> b -> List a -> b

> List.foldl (\_ b -> b + 1) 0 [3, 2, 1]
3 : number
```

---
# Write your first static web application
---

## Module and Package

![[Pasted image 20220703124959.png]]

---
<!-- .slide: class="left-al"" -->

## Html
Check Elm Html package: https://package.elm-lang.org/packages/elm/html/latest/

---
## Define your index.html
```html
<body>
  <div id="main" class="main"></div>
  <script src="picshare.js"></script>
  <script>
    Elm.Picshare.init({
      node: document.getElementById('main')
    });
  </script>
</body>
```
---
## Declare main and import HTML module
```elm
module Picshare exposing (main)

import Html exposing (..)
import Html.Attributes exposing (class)
```
---

## Compile your Elm file to Javascript
```bash
elm make ./src/Main.elm --output main.js
```

---

Now, let write the **Picshare** static application together.

```bash
cd ./1-static-app
```

---
# Write your SPA web application
---

## Elm Architecture <!-- element class="left-al" -->

Elm Architecture have three parts: Model, View, and Update. <!-- element class="left-al" -->

![[Pasted image 20220703133959.png]]

---

![[Pasted image 20220703134019.png]]

---
## Record Type

```elm
> dog = { name = "Tucker", age = 11 }
{ age = 11, name = "Tucker" } : { age : number, name: String }

initialModel : { name : String, age : Int }
initialModel =
  { name = "Huy Phung"
  , age = 30
  }
```
---
## Type Alias
```elm
type alias Model =
  { name : String
  , age : Int
  }

initialModel : Model
initialModel =
  { name = "Huy Phung"
  , age = 30
  }
```
---
<!-- .slide: class="left-al"" -->

## Type Variable and Concrete Type

```elm
view : Html msg
view = div [] []

type Msg = Click
view : Html Msg
view = div [ onClick Click ] []
```
- The first view does not produce any events. So its type variable is not bound to anything.
- The second view produces events of your `Msg` type, and its type variable is bound to that.
---
<!-- .slide: class="left-al"" -->

Now, let's write the **Picshare** spa application together. We will:
- Use the record type, and type alias to create the initial model
- Add a love button
- Add comments

```bash
cd ./2-spa-app
```
---
# Communicate via HTTP
---
## Decoder <!-- element class="left-al" -->

The HTTP response is JSON data. We should not trust the data from the outside. So, we need a JSON Decoder to convert the JSON data to the valid data we use in our Elm application. <!-- element class="left-al" -->

```json
{
  "id": 1,
  "url": "https://programming-elm.surge.sh/1.jpg",
  "caption": "Surfing",
  "liked": false,
  "comments": ["Cowabunga, dude!"],
  "username": "surfing_usa"
}
```

---
## Decoder

```elm
> import Json.Decode exposing (decodeString, bool, int, string)

> decodeString
<function>
    : Json.Decode.Decoder a -> String -> Result Json.Decode.Error a
```
---
<!-- .slide: class="left-al"" -->

## Result Type

The **Result** type is a built-in custom type with two constructor `Ok` and `Err`. This is how it's defined in Elm:

```elm
type Result error value
  = Ok value
  | Err error
```
---
## Decode fields

```elm
> import Json.Decode exposing (decodeString, bool, field, int, list, string)

> decodeString bool "true"
Ok True : Result Json.Decode.Error Bool

> decodeString string "\"Elm is Awesome\""
Ok ("Elm is Awesome") : Result Json.Decode.Error String

> decodeString (list int) "[1, 2, 3]"
Ok [1,2,3] : Result Json.Decode.Error (List Int)

> decodeString (field "name" string) """{"name": "Tucker"}"""
Ok "Tucker" : Result Json.Decode.Error String
```

---
## Decode an object

``` elm
> import Json.Decode exposing (decodeString, int, string, succeed)
> import Json.Decode.Pipeline exposing (required)

required : String -> Decoder a -> Decoder (a -> b) -> Decoder b
succeed : a -> Json.Decode.Decoder a
```

---
## Decode an object

```elm
> dog name age = { name = name, age = age }
<function> : a -> b -> { age : b, name : a }
> succeed dog
<internals> : Json.Decode.Decoder (a -> b -> { age : b, name : a })

> dogDecoder =
  succeed dog
    |> required "name" string
    |> required "age" int
<internals> : Json.Decode.Decoder { age : Int, name : String }
```

---
## Write the Photo Decoder

```elm
type alias Id =
    Int

type alias Photo =
    { id : Id
    , url : String
    , caption : String
    , liked : Bool
    , comments : List String
    , newComment : String
    }

type alias Model =
    Photo
```

---
## Write the Photo Decoder

```elm
photoDecoder : Decoder Photo
photoDecoder =
    succeed Photo
        |> required "id" int
        |> required "url" string
        |> required "caption" string
        |> required "liked" bool
        |> required "comments" (list string)
        |> hardcoded ""
```

---
## Test the Photo Decoder

```elm
> import Picshare exposing (photoDecoder)
> import Json.Decode exposing (decodeString)
> decodeString photoDecoder """
    { "id": 1
    , "url": "https://programming-elm.surge.sh/1.jpg"
    , "caption": "Surfing"
    , "liked": false
    , "comments": ["Nước mắt em lau bằng tình yêu mới u ú ú u ù"]
    , "unknown key": "Tất nhiên là đỡ được"
    } \
    """
```

---
<!-- .slide: class="left-al"" -->

## Http Package

Read the information of this package here: https://package.elm-lang.org/packages/elm/http/latest/Http

```elm
import Http

fetchFeed : Cmd Msg
fetchFeed =
    Http.get
      { url: baseUrl ++ "feed/1"
      , expect = Http.expectJson LoadFeed photoDecoder
      }
```

---
<!-- .slide: class="left-al"" -->

## Command Type

The **Cmd** type represents a command in Elm. Commands are special values that instruct the Elm Architecture to perform actions such as sending HTTP requests.

---
<!-- .slide: class="left-al"" -->

Elm separates creating HTTP requests from sending HTTP requests.

To communicate with the outside world, your application gives commands to the Elm Architecture. Elm will handle the command and eventually deliver the result back to your application.

---

![[Pasted image 20220703230022.png]]

---
<!-- .slide: class="left-al"" -->

## Safety Handle Null using Maybe type

The Maybe type perfectly represents a value that may or may not exist. If the value exists, then you have just that value. If the value doesn’t exist, then you have nothing.

```elm
type Maybe a
  = Just a
  | Nothing
```

---
<!-- .slide: class="left-al"" -->

## Practice at Home

You could enter the folder "real-time" in the current repository. Then open this [book](https://www.notion.so/holistics/Programming-Elm-9f92b769efce4e00b836de54b5b03eca#ec224131c2b04701af47039caa925fda) and continue the implementation from Chapter 5.

---
# Read more
---
<!-- .slide: class="left-al"" -->
## Virtual DOM in Elm

Check my blog for this: https://huyphung.one/posts/2022-03-26-virtual-dom-in-elm/

---
## Development and Deployment

Check my blog for this: https://huyphung.one/posts/2022-04-14-my-setup-for-elm-application/

---
## References
- https://guide.elm-lang.org/
- https://elmprogramming.com/conventions-used-in-the-book.html
- https://pragprog.com/titles/jfelm/programming-elm/
- https://huyphung.one

---
![[a6OeW82_700bwp.webp]]

---
![[a9KwK6L_700bwp.webp]]