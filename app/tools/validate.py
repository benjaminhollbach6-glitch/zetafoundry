import subprocess, tempfile, os, py_compile
def _tmp(text:str,ext:str):
    fd,p=tempfile.mkstemp(prefix="zfx_",suffix=ext,text=True)
    with os.fdopen(fd,"w",encoding="utf-8",newline="\n") as f: f.write(text)
    return p
def bash_policy(text:str):
    e=[]
    if "set -euo pipefail" not in text: e.append("Policy: set -euo pipefail fehlt")
    if not text.startswith("#!/"): e.append("Shebang fehlt")
    if "\r" in text: e.append("CRLF gefunden")
    return e
def bash_syntax(text:str):
    p=_tmp(text,".sh")
    try:
        r=subprocess.run(["bash","-n",p],capture_output=True,text=True)
        return (r.returncode==0, r.stderr.strip() or "OK")
    finally: os.unlink(p)
def py_syntax(text:str):
    p=_tmp(text,".py")
    try:
        py_compile.compile(p,doraise=True); return True,"OK"
    except Exception as e: return False,str(e)
    finally: os.unlink(p)
def validate(lang:str,text:str)->dict:
    if lang=="bash":
        pol=bash_policy(text); ok, msg=bash_syntax(text); return {"policy":pol,"syntax_ok":ok,"syntax_msg":msg}
    if lang=="python":
        ok,msg=py_syntax(text); return {"policy":[],"syntax_ok":ok,"syntax_msg":msg}
    return {"policy":["unsupported"],"syntax_ok":False,"syntax_msg":"unsupported"}
