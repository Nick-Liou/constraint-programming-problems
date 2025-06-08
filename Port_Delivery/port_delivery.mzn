%%% Port Delivery
include "globals.mzn";
% number of trucks
int: num_trucks;
int:num_derricks;
set of int: TRUCKS = 1..num_trucks;
int: max_time;
set of int: TIME = 0..max_time;
enum CDATA = {BOXES,DEST};

array[TRUCKS,CDATA] of int: delivery; 

enum WAREHOUSES = {wh1,wh2};
array[WAREHOUSES] of int: travel_time = [15,20];

array[int] of WAREHOUSES: int_to_warehouse = [wh1, wh2];

array[TRUCKS] of var TIME: StartLoad ;
array[TRUCKS] of var TIME: StartUnload ;
array[TRUCKS] of var TIME: End ;
var TIME: makespan ; 

par int: load_time = 4 ;
par int: unload_time = 1 ; 

constraint cumulative(StartLoad, [load_time * delivery[i,BOXES] | i in TRUCKS] , [1 | i in TRUCKS], num_derricks ) ; 

constraint forall (wh in WAREHOUSES) ( disjunctive( 
[StartUnload[i] | i in TRUCKS where delivery[i,DEST] == enum2int(wh) ],
[unload_time * delivery[i,BOXES] | i in TRUCKS where delivery[i,DEST] == enum2int(wh) ] 
));

constraint forall (i in TRUCKS)
( StartUnload[i] >= StartLoad[i] + load_time * delivery[i,BOXES] 
                + travel_time[int_to_warehouse[delivery[i, DEST]]] );

constraint forall (i in TRUCKS)( End[i] = StartUnload[i] + unload_time * delivery[i,BOXES]);

constraint makespan = max(End) ;
constraint makespan <= max_time ;

solve minimize makespan;


