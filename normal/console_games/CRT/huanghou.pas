uses crt;
var a:array[1..100]of longint;
    n,sum:longint;
procedure cs;
var i,j:longint;
begin
     textbackground(blue);
     clrscr;
     gotoxy((80-n*2) div 2,5);
     for i:=1 to n do
       begin
         for j:=1 to n do
           begin
             if odd(j+i)
                then textbackground(black)
                else textbackground(white);
             write('  ');
           end;
         gotoxy((80-n*2) div 2,i+5);
       end;
end;
procedure p(x:longint);
var i,j:longint;
    f:boolean;
    c,h:char;
begin
     if x=n+1
        then
           begin
               inc(sum);
               textbackground(blue);
               textcolor(yellow);
               gotoxy((80-n*2) div 2-3,5);
               write(sum);
               textcolor(green);
               for i:=1 to n do
                 begin
                   if odd(i+a[i])
                      then textbackground(black)
                      else textbackground(white);
                   gotoxy((80-n*2) div 2+(a[i]-1)*2,4+i);
                   write('()');
                 end;
               textcolor(red);
               textbackground(blue);
               gotoxy((80-n*2) div 2,5+n);
               write('Press any key');
               h:=readkey;
               if h=#0 then c:=readkey;
               for i:=1 to n do
                 begin
                   if odd(i+a[i])
                      then textbackground(black)
                      else textbackground(white);
                   gotoxy((80-n*2) div 2+(a[i]-1)*2,4+i);
                   write('  ');
                 end;
           end
        else
           for i:=1 to n do
               begin
                  f:=true;
                  for j:=1 to x-1 do
                     if ((a[j]+j)=(x+i))or((a[j]-j)=(i-x))or(i=a[j])
                        then begin f:=false;break;end;
                  if f then
                    begin
                      a[x]:=i;
                      p(x+1);
                    end;
               end;
end;
begin
     textbackground(blue);
     clrscr;
     write('Shu ru huang hou shu: ');
     read(n);cs;
     sum:=0;p(1);
end.
