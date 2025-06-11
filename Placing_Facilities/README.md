## Problem Overview: Placing Facilities

This problem focuses on optimally placing **service points (facilities)** on a grid-based map to serve a set of **customers**. The objective is to **minimize the maximum distance** any customer has from their **nearest** service point, while respecting several spatial constraints.

### Problem Description

- The map is a **grid**, with integer coordinates ranging from (1,1) to (grid_size, grid_size).
- There are a number of **customers**, each located at a specific point on the map.
- A fixed number of **service points** must be placed on the map.
- Each service point must maintain a **minimum distance** from all customers, and service points must also be **sufficiently far apart** from one another.

The goal is to achieve a **"fair" distribution**, where the worst-case distance any customer must travel to reach a facility is as small as possible.

### Input Example

```minizinc
grid_size = 25;

num_clients = 3;
client_loc = [| 4,15 | 12,4 | 23,15 |];     % Client coordinates

num_facilities = 2;
min_distance = [4, 3];                      % Min distance of each facility from every client

distance_between_facilities = 3;            % Min distance between any two facilities
```

### Output Example (Optimal)

```minizinc
client_min_distance = [10, 9, 7];       % Distances of clients to their nearest facility
 max_of_mins = 10;                      % Maximum of those minimum distances
```

### This output means:
-  Client 1 is 10 units from the closest service point.
-  Client 2 is 9 units away.
-  Client 3 is 7 units away.
-  The worst-case (maximum) minimum distance is 10, which the model tries to minimize.

### Constraints

-  Service point i must be strictly more than min_distance[i] units from every client (using Manhattan distance).
-  All facilities must be placed at positions with distinct coordinates.
-  Any two facilities must be separated by strictly more than distance_between_facilities (again, using Manhattan distance).

### Objective

Minimize the maximum of the minimum distances from each customer to their nearest service point (`max_of_mins`), ensuring spatial fairness in facility distribution.