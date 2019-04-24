var n,cnt:longint;
	a,b,c:array[1..30]of longint;
procedure dfs(d:longint);
var i:longint;
begin
	if d>n then begin
		inc(cnt);
		exit();
	end;
	for i:=1 to n do
		if(a[i]=0) and (b[i+d]=0) and (c[i+n-d]=0) then begin
			a[i]:=1;b[i+d]:=1;c[i+n-d]:=1;
			dfs(d+1);
			a[i]:=0;b[i+d]:=0;c[i+n-d]:=0;
		end
end;
begin
	read(n);
	dfs(1);
	writeln(cnt)
end.
