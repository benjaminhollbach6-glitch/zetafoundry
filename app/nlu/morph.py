import re
import simplemma
from simplemma import lemmatize
def tokens(t:str): return re.findall(r"[a-zA-Z0-9\-/\+]+", t.lower())
def lemmas(t:str, lang='de'): return [lemmatize(x,{'de'}) for x in tokens(t)]
