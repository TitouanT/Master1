from math import exp, log


# ┌─────────────────┐
# │ Brevity Penalty │
# └─────────────────┘

# choose the biggest of the closest since it is for calculation of brevity penalty
def closest(n, tab):
	winner = 0
	for i in tab:
		dwin = abs(winner - n)
		dcur = abs(i - n)
		if dcur < dwin:
			winner = i
		elif dcur == dwin and i > n:
			winner = i
	return winner

# calculate the brevity penalty of the candidate
def logBrevityPenalty(references, candidate):
	lc = [len(sentence) for sentence in candidate]
	lr = [[len(s) for s in sentences] for sentences in zip(*references)]
	r = sum([closest(n, tab) for n, tab in zip(lc, lr)])
	c = sum(lc)
	# print(r, c)
	return min(1 - r/c, 0)



# ┌────────────────────┐
# │ Modified precision │
# └────────────────────┘

def bleuCountClip(ngram, count, refsngrams):
	maxRefCount = max([refngrams.count(ngram) for refngrams in refsngrams])
	return min(count, maxRefCount)

# return the ngrams of a sentence represented as an array of words
def ngramgen(tab, n):
	for i in range(len(tab) - n + 1):
		yield tab[i:i+n]

def modifiedPrecisionSentence(references, candidate, n):

	# extraction for all the references sentences of their ngrams
	ngram_ref = [list(ngramgen(ri, n)) for ri in references]

	# extraction of the ngrams in the candidate
	ngrams = [ng for ng in ngramgen(candidate, n)]
	ngrams_uniq = []
	for ng in ngrams:
		if not ng in ngrams_uniq:
			ngrams_uniq.append(ng)

	countClip = 0
	for ng in ngrams_uniq:
		countClip += bleuCountClip(ng, ngrams.count(ng), ngram_ref)

	# print(candidate)
	# print('ngrams', ngrams)
	# print('ngrams_uniq', ngrams_uniq)
	# print(references)
	# print('ngram_ref', ngram_ref)
	# print("for", n, ":", countClip, len(ngrams))
	return (countClip, len(ngrams))

# calculate the modified precision of the candidate for <n>grams
def modifiedPrecisionCorpus(references, candidate, n):
	sumCountClip = 0
	sumCount = 0

	for r, c in zip(zip(*references), candidate):
		countClip, countngram = modifiedPrecisionSentence(r, c, n)
		sumCountClip += countClip
		sumCount += countngram

	print(sumCountClip, sumCount)
	if sumCount == 0:
		return 0

	return sumCountClip / sumCount


# ┌───────────────────────────┐
# │ Final Calculation of Blue │
# └───────────────────────────┘

# references is an array of object of the same shape as candidate
# candidate is an array of sentences
# a sentence is an array of words in smallcase

# default function for weights assignement
def weightsUniform(i, n):
	return 1/n

def bleulog(references, candidate, maxNgram=4, weights=weightsUniform):
	bp = logBrevityPenalty(references, candidate)
	s = 0
	for i in range(1, maxNgram+1):

		pn = modifiedPrecisionCorpus(references, candidate, i)
		w = weights(i, maxNgram)
		if pn == 0:
			pn = 0.0001
		s += log(pn) * w

	return bp + s

def bleu(references, candidate, maxNgram=4, weights=weightsUniform):
	return exp(bleulog(references, candidate, maxNgram, weights))

# ┌────────────────────┐
# │ text normalization │
# └────────────────────┘
# sentence is a string who can contain upper and lower case letter, spaces and other characters
import re
pattern = re.compile('[^a-zA-Z0-9éàçèôîâêïö\'" ]+')
def normalization(sentence):
	s = [w for w in pattern.sub(' ', sentence).lower().split(' ') if w]
	return s
