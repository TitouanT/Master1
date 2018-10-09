import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile as wav

# def arrInfo(arr):
#     print()
#     print("Type:", type(arr))
#     print("content:", arr)
#     print("ndim:", arr.ndim)
#     print("dtype:", arr.dtype)
#     print("shape:", arr.shape)
#     print()
#
# n = np.array(range(100))
# arrInfo(n)
#
# # t = n.copy() * 0.01;
# # t = np.linspace(0, 1, 100)
# t = np.array(range(0,1000,10)) * 0.001
# ind = np.where( t == 0.05)[0][0]
# print(ind)

def sinusoidal(f=1, a=1, phi=0, tmin=0, tmax=1, fe=100):
    n = (tmax - tmin) * fe
    t = np.linspace(tmin, tmax, n)
    y = np.sin(2*np.pi*f*t + phi) * a
    return (t, y)

def disp(x, y, lx='', ly='', title='awesome plot'):
    plt.plot(x, y)
    plt.stem(x, y)
    plt.title(title)
    plt.xlabel(lx)
    plt.ylabel(ly)
    plt.show()



# q6
# a = sinusoidal(f=10, a=1.5, tmax=1, fe=100)
# disp(*a, lx='temps en sec', ly='amplitude')
#
# a = sinusoidal(f=10, a=1.5, tmin=0.05, tmax=0.15, fe=100)
# disp(*a, lx='temps en sec', ly='amplitude')
#
# a = sinusoidal(f=10, a=1.5, tmin=0.05, tmax=0.15, fe=1000)
# disp(*a, lx='temps en sec', ly='amplitude')

# q7
f0 = [10,300,500,18000]

for f in f0:
    print("periode réelle:", 1/f)
    fe = 48000
    a = sinusoidal(f=f, a=1, tmax=3, fe=fe)
    title = "son" + str(f) + ".wav"
    # disp(*a, lx='temps en sec', ly='amplitude', title=title)
    wav.write(title, fe, a[1])
