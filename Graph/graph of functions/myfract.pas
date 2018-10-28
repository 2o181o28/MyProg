uses graph;
var gd,gm:integer;
    i:longint;
    lx,uy,w:extended;
procedure line(a,b,c,d:extended);
begin
    graph.line(round(a),round(b),round(c),round(d));
end;
procedure draw(lx,uy,w:extended;f:integer);
begin
    if w<1 then exit;
    w:=w/2;
    if (f=1)or(f=3)
        then begin line(lx,uy,lx+w,uy);draw(lx+w,uy,w,f)end
        else begin line(lx,uy,lx-w,uy);draw(lx-w,uy,w,f)end;
    if (f=1)or(f=2)
        then begin line(lx,uy,lx,uy+w);draw(lx,uy+w,w,f)end
        else begin line(lx,uy,lx,uy-w);draw(lx,uy-w,w,f)end;
end;
procedure draw1(lx,uy,w:extended;f:integer);
begin
    if w<1 then exit;
    w:=w/2;
    if (f=1)or(f=3)
        then begin line(lx,uy,lx-w,uy+w);draw1(lx-w,uy+w,w,f);end
        else begin line(lx,uy,lx+w,uy-w);draw1(lx+w,uy-w,w,f);end;
    if (f=1)or(f=2)
        then begin line(lx,uy,lx+w,uy+w);draw1(lx+w,uy+w,w,f);end
        else begin line(lx,uy,lx-w,uy-w);draw1(lx-w,uy-w,w,f);end;
end;
begin
    initgraph(gd,gm,'');
    w:=getmaxy;
    lx:=(getmaxx-w)/2;
    uy:=1;
    for i:=1 to 10 do begin
        draw(lx,uy,w/2,1);
        draw(lx+w,uy,w/2,2);
        draw(lx,uy+w,w/2,3);
        draw(lx+w,uy+w,w/2,4);
        draw1(lx+w/2,uy,w/4,1);
        draw1(lx,uy+w/2,w/4,2);
        draw1(lx+w,uy+w/2,w/4,3);
        draw1(lx+w/2,uy+w,w/4,4);
        w:=w/2;
        lx:=lx+w/2;uy:=uy+w/2;
    end;
    while 1=1 do;
end.
