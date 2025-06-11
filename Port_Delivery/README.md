## Problem Overview: Container Delivery

This problem involves scheduling the delivery of boxes from a **port** to two **warehouses** using a limited number of **derricks**, **trucks**, and **mobile cranes**. The objective is to **minimize the makespan**, i.e., the total time required to complete all deliveries and unloadings.

### Problem Description

- The port contains several **derricks**, each of which takes **4 time units per box** to load onto a truck.
- A number of **trucks** are available, and each is assigned a specific delivery:
  - The **number of boxes** to be transported,
  - The **warehouse** (either `wh1` or `wh2`) the boxes must be delivered to.
- Each **warehouse** has **one mobile crane** that can **unload one box at a time**.
- The **travel time** from the port to each warehouse is fixed and known.

The scheduling must ensure proper loading, transit, and unloading for each truck, respecting all resource constraints.

### Input Example

```minizinc
num_derricks = 3;                       % Number of loading derricks
num_trucks = 4;                         % Number of trucks

enum WAREHOUSES = {wh1, wh2};           % Enumerated warehouse types
array[WAREHOUSES] of int: travel_time = [15, 20];

array[1..num_trucks, 1..2] of int: delivery = 
  [| 5, enum2int(wh1) | 
     2, enum2int(wh2) | 
     3, enum2int(wh1) | 
     4, enum2int(wh2) |];                % Each row: [number of boxes, warehouse ID]
```

### Output Example (Optimal)

```minizinc
StartLoad = [0, 12, 0, 0];          % Time each truck starts loading at port
StartUnload = [35, 40, 27, 36];     % Time each truck starts unloading at the warehouse
End = [40, 42, 30, 40];             % Time each truck finishes unloading
makespan = 42;                      % Makespan: total time to finish all operations
```

This means:

-   Truck 1 loads from time 0, unloads at wh1 starting at 35, ends at 40.
-   Truck 2 loads from 12, goes to wh2, and finishes unloading at 42.
-   The total delivery process is completed in 42 minutes.

### Constraints

-  Each derrick can load only one truck at a time.
-  Each truck takes 4 time units per box to load.
-  Trucks must travel to the warehouse after loading (with warehouse-specific travel times).
-  Each warehouse has only one crane, and it can unload only one box at a time per truck.
-  Unloading must begin only after the truck arrives at the warehouse.
-  Trucks may unload only one order at a time, even if multiple trucks arrive.

### Objective

Minimize the makespan—the time at which all unloading is completed.

