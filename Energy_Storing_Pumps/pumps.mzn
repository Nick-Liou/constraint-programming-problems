
include "globals.mzn";
%% number of days
int : nDays;
set of int : PERIOD = 1..nDays;
%% number of PUMPS
int : nPumps;
set of int : PUMPS = 1..nPumps;

enum MODE = {P050,P100,OFF};
array[PUMPS,MODE] of int: consumption;
array[PERIOD] of int: energy2store;

%%% The main decision var 
array[PUMPS,PERIOD] of var MODE: schedule;

int: ns = 5; % Number of states
set of int: STATES = 1..ns;
array[STATES,MODE] of opt STATES: FSM=
%  P050, P100, OFF
 [| 2  ,   3 ,  1
  | 3  ,   4 ,  1
  | 4  ,   5 ,  1
  | 5  ,  <> ,  1
  | <> ,  <> ,  1
 |];

% Implement the FSM constraint
constraint forall (i in PUMPS) (regular(row(schedule,i), FSM , 1 , STATES )); 


array[PERIOD] of var int: daily_storage;

constraint forall (i in PERIOD) 
(daily_storage[i] = sum( [ consumption[p, schedule[p,i]  ]  | p in PUMPS ]) );


constraint forall (i in PERIOD) ( daily_storage[i] <= energy2store[i] );

constraint lost = sum( [ energy2store[i] - daily_storage[i] | i in PERIOD] );


par int: max_lost = sum(energy2store);
var 0..max_lost: lost;

solve minimize lost;
  
%%% Output
output ["% Just for debugging. The table of pump operations.\n%"]
       ++ [format(5,t) | t in PERIOD ] ++ ["\n% "] 
       ++ [format(5,schedule[p,t]) ++ if (t==card(PERIOD)) then "\n% " else "" endif | p in PUMPS, t in PERIOD]     
       ++ ["% Raw Data in Tables ------------ \n"]
       ++ ["schedule=\(schedule);\n"]
       ++ ["lost= \(lost);\n"]
       ;
    