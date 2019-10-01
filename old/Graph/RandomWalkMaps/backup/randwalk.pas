uses windows,wincrt,math,sysutils,graph;
const maxlen=1000;
    color:array[1..9,1..3]of integer=((100,170,60),(192,219,129),(236,242,197),(254,244,214),
            (254,234,190),(252,215,161),(249,193,112),(230,212,231),(255,255,255));
var gd,gm:integer;x,len,i,j,s,t:longint;
    tm:array[1..2000,1..1000]of longint; //sum of adjacent cells' reaching times
    l:array[1..2]of record x,y:integer;end;
procedure draw(x,y:integer);
var t:integer;
begin
    t:=round(tm[x,y]/20)+1;
    if t>9 then t:=9;
    setrgbpalette(16,color[t,1],color[t,2],color[t,3]);
    putpixel(x,y,16);
end;
begin
initgraph(gd,gm,'');
setwindowtext(graphwindow,'Random walk');
setfillstyle(1,lightblue);
bar(1,1,getmaxx,getmaxy);
randomize;
l[1].x:=getmaxx>>1;l[1].y:=getmaxy>>1;
for i:=-1 to 1 do for j:=-1 to 1 do begin
    inc(tm[l[1].x+i,l[1].y+j]);
    if tm[l[1].x+i,l[1].y+j]=1 then inc(t);
    draw(l[1].x+i,l[1].y+j)
end;
len:=1;
while 1=1 do begin
    if not((l[len].x>2)and(l[len].y>2)and(l[len].x<getmaxx-1)and(l[len].y<getmaxy-1))
        then begin
                readkey;
                dec(len);
                l[len].x:=random(getmaxx-5)+3;
                l[len].y:=random(getmaxy-5)+3;
                continue;
             end;
    len:=2;
    repeat
        l[len].x:=l[len-1].x+random(3)-1;
        l[len].y:=l[len-1].y+random(3)-1;
    until (l[len].x<>l[len-1].x)or(l[len].y<>l[len-1].y);
    for i:=-1 to 1 do for j:=-1 to 1 do begin
        inc(tm[l[len].x+i,l[len].y+j]);
        if tm[l[len].x+i,l[len].y+j]=1 then inc(t);
        draw(l[len].x+i,l[len].y+j);
    end;
    setfillstyle(1,red);
    fillellipse(getmaxx>>1,getmaxy>>1,3,3);
    setfillstyle(1,lightblue);
    bar(1,1,500,30);
    inc(s);
    outtextxy(1,1,inttostr(s)+' Step(s), Distance = '+
        floattostr(hypot(l[len].x-getmaxx>>1,l[len].y-getmaxy>>1))+
        ', Area = '+inttostr(t));
    l[len-1]:=l[len];
end;
while 1=1 do;
end.
