const n=194;
var i,j,maxl:longint;h,now,max,nextcnt:array[1..n]of longint;
   a:array[1..n]of string;
   next:array[1..n,1..n]of longint;
procedure dfs(d,p:longint);
var i,x:longint;
begin
   if nextcnt[p]=0 then begin
     if d>maxl+1 then begin
        maxl:=d-1;
        for i:=1 to d-1 do max[i]:=now[i];
        writeln('Length=',maxl);
        for i:=1 to maxl-1 do
           write(a[max[i]],'-');
        writeln(a[max[maxl]]);writeln;
     end;
     exit;
   end;
   for i:=1 to nextcnt[p] do if h[next[p,i]]=0 then begin
        x:=next[p,i];
        h[x]:=1;
        now[d]:=x;
        dfs(d+1,x);
        h[x]:=0;
     end;
end;
begin
   assign(input,'klist.txt');
   reset(input);
   //assign(output,'2.txt');
   //rewrite(output);
   for i:=1 to n do readln(a[i]);
   for i:=1 to n do begin
      nextcnt[i]:=0;
      for j:=1 to n do if (a[i,length(a[i])]=a[j,1])and(i<>j)then begin
         inc(nextcnt[i]);
         next[i,nextcnt[i]]:=j;
      end;
   end;
   for i:=1 to n do begin
      h[i]:=1;
      now[1]:=i;
      writeln(a[i]);
      dfs(2,i);
      h[i]:=0;
   end;
   close(input);
   close(output);
end.
