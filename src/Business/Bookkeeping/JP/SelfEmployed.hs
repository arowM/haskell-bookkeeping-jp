{- |
Module      :  Business.Bookkeeping.JP.SelfEmployed

Copyright   :  Kadzuya Okamoto 2017
License     :  MIT

Stability   :  experimental
Portability :  unknown

This module exports l10n functions for self employed Japanese people.
-}
module Business.Bookkeeping.JP.SelfEmployed
  (
  -- * Helper functions for expenses
  -- $expences
    _旅費交通費
  , _通信費
  , _接待交際費
  , _支払手数料
  , _消耗品費
  , _新聞図書費
  , _会議費
  , _外注工費
  , _雑費
  -- ** Lower level functions
  , _経費

  -- * Helper functions for sales
  -- $sales
  , _売上発生
  , _売上入金
  , _売上
  , _即日売上
  , _源泉所得税
  ) where

import Business.Bookkeeping

{- $expences
  経費の支払いに使うヘルパ関数群.
>>> :{
ppr $ year 2015 $ do
  month 1 $ do
    activity 2 "ジャパリパーク取材" $ do
      _旅費交通費 340
      _消耗品費 "入場料" 1000
      _消耗品費 "ジャパリバス乗車料" 400
      _消耗品費 "ジャパリまん" 200
    activity 20 "ジャパリパーク商談" $
      _旅費交通費 340
:}
tDay: 2015-01-02
tDescription: ジャパリパーク取材
tSubDescription: 
tDebit: 旅費交通費 (Expenses)
tCredit: 事業主借 (Liabilities)
tAmount: 340
<BLANKLINE>
tDay: 2015-01-02
tDescription: ジャパリパーク取材
tSubDescription: 入場料
tDebit: 消耗品費 (Expenses)
tCredit: 事業主借 (Liabilities)
tAmount: 1000
<BLANKLINE>
tDay: 2015-01-02
tDescription: ジャパリパーク取材
tSubDescription: ジャパリバス乗車料
tDebit: 消耗品費 (Expenses)
tCredit: 事業主借 (Liabilities)
tAmount: 400
<BLANKLINE>
tDay: 2015-01-02
tDescription: ジャパリパーク取材
tSubDescription: ジャパリまん
tDebit: 消耗品費 (Expenses)
tCredit: 事業主借 (Liabilities)
tAmount: 200
<BLANKLINE>
tDay: 2015-01-20
tDescription: ジャパリパーク商談
tSubDescription: 
tDebit: 旅費交通費 (Expenses)
tCredit: 事業主借 (Liabilities)
tAmount: 340
<BLANKLINE>
-}
_旅費交通費 :: Amount -> DateTransactions
_旅費交通費 = _経費 "旅費交通費" ""
_通信費 :: SubDescription -> Amount -> DateTransactions
_通信費 = _経費 "通信費"
_接待交際費 :: SubDescription -> Amount -> DateTransactions
_接待交際費 = _経費 "接待交際費"
_支払手数料 :: SubDescription -> Amount -> DateTransactions
_支払手数料 = _経費 "支払手数料"
_消耗品費 :: SubDescription -> Amount -> DateTransactions
_消耗品費 = _経費 "消耗品費"
_新聞図書費 :: SubDescription -> Amount -> DateTransactions
_新聞図書費 = _経費 "新聞図書費"
_会議費 :: SubDescription -> Amount -> DateTransactions
_会議費 = _経費 "会議費"
_外注工費 :: SubDescription -> Amount -> DateTransactions
_外注工費 = _経費 "外注工賃"
_雑費 :: SubDescription -> Amount -> DateTransactions
_雑費 = _経費 "雑費"

{-| 事業主が経費を支払った場合に使う関数.
-}
_経費 :: CategoryName -> SubDescription -> Amount -> DateTransactions
_経費 name = dateTrans
  (DebitCategory $ Category name Expenses)
  (CreditCategory $ Category "事業主借" Liabilities)


