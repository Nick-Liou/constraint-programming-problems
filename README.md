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

## File Structure

Each problem directory contains:
- `model.mzn`: The MiniZinc model.
- `data.dzn`: The data file for the problem instance.
- `README.md` : Brief explanation specific to the problem.
- `solver_config.mpc`: (optional) Solver configuration to optimize solution time.

## Notes

- All problems assume finite domains and bounded timelines where applicable.
