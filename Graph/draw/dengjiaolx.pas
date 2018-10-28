uses graph,windows;
var x,y,maxx,maxy:integer;
    r,theta:extended;k:longint;
function putpix(r,t:extended;k:longint):boolean;
var x,y:extended;
begin
    x:=r*cos(t);y:=r*sin(t);
    if abs(x/k)>maxx then exit(false) else x:=x/k+maxx;
    if abs(y/k)>maxy then exit(false) else y:=y/k+maxy;
    putpixel(round(x),round(y),white);
    exit(true)
end;
begin
    initgraph(x,y,'');
    maxx:=getmaxx div 2;
    maxy:=getmaxy div 2;
    theta:=0;
    for k:=1 to 10000 do begin
        theta:=0;
        while 1=1 do begin
            r:=exp(theta);
            if not putpix(r,theta,k) then break;
            theta:=theta + 0.001;
        end;
        cleardevice;
    end;
end.
