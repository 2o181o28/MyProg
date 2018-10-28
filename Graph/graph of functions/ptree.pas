program Pythagoras_tree;
uses math,graph,windows;
const cl:array[1..8]of integer=(white,yellow,lightgreen,green,cyan,lightblue,blue,black);
var x,y:integer;ang:extended;
procedure draw(l,u,r,d:extended;dep:longint);
var pl:array[1..5]of record x,y:integer;end;
    x1,y1,x2,y2,x3,y3:extended;
begin
    if(l<0)or(u<0)or(r>640)or(d>480)or(l>640)or(u>480)or(r<0)or(d<0) then exit;
    if (hypot(d-u,r-l)<3)or(dep>8) then exit;
    x1:=cos(arctan2(u-d,r-l)+pi/4)*hypot(d-u,r-l)/sqrt(2)+l;
    y1:=-sin(arctan2(u-d,r-l)+pi/4)*hypot(d-u,r-l)/sqrt(2)+u;
    x2:=l+r-x1;y2:=u+d-y1;
    pl[1].x:=round(l);pl[1].y:=round(u);
    pl[2].x:=round(x1);pl[2].y:=round(y1);
    pl[3].x:=round(r);pl[3].y:=round(d);
    pl[4].x:=round(x2);pl[4].y:=round(y2);
    pl[5]:=pl[1];
    setcolor(black);
    setfillstyle(1,cl[dep]);
    fillpoly(5,pl);
    x3:=cos(arctan2(u-d,r-l)+pi/4+ang)*hypot(x1-l,y1-u)*cos(ang)+l;
    y3:=-sin(arctan2(u-d,r-l)+pi/4+ang)*hypot(x1-l,y1-u)*cos(ang)+u;
    pl[3].x:=round(x3);pl[3].y:=round(y3);
    pl[4]:=pl[1];
    drawpoly(4,pl);
    draw(l-u+y3,u+l-x3,x3,y3,dep+1);
    draw(x3+y1-y3,y3-x1+x3,x1,y1,dep+1);
end;
begin
while 1=1 do begin
    write('Input an angle in (0,90) : ');
    read(ang);
    ang:=ang*pi/180;
    x:=vga;y:=vgahi;
    initgraph(x,y,'');
    setfillstyle(1,white);
    bar(1,1,640,480);
    setwindowtext(graphwindow,'Pythagoras tree');
    draw(320-30,350,320+30,350+60,1);
    sleep(10000);
    closegraph;
end;
end.