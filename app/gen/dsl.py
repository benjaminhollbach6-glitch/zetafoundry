import re
TOK=re.compile(r"[a-zA-Z0-9_]+")
def parse_dsl(s:str)->list[str]:
    return TOK.findall(s.lower())
