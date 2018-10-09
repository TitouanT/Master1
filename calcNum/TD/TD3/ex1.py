import numpy.random as rnd
import numpy
import matplotlib.pyplot as plt

N = 100
Bins = 20
mini = 0
maxi = 10

# %%
x = numpy.linspace(mini,maxi,N)










# %% Loi uniforme
y_uni = rnd.uniform(mini,maxi, N)
y_uni.sort()

y_uni.mean()

plt.plot(x, y_uni)
# %%

tmp=plt.hist(y_uni, Bins)



















# %% Loi normal
y_norm = rnd.normal(4,1.5, N)
y_norm.sort()
y_norm.mean()

plt.plot(x, y_norm)
# %%

tmp=plt.hist(y_norm, Bins)















# %% Loi triangulaire

y_tri = rnd.triangular(0,4, 9,N)
y_tri.sort()
y_tri.mean()


plt.plot(x, y_tri)
# %%

tmp=plt.hist(y_tri, Bins)















# %% Loi exponential

y_exp = rnd.exponential(4, N)
y_exp.sort()
plt.plot(x, y_exp)



# %%

tmp=plt.hist(y_exp, Bins)
















# %% Tout en meme temps
plt.plot(x, y_uni, label="y_uni")
plt.plot(x, y_norm, label="y_norm")
plt.plot(x, y_tri, label="y_tri")
plt.plot(x, y_exp, label="y_exp")
plt.legend()
