//Solve the Steiner Tree problem approximately with genetic algorithm
uses windows,graph,math,wincrt,winmouse,sysutils;
const m=100;p1=0.8;p2=0.1;
type eg=record x,y:longint;w:real;end;
var gd,gm,po:integer;
    tm,i,j,cnt,n,p,mp,m1,m2,ms:longint;
    mx,mn:real;
    px,py,fa,deg:array [1..200] of longint;
    f:array [1..m] of real;
    e:array [1..20000] of eg;
    ax,ay,bx,by:array [1..m,1..100] of longint;

procedure swap(var x,y:longint);var t:longint;begin t:=x;x:=y;y:=t;end;
procedure swap(var x,y:real);var t:real;begin t:=x;x:=y;y:=t;end;
procedure swap(var x,y:eg);var t:eg;begin t:=x;x:=y;y:=t;end;
procedure sort1(l,r:longint);
var i,j:longint;x:real;
begin
    i:=l;j:=r;
    x:=e[(l+r) >> 1].w;
    repeat
        while e[i].w<x do inc(i);
        while x<e[j].w do dec(j);
        if i<=j then begin
            swap(e[i],e[j]);
            inc(i);dec(j);
        end;
    until i>j;
    if l<j then sort1(l,j);
    if i<r then sort1(i,r);
end;
procedure sort(l,r:longint);
var i,j,k:longint;x:real;
begin
    i:=l;j:=r;
    x:=f[(l+r) >> 1];
    repeat
        while f[i]<x do inc(i);
        while x<f[j] do dec(j);
        if i<=j then begin
            for k:=1 to po do swap(ax[i][k],ax[j][k]);
            for k:=1 to po do swap(ay[i][k],ay[j][k]);
            swap(f[i],f[j]);
            inc(i);dec(j);
        end;
    until i>j;
    if l<j then sort(l,j);
    if i<r then sort(i,r);
end;
procedure rand(x,y:longint);
var i,j,p:longint;
begin
    for i:=y downto x+1 do begin
        p:=random(i-x)+x;
        for j:=1 to po do
            begin swap(ax[p][j],ax[i][j]);swap(ay[p][j],ay[i][j]);end;
    end;
end;

function getf(p:longint):longint;
begin
    if fa[p]=p then exit(p);
    fa[p]:=getf(fa[p]);exit(fa[p]);
end;
function fun(p,fl:longint):real;
var i,j,m,cnt,u,v:longint;
begin
    fun:=0;
    for i:=n+1 to n+po do begin
        px[i]:=ax[p][i-n];py[i]:=ay[p][i-n];
    end;
    n:=n+po;
    m:=0;
//    for i:=1 to n do deg[i]:=0;
    for i:=1 to n-1 do
        for j:=i+1 to n do begin
            inc(m);
            with e[m] do begin
                x:=i;y:=j;w:=hypot(px[i]-px[j],py[i]-py[j]);
            end;
        end;
    cnt:=0;
    sort1(1,m);
    for i:=1 to n do fa[i]:=i;
    for i:=1 to m do begin
        u:=getf(e[i].x);v:=getf(e[i].y);
        if u<>v then begin
            inc(cnt);
            fun:=fun+e[i].w;
            fa[u]:=v;//inc(deg[e[i].x]);inc(deg[e[i].y]);
            if fl=1 then line(px[e[i].x],py[e[i].x],px[e[i].y],py[e[i].y]);
            if cnt=n-1 then break;
        end;
    end;
//    for i:=n+1 to n+po do
//        if deg[i]<=2 then fun:=fun+10;
    n:=n-po;
end;
procedure newv(var x:longint;mx:longint);
begin
    x:=x+random(50)*2-25;
    if (x<1) then x:=1;
    if (x>mx) then x:=mx;
//    x:=random(mx)+1;
end;
begin
    randomize;
    read(n,po);
    initgraph(gd,gm,'');
    setfillstyle(1,white);
    setcolor(white);
    for i:=1 to n do begin
        repeat getmousestate(px[i],py[i],ms) until ms>0;
        fillellipse(px[i],py[i],3,3);
        repeat getmousestate(m1,m2,ms) until ms=0;
    end;
    for i:=1 to m do
        for j:=1 to po do begin
            ax[i][j]:=random(getmaxx)+1;
            ay[i][j]:=random(getmaxy)+1;
        end;
    while 1=1 do begin
        mx:=-1e10;mn:=1e10;cnt:=0;
        for i:=1 to m do begin
            f[i]:=fun(i,0);
            mx:=max(mx,f[i]);mn:=min(mn,f[i]);
            if f[i]=mn then mp:=i;
        end;
        if tm mod 10=0 then begin
            cleardevice;
            setcolor(green);
            fun(mp,1);
            setfillstyle(1,white);
            setcolor(white);
            for i:=1 to n do
                fillellipse(px[i],py[i],3,3);
            setfillstyle(1,red);
            setcolor(red);
            for i:=1 to po do
                fillellipse(ax[mp][i],ay[mp][i],3,3);
            setwindowtext(graphwindow,pchar(floattostr(mn)+'    Generation #'+inttostr(tm)));
            sleep(10);
            if keypressed then begin readkey;readkey;end;
        end;
        for i:=1 to m do if sqr(random())>(f[i]-mn)/(mx-mn) then begin
            inc(cnt);
            bx[cnt]:=ax[cnt];by[cnt]:=ay[cnt];
        end;
        ax:=bx;ay:=by;
        for i:=1 to cnt do f[i]:=fun(i,0);
        sort(1,cnt);
        for i:=1 to m-cnt do begin ax[cnt+i]:=ax[i];ay[cnt+i]:=ay[i];end;
        rand(1,cnt);
        for i:=1 to cnt-1 do if (i mod 2=1) and (random()<p1) then begin
            p:=random(po-1)+1;
            for j:=p+1 to po do begin
                swap(ax[i][j],ax[i+1][j]);
                swap(ay[i][j],ay[i+1][j]);
            end;
            if random()<p2 then begin
                newv(ax[i][random(po)+1],getmaxx);
                newv(ay[i][random(po)+1],getmaxy);
            end;
            if random()<p2 then begin
                newv(ax[i+1][random(po)+1],getmaxx);
                newv(ay[i+1][random(po)+1],getmaxy);
            end;
        end;
        inc(tm);
    end;
end.
