uses
    graph,math,wincrt;
const
    k=32; //k in [28..44] (need to be adjusted for other expressions)
var
    maxx,maxy,x,y:integer;
function f(x,y:int64):longint;
var e:double;
    a:qword absolute e;
begin
    e:=ln(x)+ln(y);    //almost all expressions can work
    f:=(a>>k) and $ff; //some middle bits of e, near the float point
end;
begin
    x:=detect;
    initgraph(x,y,'');
    maxx:=getmaxx;maxy:=getmaxy;
    for x:=1 to maxx do
        for y:=1 to maxy do
            putpixel(x,y,f(x,y));
    readkey;
end.
