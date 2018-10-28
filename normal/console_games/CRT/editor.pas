uses
    CRT,Math;
const
    maxw=80;maxh=25;
var
    x,y,i,endh:integer;
    key:longint;
    endp:array [1..maxh+2] of integer;
    txt:array [1..maxh+2,1..maxw+2] of char;
procedure GetKey();
begin
    repeat until KeyPressed();
    key:=ord(ReadKey());
    if key=0 then key:=ord(ReadKey())<<8;
end;

procedure memmove(dst,src:pchar;size:dword);cdecl;external'msvcrt';
procedure mmove(x1,y1,e1,x2,y2:integer);inline;
begin
    memmove(@(txt[x2][y2]),@(txt[x1][y1]),(e1-y1+1)*sizeof(txt[x1][y1]));
end;

procedure BackSp();
var i,lp:integer;
begin
    if (x=1) and (y=1) then exit;
    if y>1 then begin
        mmove(x,y,endp[x],x,y-1);
        txt[x][endp[x]-1]:=#0;
        dec(y);dec(endp[x]);
        GoToXY(y,x);
        for i:=y to endp[x] do write(txt[x][i]);
        GoToXY(y,x);
    end else begin
        lp:=endp[x-1];
        mmove(x,y,endp[x],x-1,endp[x-1]);
        inc(endp[x-1],endp[x]-1);
        memmove(@(txt[x]),@(txt[x+1]),sizeof(txt[x+1])*(endh+1-x));
        memmove(@(endp[x]),@(endp[x+1]),sizeof(endp[x+1])*(endh+1-x));
        dec(endh);
        DelLine();
        dec(x);y:=lp;
        GoToXY(y,x);
        for i:=y to endp[x]-1 do write(txt[x][i]);
        GoToXY(y,x);
    end;
end;

procedure Enter();
var i:integer;
begin
    if x=maxh then exit;
    memmove(@(txt[x+2]),@(txt[x+1]),sizeof(txt[x+1])*(endh+1-x));
    memmove(@(endp[x+2]),@(endp[x+1]),sizeof(endp[x+1])*(endh+1-x));
    inc(endh);
    mmove(x,y,endp[x],x+1,1);
    for i:=y to endp[x]-1 do begin write(' ');txt[x][i]:=#0;end;
    endp[x+1]:=endp[x]-y+1;endp[x]:=y;
    inc(x);y:=1;
    GoToXY(y,x);
    InsLine();
    for i:=1 to endp[x] do write(txt[x][i]);
    GoToXY(y,x)
end;

procedure WriteKey(key:char);
var
    i:integer;
begin
    if endp[x]>=maxw then exit;
    mmove(x,y,endp[x]-1,x,y+1);
    txt[x][y]:=key;
    write(key);
    inc(y);inc(endp[x]);
    GoToXY(y,x);
    for i:=y to endp[x]-1 do write(txt[x][i]);
    GoToXY(y,x);
end;

procedure DelLn();
begin
    memmove(@(txt[x]),@(txt[x+1]),sizeof(txt[x+1])*(endh+1-x));
    memmove(@(endp[x]),@(endp[x+1]),sizeof(endp[x+1])*(endh+1-x));
    dec(endh);
    if endh=0 then endh:=1;
    DelLine();
    y:=min(y,endp[x]);
    GoToXY(y,x);
end;

procedure Tab();
var i:integer;
begin
    if endp[x]+4>=maxw then exit;
    mmove(x,y,endp[x]-1,x,y+4);
    for i:=0 to 3 do txt[x][y+i]:=' ';
    write('    ');
    inc(y,4);inc(endp[x],4);
    GoToXY(y,x);
    for i:=y to endp[x]-1 do write(txt[x][i]);
    GoToXY(y,x);
end;

procedure left();
begin
    if y>1 then dec(y) else if x>1 then begin dec(x);y:=endp[x];end;
    GoToXY(y,x);
end;

procedure right();
begin
    if y<endp[x] then inc(y) else if x<endh then begin inc(x);y:=1;end;
    GoToXY(y,x);
end;

begin
    ClrScr();
    x:=1;y:=1;endh:=1;
    for i:=1 to maxh+2 do endp[i]:=1;
    repeat
        GetKey();
        if (key=27) or (key=11520)
            then exit;
        case key of
            4  : DelLn();
            8  : BackSp();
            9  : Tab();
            13 : Enter();
            18432 : begin if x>1 then dec(x);y:=min(y,endp[x]);GoToXY(y,x);end;
            20480 : begin if x<endh then inc(x);y:=min(y,endp[x]);GotoXY(y,x);end;
            19200 : left();
            19712 : right();
            18176 : begin y:=1;GoToXY(y,x);end;
            20224 : begin y:=endp[x];GoToXY(y,x);end;
            21248 : if (y<endp[x]) or (x<endh) then begin right();BackSp();end;
            else if key<=255 then WriteKey(chr(key))
        end;
    until false;
end.
