%%% Battery Conditioning
include "globals.mzn";

%%% Number of batteries
int: num_batteries;
set of int: BATTERIES = 1..num_batteries;
array[BATTERIES] of int: bat_capacity;  % Capacity of each battery (Ah)

%%% Number of dischargers and their currents
int : num_dischargers;
set of int: DISCHARGERS = 1..num_dischargers;
array[DISCHARGERS] of int: current;     % Discharge current for each discharger

%%% Charger constraints
int: charger_max_active_ports;          % Max number of batteries that can charge simultaneously
int: charger_max_total_current;         % Max total current available during charging

%%% Time domain
set of int: TIME = 0..1000;             % Time window for scheduling

%%% Battery scheduling variables
array[BATTERIES] of var TIME: startDischarge;
array[BATTERIES] of var TIME: durationDischarge;
array[BATTERIES] of var TIME: endDischarge;
array[BATTERIES] of var TIME: startCharge;
array[BATTERIES] of var TIME: endCharge;

%%% End time (makespan)
var TIME: end = max(endCharge);     

%%% Alternative discharging assignments (one per discharger)
array[BATTERIES,DISCHARGERS] of var opt TIME: startDischarge_alt;
array[BATTERIES,DISCHARGERS] of var TIME: durationDischarge_alt;

%%% Discharge current for each battery (derived from which discharger is used)
set of int: CURRENT = 0..max(current);
array[BATTERIES] of var CURRENT: charge_current;

%%% Idle time between discharge and charge
par int: restTime = 2;

%%% Constraint: battery capacity must equal current × duration for the selected discharger
constraint forall (i in BATTERIES , c in DISCHARGERS)
  (bat_capacity[i] = current[c] * durationDischarge_alt[i,c]);

%%% Use `alternative` to model discharger choice per battery
constraint forall (i in BATTERIES) (
  alternative(
    startDischarge[i],
    durationDischarge[i],
    row(startDischarge_alt, i),
    row(durationDischarge_alt, i)
  )
);

%%% No overlap in discharger usage (disjunctive scheduling)
constraint forall (c in DISCHARGERS) (
  disjunctive(
    col(startDischarge_alt, c),
    col(durationDischarge_alt, c)
  )
);

%%% Determine which current is used for charging (based on discharger used)
constraint forall (i in BATTERIES , c in DISCHARGERS) (
  if occurs(startDischarge_alt[i,c]) then
    charge_current[i] = current[c]
  endif
);

%%% Constraint to bound discharger use
constraint cumulative(startDischarge, durationDischarge, [1 | i in BATTERIES], num_dischargers);

%%% Define end of discharging
constraint forall (i in BATTERIES) (
  endDischarge[i] = startDischarge[i] + durationDischarge[i]
);

%%% Charging must start after discharge + rest time
constraint forall (i in BATTERIES) (
  startCharge[i] >= endDischarge[i] + restTime
);

%%% Charging duration equals discharging duration
constraint forall (i in BATTERIES) (
  endCharge[i] = startCharge[i] + durationDischarge[i]
);

%%% Respect port and current limits during charging
constraint cumulative(startCharge, durationDischarge, [1 | i in BATTERIES], charger_max_active_ports);
constraint cumulative(startCharge, durationDischarge, charge_current, charger_max_total_current);

%%% Objective: minimize the end time of the last battery
solve minimize end;

%%% Let MiniZinc display all decision variables
