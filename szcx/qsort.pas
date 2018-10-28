uses windows;
const maxn=10000000;
type plong=^longint;
     f=function(const a,b:plong):longint;cdecl;
var a:array[0..maxn+10]of longint;
    n,i:longint;stime:dword;
procedure qsort(a:pointer;n,size:size_t;cmp:f);cdecl;external'msvcrt';
function cmp(const a,b:plong):longint;cdecl;
begin
exit(a^-b^);
end;
begin
n:=maxn;
for i:=0 to n-1 do a[i]:=random(2147483648);
stime:=gettickcount;
qsort(@a,n,sizeof(longint),@cmp);
writeln(gettickcount-stime);
end.
