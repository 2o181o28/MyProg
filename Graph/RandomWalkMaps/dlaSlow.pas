uses graph,mmath,math;
var x,y,tx,ty,maxx,maxy:integer;
    tm,i,j,f,t,lp:longint;
    vi,vj:array [1..1000]of integer;
    a:array[0..1500,0..1000]of longint;
procedure rd(var x:integer;v:longint;bd:longint);
begin
    x:=v+random(3)-1;
    if x<0 then x:=0;
    if x>=bd then x:=bd-1;
end;
begin
    randomize;
    initgraph(x,y,'');
    maxx:=getmaxx;maxy:=getmaxy;
    a[maxx>>1][maxy>>1]:=1;tm:=1;
    while 1=1 do begin
        x:=random(maxx);
        y:=random(maxy);
        t:=3;lp:=0;
        while 1=1 do begin
        f:=0;inc(lp);
        if lp>1e4 then break;
        for tx:=x-t to x+t do
            for ty:=y-t to y+t do
                if (tx>=0) and (tx<maxx) and (ty>=0) and (ty<maxy)
                and (a[tx][ty]<>0) then begin
                    inc(f);
                    rd(vi[f],tx,maxx);rd(vj[f],ty,maxy);
                end;
        if (f>=1)and(f<2) then break;
        rd(x,x,maxx);rd(y,y,maxy);
        end;
        if lp>1e4 then continue;
        j:=random(f)+1;i:=vi[j];j:=vj[j];
        inc(tm);a[i][j]:=tm;
        putpixel(i,j,tm div 10000 mod 15+1);
    end;
    while 1=1 do;
end.
