from bleu import bleu

import sys
if len(sys.argv) != 3:
	sys.exit(1)

_, ref, trad = sys.argv

def data(name):
	with open(name) as f:
		t = [l.strip().split(' ') for l in f]
	return [l for l in t if l != ['']]

data_ref = data(ref)
data_trad = data(trad)

for r, t in zip(data_ref, data_trad):
	print(r, t)
	print(bleu([r], t))

