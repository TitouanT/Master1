# determination de l'integrale de 1/sqrt(1+x^2)
import matplotlib.pyplot as plt


def decoupage(mini, maxi, n):
	s = (maxi-mini)/n
	return [mini + i*s for i in range(n+1)]


a=decoupage(0,1,10)
print(a)

def f(x):
	return 1/(1+x**2)**0.5

def plot(fun, mini, maxi, n):
	x = decoupage(mini, maxi, n)
	y = [fun(xi) for xi in x]
	plt.scatter(x, y)
	plt.plot(x, y)

plot(f, 0, 1, 10)

def carre(f, a, b):
	return (b-a)*f(a)

def trapeze(f, a, b):
	return (b-a)*(f(b)+f(a))*0.5

def simpson(f, a, b):
	return (b-a)*(f(a) + 4*f((a+b)/2) + f(b))*(1/6)


def integral(methode, function, mini, maxi, n):
	x = decoupage(mini, maxi, n)
	R = 0
	for i in range(n):
		x0,x1 = x[i:i+2]
		R += methode(function, x0, x1)
	return R

integral(simpson, f, 0, 1, 1000)


def plotIntegral(f, mini, maxi, maxN):
	n = [ni for ni in range(1, maxN)]
	rc = [integral(carre, f, mini, maxi, ni) for ni in n]
	rt = [integral(trapeze, f, mini, maxi, ni) for ni in n]
	rs = [integral(simpson, f, mini, maxi, ni) for ni in n]
	plt.semilogx(n,rc)
	plt.semilogx(n,rt)
	plt.semilogx(n,rs)

plotIntegral(f, 0, 1, 100)
