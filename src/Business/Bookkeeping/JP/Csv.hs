{- |
Module      :  Business.Bookkeeping.JP.Csv

Copyright   :  Kadzuya Okamoto 2017
License     :  MIT

Stability   :  experimental
Portability :  unknown

This module exports functions to produce CSV-formatted texts for Japanese people.
-}
{-# LANGUAGE NoImplicitPrelude #-}

module Business.Bookkeeping.JP.Csv
  ( fromTransactions
  ) where

import Business.Bookkeeping
import Data.MonoTraversable.Unprefixed (intercalate)
import Data.Semigroup ((<>))
import Data.Sequences (pack, unlines)
import Data.Text (Text)
import Data.Time.Format (defaultTimeLocale, formatTime)
import Prelude hiding (unlines)

{-| Produce CSV-formatted texts from `Transactions` value.
-}
fromTransactions :: Transactions -> Text
fromTransactions =
  unlines . (transactionHeader:) . fmap transactionBody . zip [1..] . runTransactions

transactionBody :: (Int, Journal) -> Text
transactionBody (n, Journal {..}) =
  intercalate ","
    [ tshow n
    , tshow $ formatTime defaultTimeLocale "%Y/%m/%d" tDay
    , formatText . unCategoryName . cName . unDebitCategory $ tDebit
    , maybe "" formatText . unCategorySubName . cName . unDebitCategory $ tDebit
    , formatText . unCategoryName . cName . unCreditCategory $ tCredit
    , maybe "" formatText . unCategorySubName . cName . unCreditCategory $ tCredit
    , formatText . unDescription $ tDescription
    , formatText . unSubDescription $ tSubDescription
    , tshow $ unAmount tAmount
    ]

formatText :: Text -> Text
formatText = (<> "\"") . ("\"" <>)

transactionHeader :: Text
transactionHeader =
  intercalate ","
    [ formatText "取引No"
    , formatText "取引日"
    , formatText "借方勘定科目"
    , formatText "借方補助勘定科目"
    , formatText "貸方勘定科目"
    , formatText "貸方補助勘定科目"
    , formatText "摘要"
    , formatText "細目"
    , formatText "貸借金額"
    ]

tshow :: Show a => a -> Text
tshow = pack . show
