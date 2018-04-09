- Wind data for 'low', 'medium' and 'high' dynamics regions.
- Data are recorded using the Gill Instruments WindMaster, the 2D ultrasonic anemometer
- Wind was sampled at 32 Hz and resampled at 50Hz, and the two channels correspond to the the "north" and "east" direction
- To make a complex-valued wind signal, combine z=v_n + j v_e, where 'v' is wind speed and 'n' and 'e' the north and east directions
- Data length = 5000 samples

In Matlab, execute e.g.

'load('high-wind.mat') to have the two channels as column vectors

Good luck and enjoy!