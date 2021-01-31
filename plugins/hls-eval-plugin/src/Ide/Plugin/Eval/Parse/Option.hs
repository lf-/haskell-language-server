{-# OPTIONS_GHC -Wwarn #-}

-- | GHC language options parser
module Ide.Plugin.Eval.Parse.Option (
    langOptions,
) where

import Control.Monad.Combinators (many)
import Text.Megaparsec.Char
import Text.Megaparsec
import Data.Void (Void)
import Control.Arrow (left)

{- |
>>> langOptions ":set   -XBinaryLiterals  -XOverloadedStrings "
Right ["BinaryLiterals","OverloadedStrings"]

>>> langOptions ":set"
Right []

>>> langOptions ""
Left "No match"
-}
langOptions :: String -> Either String [String]
langOptions =
  left errorBundlePretty
  . parse (space *> languageOpts <* eof) ""

-- >>> parseMaybe languageOpts ":set -XBinaryLiterals -XOverloadedStrings"
-- Just ["BinaryLiterals","OverloadedStrings"]
languageOpts :: Parsec Void String [String]
languageOpts = string ":set" *> space1
  *> many (string "-X" *> many letterChar <* space)
