uses math,gmap,gutil;
const maxl=15;maxw=5000000;
type wd=string[maxl*2];
    less=specialize TLess<wd>;
    map=specialize TMap<wd,longint,less>;
    rmap=specialize TMap<wd,real,less>;
var s:ansistring;fl:string;ch:char;
    i,l,len,totwd:longint;
    a,posi,rposi,sa,w,c,wps:array[1..maxw]of longint;
    ps:map;nhd:rmap;
    zy:array[1..2]of rmap;
    wds:array[1..maxw]of wd;
procedure swap(var a,b:longint);var t:longint;begin t:=a;a:=b;b:=t;end;
function towd(l,r:longint):wd;inline;
begin if posi[l]>rposi[r] then swap(l,r);towd:=copy(s,posi[l],rposi[r]-posi[l]+1);end;
procedure getp();
var i,j,v:longint;
    str:wd;
begin
    ps:=map.Create;
    for i:=1 to maxl do
        for j:=1 to l-i+1 do begin
            str:=towd(j,j+i-1);
            if not ps.TryGetValue(str,v)
                then ps[str]:=1
                else ps[str]:=v+1;
        end;
end;
procedure getn();
var i,len:longint;
    it:map.TIterator;
    p1,p2,nh:real;
begin
    nhd:=rmap.Create;
    it:=ps.min;
    repeat
        p1:=it.value/l;nh:=1e100;
        i:=1;len:=length(it.key);
        if len=1 then continue;
        while i<=len do begin
            if i>1 then begin
                p2:=(ps[copy(it.key,1,i-1)]/l)*(ps[copy(it.key,i,len-i+1)]/l);
                if p1/p2<nh then nh:=p1/p2;
            end;
            if ord(it.key[i])>127 then inc(i,2) else inc(i);
        end;
        nhd[it.key]:=nh;
    until not it.next;
end;
function cmp(p1,p2:longint):longint;
begin
    while (a[p1]=a[p2])and(p1<l)and(p2<l) do begin inc(p1);inc(p2);end;
    cmp:=a[p1]-a[p2];
end;
procedure sort(l,r:longint);
var i,j,x,y:longint;
begin
    i:=l;j:=r;
    x:=sa[(l+r)>>1];
    repeat
        while cmp(sa[i],x)<0 do inc(i);
        while cmp(x,sa[j])<0 do dec(j);
        if i<=j then begin
            y:=sa[i];sa[i]:=sa[j];sa[j]:=y;
            inc(i);dec(j);
        end;
    until i>j;
    if l<j then sort(l,j);
    if i<r then sort(i,r);
end;
procedure getzy(tp:longint);
var i,j,k,f,le,cnt:longint;
    tzy:real;
begin
    zy[tp]:=rmap.Create;
    for i:=1 to l do sa[i]:=i;
    sort(1,l);
    for j:=2 to maxl do begin
        le:=0;cnt:=0;
        for i:=1 to l do begin
            f:=1;
            if i<>l then for k:=0 to j-1 do
                if (sa[i]+k>l)or(sa[i+1]+k>l)or(a[sa[i]+k]<>a[sa[i+1]+k])
                    then begin f:=0;break;end;
            if sa[i]+j<=l then begin
                inc(cnt);
                if (le>0)and(w[le]=a[sa[i]+j]) then inc(c[le]) else begin
                    inc(le);
                    w[le]:=a[sa[i]+j];
                    c[le]:=1;
                end;
            end else if sa[i]+j>l+1 then continue;
            if (f=0)or(i=l) then begin
                tzy:=0;
                for k:=1 to le do tzy:=tzy-ln(c[k]/cnt)*(c[k]/cnt);
                zy[tp][towd(sa[i],sa[i]+j-1)]:=tzy;
                le:=0;cnt:=0;
            end;
        end;
    end;
end;
procedure gettzy();
var it:rmap.TIterator;
begin
    it:=zy[1].min;
    repeat
        zy[1][it.key]:=min(zy[1][it.key],zy[2][it.key]);
        //if (zy[1][it.key]>1) then
        //    writeln(it.key:12,ps[it.key]:6,nhd[it.key]:10:4,zy[1][it.key]:10:4);
        if (zy[1][it.key]>1)and(nhd[it.key]>l/200) then
            begin inc(totwd);wds[totwd]:=it.key;wps[totwd]:=ps[it.key];end;
    until not it.next;
end;
procedure sort1(l,r:longint);
var i,j,x,y:longint;t:wd;
begin
    i:=l;j:=r;
    x:=wps[(l+r)>>1];
    repeat
        while wps[i]>x do inc(i);
        while x>wps[j] do dec(j);
        if i<=j then begin
            y:=wps[i];wps[i]:=wps[j];wps[j]:=y;
            t:=wds[i];wds[i]:=wds[j];wds[j]:=t;
            inc(i);dec(j);
        end;
    until i>j;
    if l<j then sort1(l,j);
    if i<r then sort1(i,r);
end;
begin
    readln(fl);
    assign(input,fl);reset(input);
    while not eof do begin read(ch);s:=s+ch;end;
    i:=1;l:=0;len:=length(s);
    while i<=len do begin
        inc(l);posi[l]:=i;
        if ord(s[i])>127
            then begin a[l]:=ord(s[i])<<8+ord(s[i+1]);rposi[l]:=i+1;inc(i,2);end
            else begin a[l]:=ord(s[i]);rposi[l]:=i;inc(i);end;
    end;
    getp();
    getn();
    getzy(1);
    for i:=1 to l>>1 do begin
        swap(a[i],a[l+1-i]);
        swap(posi[i],posi[l+1-i]);
        swap(rposi[i],rposi[l+1-i])
    end;
    getzy(2);
    gettzy();
    close(input);
    sort1(1,totwd);
    for i:=1 to totwd do writeln(wds[i]:10,' ',wps[i]);
    writeln;
    while 1=1 do
end.
