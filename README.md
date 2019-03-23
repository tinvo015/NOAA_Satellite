# NOAA_Satellite

Codes for implementing a modulator and demodulator (modem) for NASA's “Automatic Picture Transmission” or APT data format.

### Modulator
Accepts a JPEG image of width 909 pixels and height of 1-1818 pixels and produces an fs = 16KHz and nbits = 16  .wav file output that is amplitude modulated with image data in APT format. The image occupies both the "A" and "B" subimages of the APT frame. The APT telemetry data words is all zeros.


### Demodulator
Accepts a 16KHz / 16 bit .wav file input containing an arbitrary number of lines of APT data and writes an 8-bit grayscale image to a JPEG file. This JPEG image has dimensions of 1818 x n_lines (presenting the "A" and "B" subimages next to each other) where n_lines is an arbitrary number of lines determined by the source .wav file.


### Impairment
Accepts a .wav file input along with a signal-to-noise power ratio in dB and writes a .wav file output including AWGN calculated to yield the requested signal-to-noise power ratio.  
