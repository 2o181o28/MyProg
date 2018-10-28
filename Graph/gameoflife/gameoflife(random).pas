{$APPTYPE GUI}
program GameOfLife;
uses graph,winmouse,windows,wincrt;
const pix=5;
var x,y,i,j,maxx,maxy,dx,dy,c:integer;
    mx,my,ms:longint;lt:dword;
    a,b:array[1..5000,1..5000]of byte;
procedure draw();
var i,j:integer;
begin
    cleardevice;
    for i:=1 to maxx do
        for j:=1 to maxy do
            if a[i,j]=1
                then bar((i-1)*pix,(j-1)*pix,i*pix-1,j*pix-1);
end;
begin
    initgraph(x,y,'');
    setwindowtext(graphwindow,'Conway''s Game of Life');
    randomize;
    setfillstyle(1,white);
    maxx:=getmaxx div pix;maxy:=getmaxy div pix;
    for i:=1 to maxx do
        for j:=1 to maxy do
            a[i,j]:=random(2);
    draw;
    while 1=1 do begin
        if findwindow(nil,'Conway''s Game of Life')=0 then halt;
        getmousestate(mx,my,ms);
        if (ms>0)and(gettickcount()-lt>160) then begin
            x:=mx div pix+1;y:=my div pix+1;
            a[x,y]:=1 xor a[x,y];
            if a[x,y]=1 then bar((x-1)*pix,(y-1)*pix,x*pix-1,y*pix-1)else begin
                setfillstyle(1,black);
                bar((x-1)*pix,(y-1)*pix,x*pix-1,y*pix-1);
                setfillstyle(1,white);
            end;
            lt:=gettickcount();
        end;
        if keypressed then begin readkey;
        fillchar(b,sizeof(b),0);
        for i:=1 to maxx do
            for j:=1 to maxy do begin
                c:=0;
                for dx:=-1 to 1 do
                    for dy:=-1 to 1 do
                        if ((dx<>0)or(dy<>0))and(i+dx>0)and(j+dy>0)
                            and(i+dx<=maxx)and(j+dy<=maxy)and(a[i+dx,j+dy]=1)
                            then inc(c);
                if (a[i,j]=1)and(c>1)and(c<4)then b[i,j]:=1;
                if (a[i,j]=0)and(c=3)then b[i,j]:=1;
            end;
        a:=b;
        draw;
        end;
    end;
end.
