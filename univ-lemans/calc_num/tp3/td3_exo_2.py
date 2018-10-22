import numpy as np
from scipy.io.wavfile import read
import scipy.io as si

fs , stereo = si.wavfile.read('td3.wav')

mono = stereo[:,0]
