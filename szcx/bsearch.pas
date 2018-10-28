type plong=^longint;fun=function(a,b:plong):longint;cdecl;
function bsearch(key,a:plong;n,size:longint;cmp:fun):longint;
         cdecl;external'msvcrt';
function cmp(a,b:plong):longint;cdecl;
begin
   exit(a^-b^);
end;
var a:array[0..100000]of longint;n,i,v:longint;
begin
   read(n);
   for i:=0 to n-1 do read(a[i]);
   read(v);
   writeln((bsearch(@v,@a,n,4,@cmp)-longint(@a))>>2+1);
end.