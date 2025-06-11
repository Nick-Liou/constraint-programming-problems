## Problem Overview: Battery Conditioning

This problem involves optimizing the **conditioning process of batteries** in an energy storage system. Each battery must go through three stages: **discharge**, **idle**, and **charge**. All batteries are initially fully charged.

The goal is to determine the start times for discharging and charging of each battery such that the **total conditioning time is minimized**, while respecting various system constraints like port limitations and current capacities.

### Problem Description

- There are several **batteries**, each with a given **capacity in Ah**.
- There are **dischargers**, each with a specific **discharge current**.
  - Once a battery starts discharging, it must continue until finished.
- There is a **charger system** that:
  - Has a limited number of **active ports** (only a few batteries can charge at once),
  - Has a maximum **total current capacity**.

Each battery:
- Must first be **discharged** using one of the dischargers,
- Then waits **idle** for 2 time units,
- Then is **charged** for the same amount of time it was discharged.

### Input Example

```minizinc
num_batteries = 4;                    % Number of batteries
bat_capacity = [30, 10, 70, 40];      % Capacity of each battery in Ah

num_dischargers = 2;                 
current = [5, 10];                    % Discharge current of each discharger

charger_max_active_ports = 3;        
charger_max_total_current = 30;      % Maximum total charging current
```

### Sample Solution Output (not necessarily optimal):

```minizinc
startDischarge = [0, 11, 0, 7];         % When each battery starts discharging
durationDischarge = [6, 1, 7, 4];       % How long each discharges
endDischarge = [6, 12, 7, 11];          % When discharging ends
startCharge = [8, 14, 9, 13];           % When each battery starts charging
endCharge = [14, 15, 16, 17];           % When charging ends
charge_current = [5, 10, 10, 10];       % Current of each battery while charging and discharging
_objective = 17;                        % Total conditioning time
```

This means:

-  Battery 1 discharges at time 0 for 6 units, waits 2 units, then charges starting at 8, finishing at 14.
-  Battery 2 discharges at time 11 for 1 units, then charges at 14, and so on.
-  Total conditioning process ends at time 17.

### Constraints

-  Batteries must begin discharging only when a discharger is available.
-  Each discharger can only handle one battery at a time.
-  After discharging, the battery must remain idle for at least 2 time units before charging.

-  Charging:
    - Must not exceed the max number of simultaneously active ports.
    - Must not exceed the total current available.

-  Charging duration = discharging duration.
-  Discharge cannot be interrupted once started.

### Objective

Minimize the total conditioning time (end), defined as the time the last battery finishes charging.