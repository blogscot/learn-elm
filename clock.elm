import Html exposing (Html, div)
import Html.App as App
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second, hour)
import Debug exposing (log)

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model = Time

init : (Model, Cmd Msg)
init =
  (0, Cmd.none)


-- UPDATE

type Msg
  = Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick


-- VIEW

view : Model -> Html Msg
view model =
  let
    vertialOffset = pi / 2
    secondAngle = turns (Time.inMinutes model) - vertialOffset
    minuteAngle = turns (Time.inHours model) - vertialOffset
    hourAngle = turns (Time.inHours model) / 24 + vertialOffset

    secondHandX = toString <| 50 + 40 * cos secondAngle
    secondHandY = toString <| 50 + 40 * sin secondAngle

    minuteHandX = toString <| 50 + 35 * cos minuteAngle
    minuteHandY = toString <| 50 + 35 * sin minuteAngle

    hourHandX = toString <| 50 + 30 * cos hourAngle
    hourHandY = toString <| 50 + 30 * sin hourAngle

  in
    div [] [
      svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 hourHandX, y2 hourHandY, stroke "#023963" ] []
      , line [ x1 "50", y1 "50", x2 minuteHandX, y2 minuteHandY, stroke "#023963" ] []
      , line [ x1 "50", y1 "50", x2 secondHandX, y2 secondHandY, stroke "#fff" ] []
      ]
    ]
