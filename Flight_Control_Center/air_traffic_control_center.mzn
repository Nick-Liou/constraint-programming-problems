% Flight Control Center
include "globals.mzn";
enum CONTROL_SHIFT = {MORNING,AFTERNOON,NIGHT,OFF};

int : air_t_controllers ;
set of int: CONTROLLERS = 1..air_t_controllers;
set of int: DAYS = 1..7;

%% Some Decision Vars 
array[CONTROLLERS,DAYS] of var CONTROL_SHIFT: roster;
array[CONTROLLERS] of var int: work;
var 0..4*7: gap;


int: ns = 5;
set of int : STATE = 1..ns;
array[STATE,CONTROL_SHIFT] of opt STATE: allowed = 
%   MORNING  AFTERNOON   NIGHT    OFF
[|    2,        3,        <>,      5
 |    3,        4,        <>,      5
 |    4,       <>,        <>,      5
 |   <>,       <>,        <>,      5
 |    1,        2,         4,      5 |];

constraint forall (i in CONTROLLERS)
(regular( enum2int( row(roster,i)) , allowed, 5, STATE ));

% Check shifts per controller:
constraint forall(i in CONTROLLERS)(count_leq([roster[i,d] | d in DAYS], MORNING  , 1));
constraint forall(i in CONTROLLERS)(count_leq([roster[i,d] | d in DAYS], AFTERNOON, 1));
constraint forall(i in CONTROLLERS)(count_leq([roster[i,d] | d in DAYS], NIGHT    , 1));

% Check controllers per shift:
constraint forall(d in DAYS)(count_leq([roster[i,d] | i in CONTROLLERS], MORNING  , 3));
constraint forall(d in DAYS)(count_leq([roster[i,d] | i in CONTROLLERS], AFTERNOON, 2));
constraint forall(d in DAYS)(count_leq([roster[i,d] | i in CONTROLLERS], NIGHT    , 1));
% Alternative way to write the same thing
% constraint forall(d in DAYS)(count_leq( col(roster,d), MORNING , 3));
% constraint forall(d in DAYS)(sum([roster[i,d] == MORNING   | i in CONTROLLERS]) >= 3);
% constraint forall(d in DAYS)(sum([roster[i,d] == AFTERNOON | i in CONTROLLERS]) >= 2);
% constraint forall(d in DAYS)(sum([roster[i,d] == NIGHT     | i in CONTROLLERS]) >= 1);

constraint forall (i in CONTROLLERS)(
work[i] = 1*sum([ roster[i,d] == MORNING   | d in DAYS]) +
          2*sum([ roster[i,d] == AFTERNOON | d in DAYS]) +
          4*sum([ roster[i,d] == NIGHT     | d in DAYS]) +
          0*sum([ roster[i,d] == OFF       | d in DAYS]) 
) ;



constraint gap = max(work) - min(work) ; 
solve minimize gap;
      

output ["% Just for debugging. The table of shifts.\n%"]
       ++ [format(10,D) | D in DAYS ] ++ ["\n% "] 
       ++ [format(10,roster[C,D]) ++ if (D==card(DAYS)) then "\n% " else "" endif | C in CONTROLLERS, D in DAYS]
       ++ ["% Raw Data in Tables ------------ \n"]
       ++ ["roster = \(roster); \nwork = \(work); \ngap=\(gap);\n"]
       



