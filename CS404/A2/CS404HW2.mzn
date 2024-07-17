
%INPUTS

int: rows = 7;
int: cols = 7;
array[1..rows, 1..cols] of int: start;

int: numIslands = sum(i in 1..rows, j in 1..cols) (start[i,j] > 0);
array[1..numIslands] of tuple(int, int): islands =  [ (i,j) | i in 1..rows, j in 1..cols where start[i, j] > 0];
array[1..numIslands] of int: bridges =  [start[i,j] | i in 1..rows, j in 1..cols where start[i, j] > 0];


%% SHOW INITIAL GRID
output ["| " ++ join(" ", [show(start[i, j])| j in 1..cols]) ++ " |\n"| i in 1..rows];

%% CONSTRAINTS
array[1..numIslands, 1..numIslands] of var 0..2: bridgesBetween;

%% The islands that does not share a row or column cannot have a bridge.
constraint forall(i in 1..numIslands, j in 1..numIslands)(
let{
  var bool: same = (islands[i].1 = islands[j].1) /\ (islands[i].2 = islands[j].2);
  var bool: sameRowOrCol = (islands[i].1 = islands[j].1) \/ (islands[i].2 = islands[j].2);
} in (
  if same = true then
    bridgesBetween[i, j] = 0
  else  
    if sameRowOrCol = true then
      bridgesBetween[i, j] <= min(bridges[i], bridges[j])
    else
      bridgesBetween[i, j] = 0
  endif
  endif
  )
);

% Bridge count for an island should be equal to the number of bridges as given in the input.
constraint forall(i in 1..numIslands)(
  bridges[i] = sum([bridgesBetween[i, j] | j in 1..numIslands])
);

% Bridges are symetric
constraint forall(i in 1..numIslands, j in i+1..numIslands)(
  bridgesBetween[i,j] = bridgesBetween[j,i]
);


% A bridge cannot intersect with another bridge.
constraint forall(i in 1..numIslands, j in 1..numIslands)(
if bridgesBetween[i, j] > 0 then
let{
  var int: r1 = min(islands[i].1, islands[j].1);
  var int: c1 = min(islands[i].2, islands[j].2);
  var int: r2 = max(islands[i].1, islands[j].1);
  var int: c2 = max(islands[i].2, islands[j].2);
  var bool: sameR = r1 = r2;
  var bool: sameC = c1 = c2;
} in (
    forall(k in 1..numIslands, l in 1..numIslands)(
    if k != l then % they should not share an edge
      let {
          var int: r3 = min(islands[k].1, islands[l].1);
          var int: c3 = min(islands[k].2, islands[l].2);
          var int: r4 = max(islands[k].1, islands[l].1);
          var int: c4 = max(islands[k].2, islands[l].2);
          var bool: sameRp = r3 = r4;
          var bool: sameCp = c3 = c4;
          
          var bool: difference = (k != i /\ k != j /\ l != i /\ l!= j);
          var bool: rowBetween = (r1 <= r3 /\ r3 <= r2); % if sameC
          var bool: colBetween = (c1 <= c3 /\ c3 <= c2); % if sameR
          var bool: rowMiddle = (r3 <= r1 /\ r1 <= r4); % if sameR
          var bool: colMiddle = (c3 <= c1 /\ c1 <= c4); % if sameC
          
          var bool: difference2 = not ((k == i /\ l == j) \/ (k == j /\ l == i));
          var bool: rowColIntersection = (sameR /\ sameCp /\ colBetween /\ rowMiddle /\ difference);
          var bool: colRowIntersection = (sameC /\ sameRp /\ rowBetween /\ colMiddle /\ difference);
          var bool: rowRowIntersection = (sameR /\ sameRp /\ r1 = r3 /\ (colBetween \/ colMiddle) /\ (c1 != c4 /\ c2 != c3 /\ difference2));
          var bool: colColIntersection = (sameC /\ sameCp /\ c1 = c3 /\ (rowBetween \/ rowMiddle) /\ (r1 != r4 /\ r2 != r3 /\ difference2));
          
      } in (
      if rowColIntersection \/ colRowIntersection \/ rowRowIntersection \/ colColIntersection then
      bridgesBetween[k, l] = 0
      endif
      )
      endif)
    )
endif
);



%% All Islands should be connected.
function var bool: checkConnected(array[int, int] of var int: bridgesBetween, int: start, int: finish, set of int: visited) = 
if start = finish then
true
else
exists(i in 1..numIslands)(
 bridgesBetween[start, i] > 0  /\ not (i in visited) /\ checkConnected(bridgesBetween, i, finish, visited union {start}))
endif;

constraint forall(i in 1..numIslands)(
  checkConnected(bridgesBetween, 1, i, {}) = true
);


%0 means .
%1 means island
%2 means -
%3 means |
%4 means =
%5 means x


array[1..rows, 1..cols] of var 0..5: results;

constraint forall(i in 1..rows, j in 1..cols)(
  if start[i,j] > 0 then
  results[i,j] = 1 
  endif
);

constraint forall(i in 1..numIslands, j in i+1..numIslands)(
let {
  var int: r1 = min(islands[i].1, islands[j].1);
  var int: c1 = min(islands[i].2, islands[j].2);
  var int: r2 = max(islands[i].1, islands[j].1);
  var int: c2 = max(islands[i].2, islands[j].2);
  
  var bool: sameR = r1 = r2;
  var bool: sameC = c1 = c2;
}in
(
  if bridgesBetween[i,j] > 0 then
    if sameR then
    forall(k in c1+1..c2-1)(
     if bridgesBetween[i, j] == 1 then
     results[r1,k]=2
     else
     results[r1,k]=4
     endif
    )
    else
    if sameC then
      forall(k in r1+1..r2-1)(
       if bridgesBetween[i, j] == 1 then
       results[k,c1]=3
       else
       results[k,c1]=5
       endif
      )
    endif
    endif
  endif
)
);



solve satisfy;
output ["\n\n"];
output ["[ " ++ join(", ", [show(bridgesBetween[i,j])| j in 1..numIslands]) ++ " ],\n"| i in 1..numIslands];

output [ show(islands) ];
output ["\n\nResult Matrix:\n"] ++ ["| " ++ join(" ", [
let{
 var int: num = results[i,j]
 } in 
 (
if fix(num = 0) then 
"." 
else 
  if fix(num = 1) then 
  show(start[i,j])
  else
    if fix(num = 2) then
    "-"
    else
      if fix(num = 3) then
      "|"
      else
        if fix(num = 4) then
        "="
        else
        "x"
        endif
      endif
    endif
  endif
endif
)
| j in 1..cols]) ++ " |\n"| i in 1..rows];


