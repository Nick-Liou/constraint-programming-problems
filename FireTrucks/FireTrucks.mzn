include "globals.mzn";

int: no_firetrucks;
set of int: FIRETRUCKS = 1..no_firetrucks;
array[FIRETRUCKS] of int: water_cap;
array[FIRETRUCKS] of int: service_time;

set of int: TIME = 0..1000;

array[FIRETRUCKS] of var TIME: start_fill;
array[FIRETRUCKS] of var TIME: start_service;
var TIME: makespan; 
var TIME: total_service;

par int: no_fire_hydrants = 3 ; 
par int: water_flow = 50 ; 


array[FIRETRUCKS] of var TIME: fill_TIME = [water_cap[i] div water_flow | i in FIRETRUCKS ];

constraint cumulative(start_fill,fill_TIME,[1 | i in FIRETRUCKS] , no_fire_hydrants );


constraint forall (i in FIRETRUCKS)( start_service[i] >= start_fill[i] + fill_TIME[i]);

constraint disjunctive(start_service,service_time);


array[FIRETRUCKS] of var TIME: end_service ;
constraint forall (i in FIRETRUCKS)( end_service[i] = start_service[i] + service_time[i]);

constraint total_service = max(end_service) - min(start_service) ;
constraint makespan = max(end_service) ;

solve minimize makespan; 

output [" start_fill=\(start_fill);\n start_service=\(start_service);\n"]
       ++ [" total_service = \(total_service);\n makespan=\(makespan);\n"]

