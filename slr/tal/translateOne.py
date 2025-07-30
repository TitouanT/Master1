from translate import en2fr
import os

def getDirPath(name):
    return '/'.join(['talks', name])

def getFilePath(category, name):
    return '/'.join(['talks', category, name])

def getDirContent(category):
    return os.listdir(getDirPath(category))

def translateFile(srcn, dstn):
    lines = []
    with open(srcn) as src:
        for l in src:
            lines.append(l)

    n = 15
    chunks = [lines[i:i+n] for i in range(0, len(lines), n)]
    trlines = []
    for chunk in chunks:
        tr = en2fr(chunk)
        print(tr)
        trlines.extend(tr)
    print('done')
    print()
    print()
    print(trlines)
    with open(dstn, 'w') as dst:
        for l in trlines:
            dst.write(l + '\n')



src_name = 'en'
dst_name = 'translated'

dst = getDirContent(dst_name)
src = [k for k in getDirContent(src_name) if not k in dst]

for name in src:
    translateFile(getFilePath(src_name, name), getFilePath(dst_name, name))
    print(name, 'has been translated')
    exit() # just do one


# ┌───────────────┐
# │ Verifications │
# └───────────────┘
# print(alreadyTranslated)
# print()
# print(srcFr)
# print()
# print(srcEn)

# print([k for k in srcEn if k not in srcFr])
# print([k for k in srcFr if k not in srcEn])
