program EquationSolver;
{$MODE OBJFPC}
const inf:extended=1e10;eps:extended=1e-14;
type eq=array[1..1010]of extended;
var n,i,sum:longint;
    p,s:eq;
function get0pos(l,r:extended;var p:eq;n:longint;var res:extended):boolean;
var mid,ptl,pl,pr,pmid:extended;i:longint;
begin
    pl:=0;pr:=0;
    for i:=1 to n+1 do pl:=pl*l+p[i];
    for i:=1 to n+1 do pr:=pr*r+p[i];
    ptl:=pl;
    if (pl<-eps) and (pr<-eps) or (pl>eps) and (pr>eps) then exit(false);
    while abs(r-l)>eps do begin
        mid:=(l+r)/2;pmid:=0;
        for i:=1 to n+1 do pmid:=pmid*mid+p[i];
        if (pl<pr) and (pmid>eps) or (pl>pr) and (pmid<-eps)
            then begin r:=mid;pr:=pmid;end
            else begin l:=mid;pl:=pmid;end;
    end;
    res:=l;
    if abs(pl-ptl)>eps
        then result:=true
        else result:=false
end;
function solve(var p,s:eq;n:longint):longint;
var a,b:eq;m,i:longint;
    l,r,tmp:extended;
begin
    if n=1 then begin
        s[1]:=-p[2]/p[1];
        exit(1);
    end;
    for i:=1 to n do a[i]:=p[i]*(n+1-i);
    result:=0;
    m:=solve(a,b,n-1);
    for i:=1 to n do begin
        if i=1 then l:=-inf else l:=b[i-1];
        if i=n then r:=inf else r:=b[i];
        if get0pos(l,r,p,n,tmp) then begin
            inc(result);
            s[result]:=tmp;
        end;
    end;
end;
begin
    while not eof do begin
        read(n);
        for i:=1 to n+1 do read(p[i]);
        sum:=solve(p,s,n);
        writeln('Number of real roots : ',sum);
        for i:=1 to sum do writeln('X',i,' = ',s[i]:0:10);
    end;
end.