{- $sales
  売上があった場合に使うヘルパ関数群.
>>> :{
let
  _ジャパリパーク技術顧問料 :: Month -> Date -> YearTransactions
  _ジャパリパーク技術顧問料 m d =
    month m $ do
      _即日売上 d "ジャパリパーク技術顧問料" 600000
      _源泉所得税 d "ジャパリパーク技術顧問料" 50000
in ppr $ year 2015 $ do
  _売上 (2, 20) (2, 28) "ジャパリパーク ラッキービースト改修費" 200000
  _ジャパリパーク技術顧問料 3 31
  _ジャパリパーク技術顧問料 4 30
  _ジャパリパーク技術顧問料 5 31
:}
tDay: 2015-02-20
tDescription: ジャパリパーク ラッキービースト改修費
tSubDescription: 売上発生
tDebit: 売掛金 (Assets)
tCredit: 売上高 (Revenue)
tAmount: 200000
<BLANKLINE>
tDay: 2015-02-28
tDescription: ジャパリパーク ラッキービースト改修費
tSubDescription: 売上入金
tDebit: 事業主貸 (Assets)
tCredit: 売掛金 (Revenue)
tAmount: 200000
<BLANKLINE>
tDay: 2015-03-31
tDescription: ジャパリパーク技術顧問料
tSubDescription: 売上/入金
tDebit: 事業主貸 (Assets)
tCredit: 売上高 (Revenue)
tAmount: 600000
<BLANKLINE>
tDay: 2015-03-31
tDescription: ジャパリパーク技術顧問料
tSubDescription: 源泉所得税
tDebit: 事業主貸 (Assets)
tCredit: 売上高 (Revenue)
tAmount: 50000
<BLANKLINE>
tDay: 2015-04-30
tDescription: ジャパリパーク技術顧問料
tSubDescription: 売上/入金
tDebit: 事業主貸 (Assets)
tCredit: 売上高 (Revenue)
tAmount: 600000
<BLANKLINE>
tDay: 2015-04-30
tDescription: ジャパリパーク技術顧問料
tSubDescription: 源泉所得税
tDebit: 事業主貸 (Assets)
tCredit: 売上高 (Revenue)
tAmount: 50000
<BLANKLINE>
tDay: 2015-05-31
tDescription: ジャパリパーク技術顧問料
tSubDescription: 売上/入金
tDebit: 事業主貸 (Assets)
tCredit: 売上高 (Revenue)
tAmount: 600000
<BLANKLINE>
tDay: 2015-05-31
tDescription: ジャパリパーク技術顧問料
tSubDescription: 源泉所得税
tDebit: 事業主貸 (Assets)
tCredit: 売上高 (Revenue)
tAmount: 50000
<BLANKLINE>
-}

{-| 売上発生を記帳するためのヘルパ関数.
-}
_売上発生 :: Date -> Description -> Amount -> MonthTransactions
_売上発生 d0 desc amount =
  activity d0 desc $
    dateTrans
      (DebitCategory $ Category "売掛金" Assets)
      (CreditCategory $ Category "売上高" Revenue)
      "売上発生"
      amount

{-| 売上入金を記帳するためのヘルパ関数.
-}
_売上入金 :: Date -> Description -> Amount -> MonthTransactions
_売上入金 d0 desc amount =
  activity d0 desc $
    dateTrans
      (DebitCategory $ Category "事業主貸" Assets)
      (CreditCategory $ Category "売掛金" Revenue)
      "売上入金"
      amount

{-| 売上を記帳するためのヘルパ関数.
  売上発生日と、実際の入金日が異なる場合に用いる.
  最終的な入金先は、簡単のため事業主貸としてあつかう.
-}
_売上 :: (Month, Date) -- ^ 売上発生日
      -> (Month, Date) -- ^ 売上入金日
      -> Description -> Amount -> YearTransactions
_売上 (m0, d0) (m1, d1) desc amount = do
  month m0 $
    _売上発生 d0 desc amount
  month m1 $
    _売上入金 d1 desc amount

{-| 売上を記帳するためのヘルパ関数.
  売上発生日に入金がある場合に用いる.
  最終的な入金先は、簡単のため事業主貸としてあつかう.
-}
_即日売上 :: Date -> Description -> Amount -> MonthTransactions
_即日売上 d0 desc amount =
  activity d0 desc $
    dateTrans
      (DebitCategory $ Category "事業主貸" Assets)
      (CreditCategory $ Category "売上高" Revenue)
      "売上/入金"
      amount

{-| 売上から源泉徴収された際に、その源泉徴収額を記帳するためのヘルパ関数.
-}
_源泉所得税 :: Date -> Description -> Amount -> MonthTransactions
_源泉所得税 d0 desc amount =
  activity d0 desc $
    dateTrans
      (DebitCategory $ Category "事業主貸" Assets)
      (CreditCategory $ Category "売上高" Revenue)
      "源泉所得税"
      amount
