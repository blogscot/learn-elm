import Html exposing (Html, div, button)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Html.App as App
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

type alias Model =
  { time : Time
   , pause : Bool
 }

init : (Model, Cmd Msg)
init =
  (Model 0 False, Cmd.none)


-- UPDATE

type Msg
  = Tick Time
  | Pause Bool

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ({ model | time = newTime }, Cmd.none)

    Pause state ->
      ({model | pause = state }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  if model.pause then
    Sub.none
  else
    Time.every second Tick



-- VIEW

view : Model -> Html Msg
view model =
  let
    ninetyDegrees = pi / 2
    secondAngle = turns (Time.inMinutes model.time) - ninetyDegrees
    minuteAngle = turns (Time.inHours model.time) - ninetyDegrees
    -- hour hand should rotate once every 12 hours
    hourAngle = turns (Time.inHours model.time / 12) - ninetyDegrees

    secondHandX = toString <| 50 + 40 * cos secondAngle
    secondHandY = toString <| 50 + 40 * sin secondAngle

    minuteHandX = toString <| 50 + 35 * cos minuteAngle
    minuteHandY = toString <| 50 + 35 * sin minuteAngle

    hourHandX = toString <| 50 + 30 * cos hourAngle
    hourHandY = toString <| 50 + 30 * sin hourAngle

  in
    div [ clockStyle ] [
      svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#2B89aE" ] []
      , line [ x1 "50", y1 "50", x2 hourHandX, y2 hourHandY, stroke "#f2f900" ] []
      , line [ x1 "50", y1 "50", x2 minuteHandX, y2 minuteHandY, stroke "#e28963" ] []
      , line [ x1 "50", y1 "50", x2 secondHandX, y2 secondHandY, stroke "#fff" ] []
      ],
      button [ onClick <| Pause <| not model.pause] [ text "Pause"]
    ]

clockStyle : Attribute msg
clockStyle =
  Html.Attributes.style
    [ ("width", "20%")
    , ("margin", "0 auto")
    ]
