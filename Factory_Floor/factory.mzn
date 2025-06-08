include "globals.mzn";

%%% Factory floor planning
enum MACHINES;
% number of stages
int : no_stages;
set of int: STAGES = 1..no_stages;
%% Info regarding machines in each stage
array[STAGES] of set of MACHINES : stage_machines;
% machine speeds
array[MACHINES] of int: unit_speed_factor;

% total number of orders and associated set
int: no_orders;
set of int: ORDERS = 1..no_orders;
% size of orders
array[ORDERS] of int: order_size;
array[ORDERS] of int: deadline;
set of int: TIME = 0..100;

%% Excludes
int: no_excludes;
set of int: EXCLUDES = 1..no_excludes;
array[EXCLUDES,1..2] of MACHINES: excludes;

array[ORDERS,STAGES] of var TIME: job_start;
array[ORDERS,STAGES] of var TIME: job_duration;
array[ORDERS,STAGES] of var MACHINES: job_machines;


array[ORDERS,STAGES] of var TIME: job_end;

constraint forall (i in ORDERS, s in STAGES) (job_end[i,s] = job_start[i,s] + job_duration[i,s]);

% SET UP ALTERNATIVE
array[ORDERS,STAGES,MACHINES] of var opt TIME: job_start_alt;
array[ORDERS,STAGES,MACHINES] of var     TIME: job_duration_alt;

% Implement constraints on the alternatives
constraint forall (i in ORDERS, s in STAGES, m in MACHINES) 
( 
if m in stage_machines[s] then
job_duration_alt[i,s,m] = order_size[i] * unit_speed_factor[m]
else
(job_duration_alt[i,s,m] = 0 /\ job_start_alt[i,s,m] = <> )
endif
);


constraint forall (i in ORDERS, e in EXCLUDES) 
(not (
    (excludes[e,1] in row(job_machines,i)) /\
    (excludes[e,2] in row(job_machines,i)) 
  ) 
);

%% Linking a Job with its alternatives
constraint forall (i in ORDERS, s in STAGES) (
alternative(
job_start[i,s],
job_duration[i,s],
[job_start_alt[i,s,m]    | m in MACHINES  ],
[job_duration_alt[i,s,m] | m in MACHINES  ])
);


constraint forall (s in STAGES, m in MACHINES where m in stage_machines[s]) 
(disjunctive(
[job_start_alt[i,s,m]      | i in ORDERS],
[job_duration_alt[i,s,m]   | i in ORDERS]
));

constraint forall (i in ORDERS, s in STAGES where s>1) (  job_start[i,s] = job_end[i,s-1] ) ; 

% constraint forall (i in ORDERS, s in STAGES) ( job_machines[i,s] in stage_machines[s] ) ;

constraint forall (i in ORDERS, s in STAGES, m in MACHINES where m in stage_machines[s])
(if occurs(job_start_alt[i,s,m]) then 
job_machines[i,s] = m 
endif
);


par int: min_cost = - sum(deadline);
par int: max_cost = sum([max(TIME) - deadline[i] | i in ORDERS]);
var min_cost..max_cost: cost = sum([job_end[i,no_stages] - deadline[i] | i in ORDERS]);

solve minimize cost;

output [" job_machines = \(job_machines); \n job_start = \(job_start); \n job_duration=\(job_duration);\n cost = \(cost);"];