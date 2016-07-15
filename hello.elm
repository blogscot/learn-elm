import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String exposing (..)
import Regex exposing (..)


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , showValidation : Bool
  }


model : Model
model =
  Model "" "" "" False


-- UPDATE

type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | ValidateForm


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    ValidateForm ->
      { model | showValidation = True }



-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ type' "text", placeholder "Name", onInput Name ] []
    , input [ type' "password", placeholder "Password", onInput Password ] []
    , input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , Html.br [] []
    , button [onClick ValidateForm ] [text "Submit"]
    , viewValidation model
    ]


containsNumbers : String -> Bool
containsNumbers text =
  Regex.contains(regex "[0-9]") text


containsMixedCase : String -> Bool
containsMixedCase text =
  if String.length text == 0 then
    False
  else if String.toLower text == text then
    False
  else
    True

viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if not model.showValidation then
        ("green", "OK")
      else if not (containsMixedCase model.password) || not (containsNumbers model.password) then
        ("red", "Passwords should contain both upper, lower case letters plus numbers.")
      else if String.length model.password < 8 then
        ("red", "Minimum password length is 8")
      else if model.password == model.passwordAgain then
        ("green", "OK")
      else
        ("red", "Passwords do not match!")
  in
    div [ style [("color", color)] ] [ text message ]

