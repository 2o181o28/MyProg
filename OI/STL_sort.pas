uses windows,gutil,garrayutils,gvector;
type tcmp=specialize tless<longint>;
     queue=specialize tvector<longint>;
     tsort=specialize torderingarrayutils<queue,longint,tcmp>;
var a:queue;
    n,i,x:longint;
    stime:dword;
begin
    randomize;
    a:=queue.create;
    n:=10000000;
    for i:=1 to n do a.pushback(random(2147483648));
    stime:=gettickcount;
    tsort.sort(a,n);
    writeln(gettickcount-stime)
end.
