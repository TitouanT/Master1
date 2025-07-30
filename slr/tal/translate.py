import googletrans as ggl
translator = ggl.Translator()

def en2fr(p):
    return [res.text for res in translator.translate(p, dest="fr", src="en")]

def fr2en(p):
    return [res.text for res in translator.translate(p, dest="en", src="fr")]
