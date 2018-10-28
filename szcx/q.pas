type pt=^no;
     no=record v,s:longint;lc,rc:pt;end;
var n,q,i,x,y,k,l,r,mid,fnd,t:longint;
    a:array[1..200000]of pt;
    tmp:array[1..60000]of longint;
procedure delete(var x:pt;v:longint);
var r:pt;
begin
    if x^.v=v then begin
       if (x^.lc=nil)and(x^.rc=nil)
         then dispose(x) else
       if x^.lc=nil then x:=x^.rc else
       if x^.rc=nil then x:=x^.lc else
         begin
           r:=x^.rc;x:=x^.lc;
           while x^.rc<>nil do x:=x^.rc;
           x^.rc:=r;
         end;
       exit;
    end;
    if x^.v<v
      then delete(x^.rc,v)
      else delete(x^.lc,v)
end;
procedure insert(var x:pt;v:longint);//same value to right
begin
    if x=nil then begin new(x);x^.s:=1;x^.v:=v;x^.lc:=nil;x^.rc:=nil;end else
    if x^.v<=v
      then insert(x^.rc,v)
      else insert(x^.lc,v);
end;
function rank(x:pt;v:longint):longint;//max(num<v)
begin
    if x^.v<v
      then begin
             if x^.lc<>nil then rank:=x^.lc^.s+1 else rank:=1;
             if x^.rc<>nil then inc(rank,rank(x^.rc,v))
           end
      else begin
             if x^.v=v then fnd:=1;
             if x^.lc=nil then rank:=0 else rank:=rank(x^.lc,v)
           end
end;
procedure init(p,l,r:longint);
var mid,i:longint;
begin
    if l=r then
      begin
        new(a[p]);
        a[p]^.s:=1;
        read(a[p]^.v);
        tmp[l]:=a[p]^.v;
        a[p]^.lc:=nil;
        a[p]^.rc:=nil;
        exit;
      end;
    mid:=(l+r)>>1;
    init(p<<1,l,mid);
    init(p<<1+1,mid+1,r);
    for i:=l to r do insert(a[p],tmp[i]);
end;
procedure update(t,l,r,p,c:longint);
var mid:longint;
begin
    mid:=(r+l)>>1;
    delete(a[t],p);
    insert(a[t],p+c);
    if l<r then
      if p<=mid
        then update(t<<1,l,mid,p,c)
        else update(t<<1+1,mid+1,r,p,c);
end;
function getr(t,tl,tr,l,r,x:longint):longint;
var mid:longint;
begin
    if (l<=tl)and(tr<=r)then exit(rank(a[t],x));
    mid:=(tl+tr)>>1;getr:=0;
    if l<=mid then inc(getr,getr(t<<1,tl,mid,l,r,x));
    if r>mid then inc(getr,getr(t<<1+1,mid+1,tr,l,r,x));
end;
begin
    read(n);
    init(1,1,n);
    read(q);
    for i:=1 to q do
      begin
         read(x,y,k);
         if x=0
           then update(1,1,n,y,k) else begin
         l:=1;r:=n+1;dec(k);
         while l<=r do
           begin
             mid:=(l+r)>>1;
             fnd:=0;
             t:=getr(1,1,n,x,y,mid);
             if (t=k)and(fnd=1)
               then begin writeln(mid);break;end;
             if t<k
               then l:=mid+1
               else r:=mid-1;
           end
      end;end
end.