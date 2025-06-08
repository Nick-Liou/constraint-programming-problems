%%% Truck Delivery
include "globals.mzn";

% Number of Trucks and the associated set
int : ntrucks;
set of int: TRUCKS = 1..ntrucks;
array[TRUCKS] of int: max_truck_weight;
array[TRUCKS] of int: speed;

% Number of deliveries and the associated set
int: ndeliveries;
set of int: DELIVERIES = 1..ndeliveries;
array[DELIVERIES] of int: weight;
array[DELIVERIES] of TIME: ready_after;
array[DELIVERIES] of int: distance;
%% Setting Time to a constant range
set of int: TIME = 0..1000;

par int: ndrivers = 2 ; 

array[DELIVERIES] of var TIME: depart ;        % Time at which delivery of each box begins
array[DELIVERIES] of var TIME: end ;           % Time at which delivery of each box ends
array[DELIVERIES] of var TIME: delivery_time ; % Duration of each delivery
array[DELIVERIES] of var TRUCKS: onTruck ;     % Truck assigned to each delivery

array[DELIVERIES,TRUCKS] of var opt TIME: depart_alt ; 
array[DELIVERIES,TRUCKS] of var     TIME: delivery_time_alt ; 

constraint forall (i in DELIVERIES) 
(alternative(depart[i],delivery_time[i],
[depart_alt[i,t]        | t in TRUCKS ], 
[delivery_time_alt[i,t] | t in TRUCKS ]) 
);

% Exluding alternatives that are invalid by definition (data)
constraint forall (i in DELIVERIES, t in TRUCKS) (
if weight[i] <= max_truck_weight[t]
then delivery_time_alt[i,t] = distance[i] div speed[t]
else (depart_alt[i,t] = <>  /\ delivery_time_alt[i,t] = 0 )
endif );

constraint forall (i in DELIVERIES) (end[i] = depart[i] + delivery_time[i]) ;
constraint forall (i in DELIVERIES) ( depart[i] >= ready_after[i] ) ;

% Make sure only two drivers are needed at each time
constraint cumulative(depart,delivery_time,[1 | i in DELIVERIES], ndrivers);

% Make sure each truck is used by one driver/packet at a time
constraint forall (t in TRUCKS) ( 
disjunctive(
[depart_alt[i,t]        | i in DELIVERIES],
[delivery_time_alt[i,t] | i in DELIVERIES]
));

constraint forall (i in DELIVERIES, t in TRUCKS)
( if occurs( depart_alt[i,t] ) then onTruck[i] = t endif ); 

var TIME: makespan = max(end) ;
solve minimize makespan ; 


output [" depart = \(depart); \n delivery_time = \(delivery_time); \n"] ++
       [" onTruck = \(onTruck); \n makespan = \(makespan);"];

       
       
       