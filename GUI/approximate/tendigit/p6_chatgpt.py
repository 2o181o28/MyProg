#!/usr/bin/env python3
from decimal import Decimal, getcontext
from math import comb
getcontext().prec = 90

def next_state(s,d):
    if s==1 and d==2:
        return None
    return 1 if d==4 else 0

def compute_prefix_power_sums(L, P):
    A = [[Decimal(0) for _ in range(P+1)] for _ in range(2)]
    stack=[("",0)]
    while stack:
        pref, s = stack.pop()
        t=len(pref)
        if t==L:
            a=int(pref)
            da=Decimal(a)
            inv=Decimal(1)/da
            powv=inv
            for p in range(1,P+1):
                if p==1:
                    A[s][p] += inv
                    powv=inv
                else:
                    powv = powv*inv
                    A[s][p] += powv
            continue
        digits = range(1,10) if t==0 else range(0,10)
        for d in digits:
            ns=next_state(s,d)
            if ns is None:
                continue
            stack.append((pref+str(d), ns))
    return A

def brute_small(limit):
    tot=Decimal(0)
    for n in range(1,limit):
        if "42" not in str(n):
            tot += Decimal(1)/Decimal(n)
    return tot

def compute_sum(L=5, J=10, Mmax=8000):
    P=J+1
    A=compute_prefix_power_sums(L,P)
    small=brute_small(10**(L-1))
    binom=[[Decimal(comb(j,i)) for i in range(j+1)] for j in range(J+1)]
    d_pows=[[Decimal(1)] + [Decimal(d)**k for k in range(1,J+1)] for d in range(10)]
    ten=Decimal(10)
    dp=[ [ [Decimal(0) for _ in range(J+1)] for _ in range(2) ] for _ in range(2)]
    for s0 in (0,1):
        dp[s0][s0][0]=Decimal(1)
    total=Decimal(0)
    # m=0
    term=Decimal(0)
    for s0 in (0,1):
        M=[dp[s0][0][j]+dp[s0][1][j] for j in range(J+1)]
        for j in range(J+1):
            term += (Decimal(-1) if j%2 else Decimal(1)) * M[j] * A[s0][j+1]
    total += term  # ten**0 =1=None
    for t in range(0, Mmax):
        scale = ten ** (-(t+1))
        scale_pows=[Decimal(1)]
        for k in range(1,J+1):
            scale_pows.append(scale_pows[-1]*scale)
        newdp=[ [ [Decimal(0) for _ in range(J+1)] for _ in range(2) ] for _ in range(2)]
        for s0 in (0,1):
            for st in (0,1):
                arr=dp[s0][st]
                # quick skip
                if arr[0]==0 and all(v==0 for v in arr[1:]):
                    continue
                for d in range(10):
                    ns=next_state(st,d)
                    if ns is None: 
                        continue
                    for j in range(J+1):
                        ssum=Decimal(0)
                        for i in range(j+1):
                            ssum += binom[j][i]*arr[i]*d_pows[d][j-i]*scale_pows[j-i]
                        newdp[s0][ns][j] += ssum
        dp=newdp
        m=t+1
        term=Decimal(0)
        for s0 in (0,1):
            M=[dp[s0][0][j]+dp[s0][1][j] for j in range(J+1)]
            for j in range(J+1):
                term += (Decimal(-1) if j%2 else Decimal(1)) * M[j] * A[s0][j+1]
        term *= ten**(-m)
        total += term
        abs_term=abs(term)
        if m>200 and abs_term < Decimal('1e-40'):
            break
        # optional convergence detection
    return small + total, m

S, m_used=compute_sum()
print(S, m_used)
