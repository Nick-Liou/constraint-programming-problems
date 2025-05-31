## Problem Overview: Truck Deliveries

This problem centers around optimizing the scheduling of deliveries in a transport company that must deliver several boxes using a limited fleet of trucks and only **two drivers**. Each truck can transport **only one box at a time**, and every box must be delivered after its individual ready time. The goal is to **minimize the total completion time** of all deliveries, known as the **makespan**.

### Problem Description

- The company owns a fixed number of trucks, each characterized by:
  - A **maximum payload** (i.e., the maximum weight it can carry),
  - A **speed** (used to compute delivery time).

- The delivery tasks are defined by:
  - A list of **boxes**, each with a specific **weight**,
  - A **ready-after time**, indicating when the box becomes available for pickup,
  - A **round-trip delivery distance**.

- The company has **only two drivers**, meaning that no more than two deliveries can be in progress simultaneously.

Each truck can be used multiple times, but only one delivery can be assigned to a truck at any moment. Trucks must not be assigned boxes that exceed their weight limits.

### Input Example

#### Truck and Box Data:
```minizinc
ntrucks = 3;
max_truck_weight = [15, 20, 30];     % Maximum weight capacities
speed = [10, 20, 5];                 % Speed of each truck

ndeliveries = 5;
weight = [5, 10, 18, 22, 10];        % Weight of each box
ready_after = [0, 0, 3, 2, 1];       % Time when each box becomes available
distance = [40, 100, 60, 80, 120];   % Round-trip distances
```

### Sample Solution Output (optimal):
```minizinc
depart = [0, 2, 7, 2, 10];          % Time at which delivery of each box begins
delivery_time = [2, 5, 3, 16, 6];   % Duration of each delivery
onTruck = [2, 2, 2, 3, 2];          % Truck assigned to each delivery
makespan = 18;                      % Total completion time
```

This output means:
- Box 1 is delivered by Truck 2 starting at time 0 and takes 2 time units.
- Box 2 is delivered by Truck 1 starting at time 0 and takes 10 time units.
- Box 3 is delivered by Truck 2 starting at time 18 and takes 3 time units.
- And so on...

### Constraints

-   A box can only be delivered after its ready_after time.
-   Each truck may deliver only one box at a time.
-   A truck cannot carry a box that exceeds its maximum weight capacity.
-   At most two deliveries can occur at the same time due to the driver limitation.

### Objective

The objective is to find a delivery schedule (truck assignments, departure times, and delivery durations) that minimizes the makespan—the total time by which all deliveries are completed.


