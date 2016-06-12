module PseudoMap where

import Prelude hiding (lookup)
data Map k a = Map [(k,a)]

empty :: Map k a
empty = Map []

insert :: Eq k =>  k -> a -> Map k a -> Map k a
insert key val (Map []) = Map [(key,val)]
insert key val (Map (x@(key',val'):xs)) = 
  if key == key' 
  then Map ((key,val):xs)
  else Map (x:toList (insert key val (Map xs)))

lookup :: Eq k => k -> Map k a -> Maybe a
lookup key org_map = 
  case (filter (\(k,v) -> key == k ) $ toList org_map) of
  [] -> Nothing
  (k',v'):_ -> Just v'

singlton :: k -> v -> Map k v
singlton k v = Map [(k,v)]

alter :: Eq k => (Maybe a -> Maybe a) -> k -> Map k a -> Map k a
alter alt key (Map []) =
  case (alt Nothing) of
  Nothing -> Map []
  Just val' -> Map [(key,val')]
alter alt key (Map (x@(key',val):xs)) =
  if key == key' 
  then case (alt (Just val)) of
       Nothing -> Map xs
       Just val' -> Map ((key,val'):xs)
  else Map (x:toList (alter alt key (Map xs)))

toList :: Map k a -> [(k,a)]
toList (Map xs) = xs

fromList :: [(k,a)] -> Map k a
fromList xs = Map xs

