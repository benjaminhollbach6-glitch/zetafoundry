# VortexShardRank: k-Shingle Jaccard + circulant Nachbarn + PageRank-Variante
import re
def sents(t): return [s.strip() for s in re.split(r'(?<=[.!?])\s+', t.strip()) if s.strip()]
def tokens(s): return re.findall(r"[a-zA-Z0-9\-]+", s.lower())
def shingles(x,k=2):
    x=tokens(x); 
    return {tuple(x[i:i+k]) for i in range(max(1,len(x)-k+1))}
def sim(a,b,k=2):
    A,B=shingles(a,k), shingles(b,k)
    if not A or not B: return 0.0
    inter=len(A&B); uni=len(A|B) or 1
    return inter/uni
def summarize(text,max_sent=3,k=2,iters=22,d=0.86):
    S=sents(text); n=len(S)
    if n<=max_sent: return " ".join(S)
    W=[[0.0]*n for _ in range(n)]
    for i in range(n):
        for j in range(n):
            if i==j: continue
            w = sim(S[i],S[j],k)
            if j==((i+1)%n) or j==((i-1)%n): w *= 1.15
            W[i][j]=w
    R=[1.0]*n
    for _ in range(iters):
        new=[]
        for i in range(n):
            denom=sum(W[j]) or 1.0
            s=sum(W[j][i]*R[j]/denom for j in range(n) if j!=i)
            new.append((1-d)+d*s)
        R=new
    idx=sorted(range(n), key=lambda i:R[i], reverse=True)[:max_sent]
    return " ".join(S[i] for i in sorted(idx))
