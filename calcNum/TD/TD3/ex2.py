from scipy.io import wavfile
import matplotlib.pyplot as plt
import numpy.random as rnd

import numpy
m=numpy.max(stereo)
fs, stereo = wavfile.read("/info/etu/m1/s146292/code/calcNum/TD/TD3/td3.wav")
n = len(stereo)
T = 1/fs
time = [i * T for i in range(n)]
time

stereo[:,0]


gauche = stereo[:,0]
wavfile.write("/info/etu/m1/s146292/code/calcNum/TD/TD3/gauche.wav", fs, gauche)
bruituniform = rnd.uniform(-0.005, 0.005, len(gauche))
len(bruitnormal)
wavfile.write("/info/etu/m1/s146292/code/calcNum/TD/TD3/bruité.wav", fs, gauche+bruitnormal)

bruitnormal = rnd.normal(0, 0.01, len(gauche))


plt.plot(time[fs:fs+1000], gauche[fs:fs+1000])
plt.plot(time[fs:fs+1000], bruit[fs:fs+1000] + gauche[fs:fs+1000])
plt.plot(time[fs:fs+1000], droite[fs:fs+1000])
