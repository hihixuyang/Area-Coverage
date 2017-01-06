# Area-Coverage
Simulation for planar area coverage of a convex region by a swarm of ground robots.

The robot positioning can be exact, in which case a Voronoi partitioning is used, or uncertain in which case a Guaranteed Voronoi partitioning is used instead. The implemented control laws are:
- Cell centroid
- r-limited cell centroid
- Free arcs (optimal for Voronoi)
- GV complete (optimal for Guaranteed Voronoi)
- GV compromise (simpler suboptimal for Guaranteed Voronoi)

The robots are also allowed to have finite communication ranges, in which case they create their cells using only the nodes inside their communication radius. There are also options to restrict the movement of robots inside the region of interest and to prevent them from colliding when their positioning is uncertain.

### Usage
Before using the scripts, you must copy the the `gpcmex` file from `MATLAB/[Release]/toolbox/map/map/private/` into `Functions/Polygon`. The sample script `copy_gpcmex.sh` does this for a typical Linux installation of MATLAB R2016b.

`SIM_coverage_disks.m` Use this to run simulations. You can select the control law used by uncommenting the appropriate line at the beginning of the file. You can also set other simulation parameters there.

`PLOT_sim.m` Used to plot the data from a `.mat` file saved after the end of a simulation. Set the `.mat` file to load and the plots to show at the beginning of the file.

`PLOT_compare_sims.m` Used to compare the results of two simulations. Used the same way as `PLOT_sim.m`. Note that the simulations must have the same duration and time step.

### Screenshots
<img src="./Screenshots/state_comm.png" width="49%"> <img src="./Screenshots/state_uncert.png" width="49%">
<img src="./Screenshots/objective.png" width="49%"> <img src="./Screenshots/trajectories.png" width="49%">

### License
Distributed under the [MIT License](LICENSE.txt)

