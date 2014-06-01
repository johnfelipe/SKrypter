.pragma library

//globar color definitions, from light (1) to dark (4)

var green1 = "#abffbc"
var green2 = "#73ff8f"
var green3 = "#44CC5F"
var green4 = "#1ca938"

var orange1 = "#ffcd90"
var orange2 = "#ffb254"
var orange3 = "#FF8C00"
var orange4 = "#ff7a00"

var blue0 = "#e2f2ff"
var blue1 = "#b4ddff"
var blue2 = "#7fb6e4"
var blue3 = "#4682B4"
var blue4 = "#0b5da2"

var pink1 = "#ffa9e5"
var pink2 = "#eb6ea0"
var pink3 = "#eb4387"
var pink4 = "#db0058"

var gray1 = "#dcdcdc"
var gray2 = "#c0c0c0"
var gray3 = "#a4a4a4"
var gray4 = "#888888"

//languages
var language_list = ["de", "en", "es", "fr", "it"] //these are all languages for the exercises
var supported_system_languages = ["de", "en"] //these are all languages that SKrypter is translated in
var alphabet_length = 26

//calculated using KdCalculator program with same corpus as used for calculating stats
var kd = {"de": 0.0752105, "en": 0.0646765, "es": 0.0747913, "fr": 0.077541, "it": 0.0738442}
var kg = 1.0/alphabet_length
