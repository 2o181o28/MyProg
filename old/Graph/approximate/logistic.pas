uses sysutils,graph,
    {$ifdef win32}wincrt{$else}crt{$endif};
label l;
const max=10000000;
var maxx,maxy,w,left,nc:longint;
    n,k0:extended;
    gd,gm:integer;
    na:array[0..3,0..max]of extended;
    c:char;h:boolean=true;
procedure draw(k:extended;tp,c,l:longint);
var n:extended;u,lc,x:longint;
begin
    lc:=nc;
    u:=round(maxy/3*(tp-1));
    if h then
        for x:=0 to 10 do begin
            setcolor(c);
            outtextxy(0,round(x/10*maxy/3.7+20)+u,floattostr(1-x/10));
            setcolor(16);
            line(30,round(x/10*maxy/3.7+25)+u,maxx,round(x/10*maxy/3.7+25)+u);
        end;
    setcolor(c);
    if na[tp,l]=0 then halt(-1) else n:=na[tp,l];
    moveto(30,u+round((maxy-n*maxy)/3.7+25));
    for x:=l+1 to l+w do begin
        if nc>=x then n:=na[tp,x] else begin
            n:=k*n*(1-n);
            inc(nc);
            na[tp,nc]:=n;
        end;
        if (n<=0)or(n>=1) then begin outtext(' (breaks here)');break;end;
        lineto(((x-1) mod w+1)<<3+30,u+round((maxy-n*maxy)/3.7+25));
    end;
    outtextxy(0,u+5,'k = '+floattostr(k)+'   n = '+inttostr(left)
                    +'..'+inttostr(x));
    if tp<>3 then nc:=lc;
end;
begin
    write('Input k : ');
    read(k0);
    initgraph(gd,gm,'');
    setrgbpalette(16,64,64,64);
    maxx:=getmaxx;maxy:=getmaxy;
    w:=(maxx-30)>>3;
    na[1,0]:=0.1;na[2,0]:=0.1;na[3,0]:=0.1;
    l:cleardevice;
    draw(k0-0.001,1,blue,left);
    draw(k0,2,green,left);
    draw(k0+0.001,3,red,left);
    c:=readkey;
    if c=#0 then c:=readkey;
    if c=#72 then begin k0:=k0-0.003;nc:=0;left:=0;end else
    if c=#80 then begin k0:=k0+0.003;nc:=0;left:=0;end else
    if c=#32 then h:=not h else
    if (c=#75)and(left>0) then dec(left,w) else
    if (c=#77)and(left+w<=nc)then inc(left,w);
    goto l;
end.
