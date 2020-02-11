var n,cnt:longint;
	a,b,c:longint;
procedure dfs(d:longint);
var i:longint;
begin
	if d>n then begin
		inc(cnt);
		exit();
	end;
	for i:=1 to n do
		if (((a>>i) and 1) or ((b>>(i+d)) and 1) or ((c>>(i+n-d)) and 1))=0 then begin
			a:=a or (1<<i);b:=b or (1<<(i+d));c:=c or (1<<(i+n-d));
			dfs(d+1);
			a:=a xor (1<<i);b:=b xor (1<<(i+d));c:=c xor (1<<(i+n-d));
		end
end;
begin
	read(n);
	dfs(1);
	writeln(cnt)
end.
