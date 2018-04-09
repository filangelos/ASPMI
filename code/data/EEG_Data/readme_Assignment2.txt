Electroencephalogram (EEG) was recorded simultaneously from two electrodes located at the center (Cz) and posterior (POz) of the head. The recordings were referenced to an electrode located on the ear lobe, and with the ground electrode placed at position FPz. The sampling frequency was 1200Hz, and the length of the recording was 295 seconds, giving a total of 295 X 60 X1200 = 354000 samples. The subject observed a flashing visual stimulus (flashing at a fixed rate of X Hz, where X is some integer value in the range [11,20]). This has induced a response in the EEG, known as the steady state visual evoked potential (SSVEP), at the same frequency. Spectral analysis is required to determine `X'.

The recordings are contained in the `EEG_Data.mat' file which contains the following elements:

	POz	-- A 354000 X 1 vector containing the EEG (expressed in Volts) obtained from site POz. 
	Cz	-- A 354000 X 1 vector containing the EEG (expressed in Volts) obtained from site Cz.
	fs    -- A scalar denoting the sampling frequency.
