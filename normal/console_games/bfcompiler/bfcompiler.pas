const max=10000000;
var a:array[0..max]of char;
    stack,next:array[0..max]of longint;
    p,top,i,len:longint;
    src,path:ansistring;
    f:text;c:char;
procedure runerror201(x,p:longint);
begin
    writeln;writeln('Range check error at char ',x,', address ',p);
    readln;
    halt;
end;
procedure compileerror(x:longint);
begin
    writeln;writeln('Brackets mismatch at char ',x);
    readln;
    halt;
end;
begin
    write('File to compile: ');
    readln(path);
    assign(f,path);reset(f);
    while not eof(f) do begin
        read(f,c);
        src:=src+c;
    end;
    close(f);
    len:=length(src);
    for i:=1 to len do
        case src[i] of
            '[':begin inc(top);stack[top]:=i;end;
            ']':begin
                    if top=0 then compileerror(i);
                    next[stack[top]]:=i;dec(top);
                end;
        end;
    if top<>0 then compileerror(len+1);
    writeln('Compile successful: Press ды to run the program');
    readln;
    i:=1;top:=0;
    while i<=len do begin
        case src[i] of
            '.':write(a[p]);
            ',':read(a[p]);
            '<':if p>0 then dec(p) else runerror201(i,p);
            '>':if p<max then inc(p) else runerror201(i,p);
            '+':if a[p]<#255 then a[p]:=succ(a[p]) else a[p]:=#0;
            '-':if a[p]>#0 then a[p]:=pred(a[p]) else a[p]:=#255;
            '[':begin
                    if a[p]=#0 then i:=next[i] else begin
                        inc(top);
                        stack[top]:=i;
                    end;
                end;
            ']':if a[p]<>#0 then i:=stack[top] else dec(top);
        end;
        inc(i);
    end;
    writeln;
    writeln('Finish running: Press ды to exit');
    readln;
end.
