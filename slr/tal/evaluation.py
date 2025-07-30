from bleu import bleu, bleulog, normalization
import bleu as bl

# ┌────────────────────────┐
# │ example from the paper │
# └────────────────────────┘

# e1c1 = 'It is a guide to action which ensures that the military always obeys the commands of the party.'
# e1c2 = 'It is to insure the troops forever hearing the activity guidebook that party direct.'
# e1r1 = 'It is a guide to action that ensures that the military will forever heed Party commands.'
# e1r2 = 'It is the guiding principle which guarantees the military forces always being under the command of the Party.'
# e1r3 = 'It is the practical guide for the army always to heed the directions of the party.'

# e1 = {}
# e1['c'] = [[e1c1], [e1c2]]
# e1['r'] = [[e1r1], [e1r2], [e1r3]]

# e2c1 = 'the the the the the the the.'
# e2r1 = 'The cat is on the mat.'
# e2r2 = 'There is a cat on the mat.'
# e2 = {}
# e2['c'] = [[e2c1]]
# e2['r'] = [[e2r1], [e2r2]]

# for e in [e1, e2]:
#     for k in e:
#         e[k] = [[normalization(s) for s in r] for r in e[k]]

# def modifiedPrecision(ref, can):
#     for i in range(1, 5):
#         print(bl.modifiedPrecisionCorpus(ref, can, i))

# print('exemple 1')
# print('candidat 1')
# modifiedPrecision(e1['r'], e1['c'][0])
# # print('bp', bl.logBrevityPenalty(e1['r'], e1['c'][0]))
# # print("bleu n=1:", bleu(e1['r'], e1['c'][0], maxNgram=1))

# print()
# print('candidat 2')
# modifiedPrecision(e1['r'], e1['c'][1])
# # # print('bp', bl.logBrevityPenalty(e1['r'], e1['c'][1]))
# # # print("bleu n=1:", bleu(e1['r'], e1['c'][1], maxNgram=1))

# print()
# print('exemple 2')
# print('candidat 1')
# modifiedPrecision(e2['r'], e2['c'][0])
# # # print('bp', bl.logBrevityPenalty(e2['r'], e2['c'][0]))
# # # print("bleu n=1:", bleu(e2['r'], e2['c'][0], maxNgram=1))
# exit()

import os

def getDirPath(name):
    return '/'.join(['talks', name])

def getFilePath(category, name):
    return '/'.join(['talks', category, name])

def getDirContent(category):
    return os.listdir(getDirPath(category))

ref_names = ['fr']
candidat_folder = 'translated'
talksids = getDirContent(candidat_folder)

def readFile(path):
    tab = []
    with open(path) as f:
        for line in f:
            tab.append(normalization(line))
    return tab


for tid in talksids:
    print('\nprocessing of ', tid)
    print('normalization...')
    candidat = readFile(getFilePath(candidat_folder, tid))
    references = []
    for r in ref_names:
        references.append(readFile(getFilePath(r, tid)))
    print('done')
    print('evaluation...')
    res = bleu(references, candidat)
    print('result: ', res)

