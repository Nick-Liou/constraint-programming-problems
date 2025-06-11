<!-- # constraint-programming-problems

A collection of Constraint Programming (CP) models, implemented in MiniZinc.

- Flight Control Center
- Truck Deliveries -->

# MiniZinc Optimization Models

This repository contains a collection of MiniZinc models for various discrete optimization problems across logistics, scheduling, energy systems, and network design. Each subdirectory includes a problem description, a project file containing a model, data files, and possibly a sovler configuration.

## Problem List

- Batteries
- Battery_Conditioning
- Client_Server_Allocation
- Energy_Storing_Pumps
- Factory_Floor
- FireTrucks
- Flight_Control_Center
- Placing_Facilities
- Port_Delivery
- Truck_Deliveries

<!-- ### Batteries
Models battery behavior under operational constraints to optimize energy usage and storage.

### Battery_Conditioning
Schedules battery conditioning cycles while considering maintenance and performance degradation.

### Client_Server_Allocation
Assigns client services to edge servers to minimize total cost, subject to server capacities and networking constraints.

### Energy_Storing_Pumps
Plans daily schedules for energy-storing pumps to absorb excess renewable energy while observing operation and maintenance constraints.

### Factory_Floor
Places machines on a factory floor subject to distance, layout, or interaction constraints.

### FireTrucks
Coordinates refueling and service scheduling for firetrucks to minimize total operation time and resource conflicts.

### Flight_Control_Center
Schedules aircraft landings at an airport while maintaining safety separations and minimizing delays.

### Placing_Facilities
Places service facilities to cover a set of clients while optimizing access costs and facility constraints.

### Port_Delivery
Schedules the loading, transport, and unloading of goods from a port to multiple warehouses, minimizing total duration.

### Truck_Deliveries
Optimizes delivery schedules for trucks transporting orders to various destinations, under loading and travel constraints. -->

## File Structure

Each problem directory contains:
- `model.mzn`: The MiniZinc model.
- `data.dzn`: The data file for the problem instance.
- `README.md` : Brief explanation specific to the problem.
- `solver_config.mpc`: (optional) Solver configuration to optimize solution time.

## How to Run

You can solve a problem using the MiniZinc IDE or the command line:


## Notes

- All problems assume finite domains and bounded timelines where applicable.
