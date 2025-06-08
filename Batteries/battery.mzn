
include "globals.mzn";

int: nBatteries;
set of int: BATTERIES = 1..nBatteries;
array[BATTERIES] of int: bat_capacity;
array[BATTERIES] of int: max_discharge;
array[BATTERIES] of int: min_discharge;


par int: max_amp = 40 ;
par int: max_concurrent = 2 ;

array[BATTERIES] of var int: discharge_rate;

constraint forall (i in BATTERIES) ( discharge_rate[i] <= max_discharge[i]);
constraint forall (i in BATTERIES) ( discharge_rate[i] <= max_amp);
constraint forall (i in BATTERIES) ( discharge_rate[i] >= min_discharge[i]);

int: max_TIME = sum(bat_capacity);
set of int: TIME = 0..max_TIME;

array[BATTERIES] of var TIME: start ;
array[BATTERIES] of var TIME: duration ;
array[BATTERIES] of var TIME: end ;


constraint forall (i in BATTERIES) ( end[i] = start[i]+ duration[i] );

constraint forall (i in BATTERIES) ( bat_capacity[i] = discharge_rate[i]*duration[i] );


constraint cumulative(start,duration,[1| i in BATTERIES],max_concurrent);
constraint cumulative(start,duration,discharge_rate,max_amp);

var int: discharge_ends = max(end) ;
solve minimize discharge_ends;


output [" start = \(start); \n duration = \(duration); \n discharge_rate = \(discharge_rate); \n "]
       ++["discharge_ends = \(discharge_ends);\n"];

 




