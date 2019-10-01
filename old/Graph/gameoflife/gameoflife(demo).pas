{$APPTYPE GUI}
program GameOfLife;
uses graph,winmouse,windows,wincrt;
const pix=1;
var x,y,i,j,maxx,maxy,dx,dy,c,lx,ly:integer;
    mx,my,ms:longint;
    a,b:array[1..5000,1..5000]of byte;
    f:array[0..242,0..242]of byte;
procedure draw();
var i,j:integer;
begin
    cleardevice;
    for i:=1 to maxx do
        for j:=1 to maxy do
            if a[i,j]=1
                then bar((i-1)*pix,(j-1)*pix,i*pix-1,j*pix-1);
end;

procedure createf(l,u,w:longint);
begin
    if w=1 then begin f[l,u]:=1;exit;end;
    w:=w div 3;
    createf(l,u,w);
    createf(l,u+w,w);
    createf(l+w,u,w);
    createf(l,u+w+w,w);
    createf(l+w+w,u,w);
    createf(l+w+w,u+w,w);
    createf(l+w,u+w+w,w);
    createf(l+w+w,u+w+w,w);
end;

begin
    initgraph(x,y,'');
    setwindowtext(graphwindow,'Conway''s Game of Life');
    randomize;
    setfillstyle(1,white);
    maxx:=getmaxx div pix;maxy:=getmaxy div pix;
    lx:=getmaxx+10;ly:=getmaxy+10;
    createf(0,0,243);
    for x:=0 to 242 do
        for y:=0 to 242 do
            a[maxx>>1+x-121,maxy>>1+y-121]:=f[x,y];
    draw();
    while 1=1 do begin
        if findwindow(nil,'Conway''s Game of Life')=0 then halt;
        getmousestate(mx,my,ms);
        x:=mx div pix+1;y:=my div pix+1;
        if ((lx<>x)or(ly<>y))and(mx>=0)and(my>=0)and(mx<=getmaxx)and(my<=getmaxy) then begin
            if a[lx,ly]=0 then setfillstyle(1,black) else setfillstyle(1,white);
            bar((lx-1)*pix+1,(ly-1)*pix+1,lx*pix-2,ly*pix-2);
            setfillstyle(1,red);
            bar((x-1)*pix+1,(y-1)*pix+1,x*pix-2,y*pix-2);
            setfillstyle(1,white);
            lx:=x;ly:=y;
        end;
        if ms>0 then begin
            a[x,y]:=1 xor a[x,y];
            if a[x,y]=1 then bar((x-1)*pix,(y-1)*pix,x*pix-1,y*pix-1)else begin
                setfillstyle(1,black);
                bar((x-1)*pix,(y-1)*pix,x*pix-1,y*pix-1);
                setfillstyle(1,white);
            end;
            repeat getmousestate(mx,my,ms);until ms=0;
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
