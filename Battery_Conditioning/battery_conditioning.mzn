%%% Battery Conditioning
include "globals.mzn";
%%% Number of batteries
int: num_batteries;
set of int: BATTERIES = 1..num_batteries;
array[BATTERIES] of int: bat_capacity;

% number of dischargers
int : num_dischargers;
set of int: DISCHARGERS = 1..num_dischargers;
array[DISCHARGERS] of int: current;
%%%%%% 
int: charger_max_active_ports;
int: charger_max_total_current;
%% Time domain
%% Everything should take place in this interval.
set of int: TIME = 0..1000;

array[BATTERIES] of var TIME: startDischarge;
array[BATTERIES] of var TIME: durationDischarge;
array[BATTERIES] of var TIME: endDischarge;
array[BATTERIES] of var TIME: startCharge;
array[BATTERIES] of var TIME: endCharge;
var TIME: end = max(endCharge);     

array[BATTERIES,DISCHARGERS] of var opt TIME: startDischarge_alt;
array[BATTERIES,DISCHARGERS] of var     TIME: durationDischarge_alt;


set of int: CURRENT = 0..max(current) ;
array[BATTERIES] of var CURRENT:charge_current ;


par int:restTime = 2 ;

constraint forall (i in BATTERIES , c in DISCHARGERS)
( bat_capacity[i] = current[c] * durationDischarge_alt[i,c]) ;

constraint forall (i in BATTERIES) (alternative(
 startDischarge[i],
 durationDischarge[i],
 row(startDischarge_alt,i),
 row(durationDischarge_alt,i)  )
 );

constraint forall (c in DISCHARGERS)
(disjunctive( col(startDischarge_alt,c) , col(durationDischarge_alt,c)  )  );



% find the rate at which it will discharge
constraint forall (i in BATTERIES , c in DISCHARGERS)
(if occurs(startDischarge_alt[i,c]) then
% bat_capacity[i] = charge_current[i] * durationDischarge_alt[i,c]
charge_current[i] = current[c]
endif
);


constraint cumulative (startDischarge,durationDischarge, [1 | i in BATTERIES],num_dischargers);


constraint forall (i in BATTERIES)( endDischarge[i] = startDischarge[i] +durationDischarge[i]  );


constraint forall (i in BATTERIES)( startCharge[i] >= endDischarge[i]+ restTime);

constraint forall (i in BATTERIES)( endCharge[i] = startCharge[i] + durationDischarge[i]);

constraint cumulative(startCharge,durationDischarge,[1 | i in BATTERIES], charger_max_active_ports);

constraint cumulative(startCharge,durationDischarge,charge_current,charger_max_total_current );



solve minimize end;
%% Do not define any output. Let all vars display.


