% Placing Facilities

%% size of map (grid_size * grid_size)
int:grid_size;
%% the set of positions (coordinates for x and y)
set of int: POSITIONS = 1..grid_size;
%% Distance Domain 
set of int: DIST_RANGE = 0..2*(grid_size - 1);
%% number of clients
int: num_clients;
set of int: CLIENTS = 1..num_clients;
%% number of facilities to be placed
int: num_facilities;
set of int: FACILITIES = 1..num_facilities;
%% Sets the minimum distance between any two facilities;
int : distance_between_facilities;
% To easily access coordinates
enum COORDS = {POSX,POSY};
% client Locations (data)
array[CLIENTS,COORDS] of int: client_loc;
% minimum distance between facilities and clients (different for each facility)
array[FACILITIES] of int: min_distance;


array[CLIENTS] of var DIST_RANGE: client_min_distance;                                                                                         
var DIST_RANGE: max_of_mins; 

array[FACILITIES,COORDS] of var POSITIONS: facilities_loc;

constraint forall (f in FACILITIES, c in CLIENTS)
    ( manhattan( row(facilities_loc,f) , row(client_loc,c) ) > min_distance[f] );

constraint forall (f1 in FACILITIES, f2 in FACILITIES where f1<f2) 
( manhattan( row(facilities_loc,f1) ,row(facilities_loc,f2)) > distance_between_facilities ) ;

constraint client_min_distance = [ min([ manhattan( row(facilities_loc,f) , row(client_loc,c) ) | f in FACILITIES]) |c in CLIENTS];
constraint max_of_mins > min(min_distance);
constraint max_of_mins = max(client_min_distance) ; 

% Search Annotations      
ann: order = int_search(facilities_loc, input_order, indomain);
ann: ff    = int_search(facilities_loc, first_fail, indomain);
ann: ffM   = int_search(facilities_loc, first_fail, indomain_median);
ann: msM   = int_search(facilities_loc, most_constrained, indomain_median);
ann: dwdM  = int_search(facilities_loc, dom_w_deg, indomain_median);
ann: dwdM_m_fast = seq_search([
  int_search(facilities_loc, dom_w_deg, indomain_median),
  int_search(client_min_distance, dom_w_deg, indomain_min)   
]);
ann: dwdM_m_slow = seq_search([
  int_search(client_min_distance, dom_w_deg, indomain_min) ,
  int_search(facilities_loc, dom_w_deg, indomain_median)
]);

solve :: dwdM_m_fast minimize max_of_mins;

function var int: manhattan(array[COORDS] of var POSITIONS: p1,
                            array[COORDS] of var POSITIONS: p2) =
    abs(p1[POSX] - p2[POSX]) + abs(p1[POSY] - p2[POSY]);


output [" client_min_distance = \(client_min_distance);\n max_of_mins = \(max_of_mins);"];

