uses windows;
const mul:array[1..6]of extended=(9/8,10/9,16/15,9/8,10/9,9/8);
      jd:array[0..2]of longint=(132,264,528);
      k=2000;
var i,j,n,o,p:longint;c:char;x:extended;
    ds:array[0..2,1..7]of longint;
    d:array[1..100000,1..4]of longint;
procedure play(i,e:longint);
var t:longint;
begin
  if i>e then exit;
  if d[i,1]=123 then
    for t:=1 to d[i,4] do play(d[i,2],d[i,3]) else
  if d[i,2]=0
    then sleep(d[i,3])
    else beep(ds[d[i,1],d[i,2]],d[i,3]);
  play(i+1,e);
end;
begin
   for i:=0 to 2 do
     begin
       ds[i,1]:=jd[i];
       for j:=2 to 7 do
         ds[i,j]:=round(ds[i,j-1]*mul[j-1]);
     end;
   n:=1;
   while 1=1 do
     begin
       if n>100000 then begin writeln('TOO MANY LINES');exit;end;
       write(n:3,' : ');
       read(c);
       if not(c in['0'..'2','e','E','R','r','C','c'])
         then begin writeln('WRONG COMMAND');readln;continue;end;
       case c of
          'E','e':break;
          'R','r':begin
                     d[n,1]:=123;
                     readln(d[n,2],d[n,3],d[n,4]);
                     if (d[n,2]>=n)or(d[n,2]<1)or(d[n,3]>=n)or(d[n,3]<1)or(d[n,2]>d[n,3]) then
                        begin writeln('WRONG LINE NUMBER');continue;end;
                     if d[n,4]<1 then
                        begin writeln('TOO FEW LOOP TIMES');continue;end;
                     inc(n)
                  end;
          '0'..'2':begin
                     d[n,1]:=ord(c)-48;
                     readln(d[n,2],x);
                     if (x<0)or not(d[n,2] in [0..7]) then
                        begin writeln('WRONG ARGUMENTS');continue;end;
                     if (frac(x)>0.005)
                        then d[n,3]:=round(x*k)
                        else d[n,3]:=k>>round(x);
                     inc(n)
                   end;
          'C','c':begin
                     readln(i,o,p,x);
                     if (i>=n)or(i<1) then
                        begin writeln('WRONG LINE NUMBER');continue;end;
                     if not(o in[0..2])or not(p in[0..7])or(x<0) then
                        begin writeln('WRONG ARGUMENTS');continue;end;
                     d[i,1]:=o;d[i,2]:=p;
                     if (frac(x)>0.005)
                        then d[i,3]:=round(x*k)
                        else d[i,3]:=k>>round(x);
                  end;
       end;
     end;
   play(1,n-1);
end.
