%% Number of Servers and Clients and related Sets
par int: Servers;
par int: Clients;

set of int:SERVERS = 1..Servers;
set of int:CLIENTS = 1..Clients;

%% Arrays stating Problem Data
array[SERVERS] of int: Capacity;
array[SERVERS] of int: DeploymentCost;
array[CLIENTS] of int: ClientDemands ;
array[CLIENTS,SERVERS] of int: NetworkingCost;


set of int: CAPACITIES = 0..max(Capacity);
array[CLIENTS,SERVERS] of var CAPACITIES: client_allocation;

constraint forall (s in SERVERS)( sum(col(client_allocation,s)) <= Capacity[s] ) ;
constraint forall (c in CLIENTS)( max(row(client_allocation,c)) = ClientDemands[c] ) ;
constraint forall (c in CLIENTS)( sum(row(client_allocation,c)) = ClientDemands[c] ) ;



var int: op_cost = sum([DeploymentCost[i] | i in SERVERS where sum(col(client_allocation,i))>0 ]);
var int: net_cost = sum([ NetworkingCost[c,s]*client_allocation[c,s] | c in CLIENTS, s in SERVERS   ]);

var int:total_cost = op_cost + net_cost ; 

solve minimize total_cost;


output ["%% For Debugging\n"]
    ++["% \(row(client_allocation,c))\n" | c in CLIENTS]
    ++[" client_allocation = \(client_allocation); \n total_cost=\(total_cost);\n"];
