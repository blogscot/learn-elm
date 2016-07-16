import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)
import Random


main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL


type alias Model =
  { firstDie : Int
  , secondDie : Int
  }


init : (Model, Cmd Msg)
init =
  (Model 1 1, Cmd.none)


-- UPDATE


type Msg
  = Roll
  | NewFaces (Int, Int)


dieGenerator : Int -> Int -> Random.Generator Int
dieGenerator n m =
  Random.int n m

diePairGenerator : Int -> Int -> Random.Generator (Int, Int)
diePairGenerator a b =
  Random.pair (dieGenerator 1 a) (dieGenerator 1 b)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFaces (diePairGenerator 10 12))

    NewFaces (first, second) ->
      (Model first second, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (toString model.firstDie ++ " " ++ toString model.secondDie) ]
    , button [ onClick Roll ] [ text "Roll" ]
    ]

