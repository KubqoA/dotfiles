{ lib, ... }:

let
  inherit (builtins) elemAt listToAttrs substring;
  inherit (lib) concatStringsSep fixedWidthString nameValuePair
                stringToCharacters sublist toInt toUpper zipListsWith;
  inherit (lib._) joinWithSep;
in rec {
  /* Converts a hex color string to RGB triplet, an array of exactly 3 elements

     Type:
       toRGB :: String -> [Int]

     Example:
       toRGB "ffFFff"
       => [ 255 255 255 ]
  */
  toRGB = hex: let
    chars = stringToCharacters hex;
    r = sublist 0 2 chars;
    g = sublist 2 2 chars;
    b = sublist 4 2 chars;
    /* Converts a pair of characters (array of two strings, each of one char
       long) in hexadecimal to a number. Expects a valid hexadecimal string.

       Type:
         hexPairToNum :: [String] -> Int
       
       Example:
         hexPairToNum [ "F" "1" ]
         => 241
    */
    hexPairToNum = pair: let
      c1 = elemAt pair 0; c2 = elemAt pair 1;
      hexMapping = {
        "A" = 10;
        "B" = 11;
        "C" = 12;
        "D" = 13;
        "E" = 14;
        "F" = 15;
      };
      toNum = c: if hexMapping ? ${toUpper c} then hexMapping.${toUpper c} else toInt c;
    in 16 * (toNum c1) + (toNum c2);
  in [
    (hexPairToNum r)
    (hexPairToNum g)
    (hexPairToNum b)
  ];

  /* Both ‹hexColor› and ‹rgbColor› accept a color in 6 char long hexadecimal
     representation. Their variants ‹hexColor'› and ‹rgbaColor› accept an
     additional parameter ‹opacity› specified as an int in range from 0 to 100.
  */
  
  /* Type:
       hexColor :: String -> String
     
     Example:
       hexColor "FECACA"
       => "#FECACA"
  */
  hexColor = color: "#" + color;

  /* Type:
       hexColor' :: String -> Int -> String
     
     Example:
       hexColor' "FECACA" 54
       => "#FECACA54"
  */
  hexColor' = color: opacity: "#" + color + toString opacity;

  _rgbColor = color: extra: "(" + (joinWithSep ((toRGB color) ++ extra) ", ") + ")";

  /* Type:
       rgbColor :: String -> String
     
     Example:
       rgbColor "FFFFFF"
       => "rgb(255, 255, 255)"
  */
  rgbColor = color: "rgb" + _rgbColor color [];

  /* Type:
       rgbaColor :: String -> Int -> String
     
     Example:
       rgbaColor "FFFFFF" 42
       => "rgba(255, 255, 255, 0.42)"
  */
  rgbaColor = color: _opacity: let
    opacityStr = fixedWidthString 3 "0" (toString _opacity);
    opacity = substring 0 1 opacityStr + "." + substring 1 2 opacityStr;
  in "rgba" + _rgbColor color [opacity];

  /* ‹colors› defines a color palette according to the Tailwind colors:
     https://tailwindcss.com/docs/customizing-colors#color-palette-reference

     Each individual color has 10 variants, for example to access the variant
     ‹700› of color ‹red› following notation is used: ‹colors.red._700›

     The ‹_› in front of the variant is there because numbers cannot be
     used as keys.
  */
  colors = let
    scaleDef = [ 50 100 200 300 400 500 600 700 800 900 ];
    scale = s: listToAttrs (zipListsWith (variant: color: nameValuePair "_${toString variant}" color) scaleDef s);
  in rec {
    # Default palette
    coolGray = scale [ "F9FAFB" "F3F4F6" "E5E7EB" "D1D5DB" "9CA3AF" "6B7280" "4B5563" "374151" "1F2937" "111827" ];
    red      = scale [ "FEF2F2" "FEE2E2" "FECACA" "FCA5A5" "F87171" "EF4444" "DC2626" "B91C1C" "991B1B" "7F1D1D" ];
    amber    = scale [ "FFFBEB" "FEF3C7" "FDE68A" "FCD34D" "FBBF24" "F59E0B" "D97706" "B45309" "92400E" "78350F" ];
    emerald  = scale [ "ECFDF5" "D1FAE5" "A7F3D0" "6EE7B7" "34D399" "10B981" "059669" "047857" "065F46" "064E3B" ];
    blue     = scale [ "EFF6FF" "DBEAFE" "BFDBFE" "93C5FD" "60A5FA" "3B82F6" "2563EB" "1D4ED8" "1E40AF" "1E3A8A" ];
    indigo   = scale [ "EEF2FF" "E0E7FF" "C7D2FE" "A5B4FC" "818CF8" "6366F1" "4F46E5" "4338CA" "3730A3" "312E81" ];
    violet   = scale [ "F5F3FF" "EDE9FE" "DDD6FE" "C4B5FD" "A78BFA" "8B5CF6" "7C3AED" "6D28D9" "5B21B6" "4C1D95" ];
    pink     = scale [ "FDF2F8" "FCE7F3" "FBCFE8" "F9A8D4" "F472B6" "EC4899" "DB2777" "BE185D" "9D174D" "831843" ];

    # Extra
    blueGray = scale [ "F8FAFC" "F1F5F9" "E2E8F0" "CBD5E1" "94A3B8" "64748B" "475569" "334155" "1E293B" "0F172A" ];

    # Aliases
    gray   = coolGray;
    yellow = amber;
    green = emerald;
    purple = violet;
  };
}
