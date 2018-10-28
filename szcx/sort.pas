var a:array[1..1000000]of longint;
    f,i,n:longint;
procedure sort(l,r: longint);
      var
         i,j,x,y: longint;
      begin
         i:=l;
         j:=r;
         x:=a[(l+r) div 2];
         repeat
           while a[i]<x do
            inc(i);
           while x<a[j] do
            dec(j);
           if not(i>j) then
             begin
                y:=a[i];
                a[i]:=a[j];
                a[j]:=y;
                inc(i);
                j:=j-1;
             end;
         until i>j;
         if l<j then
           sort(l,j);
         if i<r then
           sort(i,r);
      end;
begin
  a[1]:=1;a[2]:=3;a[3]:=2;
  f:=2;read(n);
  for i:=4 to n do
    begin
      a[i]:=a[f];
      a[f]:=i;
      if i and 1=0 then inc(f)
    end;
  writeln('Start sorting.');
  sort(1,n);
end.