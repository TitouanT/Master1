import xml.etree.ElementTree as ET
import re

contextRegex = re.compile(r"\([^)]*\)")

def getTalks(filename):
    tree = ET.parse(filename)
    root = tree.getroot()

    talks = {}
    for file in root.findall('file'):
        talkid = next(file.iter('talkid')).text

        videoPoints = [(elt.get('id'), elt.text) for elt in list(file.iter('seekvideo')) if elt.text is not None]

        # content = contextRegex.sub("", next(file.iter('content')).text)
        # content = content.replace('\n', ' ')
        # content = content.replace('?', '.')
        # content = content.replace('--', '.')
        # content = content.split(". ")
        # content = list(filter(None, content))
        # talks[talkid] = content
        talks[talkid] = videoPoints

    return talks

def writeTalk(talks, lang):
    for talk in talks:
        filename = "/".join(["talks", lang, talk])
        with open(filename, "w") as f:
            for tm, text in talks[talk]:
                f.write(text.replace("\n", " ") + "\n")
def keepMatching(a, b):
    keys = [kb for kb in b]
    for kb in keys:
        if not kb in a:
            del b[kb]
    keys = [ka for ka in a]
    for ka in keys:
        if not ka in b:
            del a[ka]

    keys = [ka for ka in a]
    for k in keys:
        ida = [elt[0] for elt in a[k]]
        idb = [elt[0] for elt in b[k]]
        if not ida == idb:
            del a[k]
            del b[k]

talkfr = getTalks('./ted_fr-20160408.xml')
talken = getTalks('./ted_en-20160408.xml')
keepMatching(talkfr, talken)
writeTalk(talkfr, 'fr')
writeTalk(talken, 'en')
