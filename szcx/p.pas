var a,b:array[1..100000]of longint;
    n,i,j,q,x,y,k:longint;
procedure sort(l,r:longint);
var i,j,x,y:longint;
begin
i:=l;j:=r;
x:=b[(l+r)>>1];
repeat
        while b[i]<x do inc(i);
        while x<b[j] do dec(j);
        if i<=j then
        begin
                y:=b[i];b[i]:=b[j];b[j]:=y;
                inc(i);dec(j);
        end;
until i>j;
if l<j then sort(l,j);
if i<r then sort(i,r);
end;
begin
read(n);
for i:=1 to n do
        read(a[i]);
read(q);
for i:=1 to q do
begin
        read(x,y,k);
        if x=0
                then inc(a[y],k)
                else begin
                        for j:=x to y do b[j-x+1]:=a[j];
                        sort(1,y-x+1);
                        writeln(b[k]);
                end;
end;
end.

