{$APPTYPE GUI}
program DLA;
uses graph,math,windows;
const dx:array [1..4] of integer=(-1,0,1,0);
    dy:array [1..4] of integer = (0,1,0,-1);
    len=2200000;
type rec=record x,y:longint;end;
var x,y,maxx,maxy:integer;
    tm,t,i,j,f,l,r,p,qs:longint;
    que:array[0..len]of rec;
    a:array[0..2000,0..1100]of longint;
function chk(v,bd:longint):boolean;
begin
    chk:=(v>=0) and (v<bd);
end;
procedure swap(var a,b:rec);
var t:rec;
begin
    t:=a;a:=b;b:=t;
end;
begin
    randomize;
    initgraph(x,y,'');
    SetWindowText(GraphWindow,'DLA');
    maxx:=getmaxx;maxy:=getmaxy;
    l:=0;r:=-1;
    for i:=0 to maxx-1 do
        for j:=0 to maxy-1 do
            if random(6)=1 then begin
                if random(2000)=1 then
                    a[i][j]:=255
                    else begin
                        inc(r);
                        with que[r] do begin
                            x:=i;y:=j;a[i][j]:=1;
                        end;
                    end;
            end;
    qs:=r+1;
    while qs>0 do begin
	if (t mod 10000=0) and (FindWindow(nil,'DLA')=0) then exit;
        p:=(random(qs)+l)mod len;
        x:=que[p].x;y:=que[p].y;
        swap(que[p],que[l]);
        f:=0;inc(t);
        for j:=1 to 4 do if chk(x+dx[j],maxx) and chk(y+dy[j],maxy) then
            f:=max(f,a[x+dx[j]][y+dy[j]]);
        if f>2 then begin
            a[x][y]:=f-1;l:=(l+1)mod len;dec(qs);
            setrgbpalette(17,256-f,256-f,f-1);
            putpixel(x,y,17);
        end else begin
            tm:=(tm and 3)+1;
            if chk(x+dx[tm],maxx) and chk(y+dy[tm],maxy)
            and (a[x+dx[tm]][y+dy[tm]]=0) then begin
                l:=(l+1)mod len;a[x][y]:=0;a[x+dx[tm]][y+dy[tm]]:=1;
                r:=(r+1)mod len;que[r].x:=x+dx[tm];que[r].y:=y+dy[tm];
            end;
        end;
    end;
end.
