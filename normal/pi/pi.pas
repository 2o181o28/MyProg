{$inline on}
{$R-,S-,Q-,I-}
uses windows;
const lg=17;jz=10000;
      dmaxlen=1<<lg;
      maxlen=dmaxlen>>1;
type extended=double;
type float=record
             sgn,int:longint;
             f:array[1..maxlen]of int64;
           end;
     cmp=record x,y:extended;end;
     cmparr=array[0..dmaxlen-1]of cmp;
var a,b,t,tmp:float;
    p,i,l:longint;t1,t2:dword;
    w:array[1..lg]of cmparr;
    rev:array[1..lg,0..dmaxlen-1]of longint;
    f:array[0..dmaxlen-1]of longint;
procedure FtoC(a:float;d:longint;var b:cmparr;var len:longint);
var i:longint;t:extended;
begin
        len:=0;
        while a.int>0 do
          begin
            b[len].x:=a.int mod jz;
            b[len].y:=0;
            a.int:=a.int div jz;
            inc(len);
          end;
        dec(len);
        if len>=0 then for i:=0 to len>>1 do
          begin
            t:=b[len-i].x;
            b[len-i].x:=b[i].x;
            b[i].x:=t
          end;
        for i:=1 to d do
          if i+len<maxlen then begin
            b[i+len].x:=a.f[i];
            b[i+len].y:=0;
          end;
        inc(len,d+1);
        for i:=len to dmaxlen-1 do
          begin b[i].x:=0;b[i].y:=0;end;
end;
procedure CtoF(a:cmparr;len,s,d:longint;var b:float);
var i:longint;
begin
    if d>maxlen then begin len:=len-d+maxlen;d:=maxlen;end;
    if len>maxlen then begin d:=d-len+maxlen;len:=maxlen;end;
    fillchar(b,sizeof(b),0);
    with b do
      begin
        for i:=1 to len-d do
           int:=int*jz+round(a[i-1].x);
        if len>=d
          then
            for i:=len+1-d to len do
              f[i-len+d]:=round(a[i-1].x)
          else
            for i:=d-len+1 to d do
              f[i]:=round(a[i-d+len-1].x);
        sgn:=s
      end;
end;

operator -(a,b:float)c:float;forward;
operator +(a,b:float)c:float;
var i,s:longint;
begin
if (a.sgn=-1)and(b.sgn=1)
   then begin a.sgn:=1;exit(b-a);end;
if (a.sgn=1)and(b.sgn=-1)
   then begin b.sgn:=1;exit(a-b);end;
if (a.sgn=-1)and(b.sgn=-1)
   then begin a.sgn:=1;b.sgn:=1;s:=1;end
   else s:=0;
fillchar(c,sizeof(c),0);
with c do
  begin
    int:=a.int+b.int;
    for i:=1 to l do
      f[i]:=a.f[i]+b.f[i];
    for i:=l downto 2 do
      if f[i]>=jz then
        begin inc(f[i-1]);dec(f[i],jz)end;
    if f[1]>=jz then
      begin inc(int);dec(f[1],jz)end;
    if s=1
       then sgn:=-1
       else sgn:=1;
  end
end;
operator -(a:longint;b:float)c:float;//b.sgn=1
var i:longint;
begin
   if a>b.int
     then with c do
       begin
         int:=a-b.int-1;sgn:=1;
         for i:=1 to maxlen-1 do
           f[i]:=jz-1-b.f[i];
         f[maxlen]:=jz-b.f[maxlen]
       end
     else with c do
       begin
         sgn:=-1;int:=a-b.int;
         for i:=1 to maxlen do
           f[i]:=b.f[i];
       end
end;

operator >(var a,b:float)c:boolean;  //a.sgn=1,b.sgn=1
var i:longint;
begin
    if a.int>b.int then exit(true);
    if a.int<b.int then exit(false);
    for i:=1 to l do
      begin
        if a.f[i]<b.f[i] then exit(false);
        if a.f[i]>b.f[i] then exit(true)
      end
end;
operator -(a,b:float)c:float;
var i,s:longint;
begin
if (a.sgn=-1)and(b.sgn=1)
   then begin b.sgn:=-1;exit(a+b);end;
if (a.sgn=1)and(b.sgn=-1)
   then begin b.sgn:=1;exit(a+b);end;
if (a.sgn=-1)and(b.sgn=-1)
   then
     begin
       a.sgn:=1;b.sgn:=1;
       c:=a;a:=b;b:=c;
       s:=1;
     end
   else s:=0;
if b>a then
  begin
    c:=a;a:=b;b:=c;
    s:=s xor 1;
  end;
fillchar(c,sizeof(c),0);
with c do
  begin
    int:=a.int-b.int;
    for i:=1 to l do
      f[i]:=a.f[i]-b.f[i];
    for i:=l downto 2 do
      if f[i]<0 then
        begin dec(f[i-1]);inc(f[i],jz)end;
    if f[1]<0 then
      begin dec(int);inc(f[1],jz)end;
    int:=abs(int);
    if s=1 then sgn:=-1 else sgn:=1;
  end
end;
operator *(a:longint;b:float)c:float;//a>0
var i:longint;
begin
with b do
  begin
    for i:=1 to l do
      f[i]:=f[i]*a;
    int:=int*a;
    for i:=l downto 2 do
      if f[i]>=jz then
        begin f[i-1]:=f[i-1]+f[i]div jz;f[i]:=f[i]mod jz end;
    if f[1]>=jz then begin inc(int,f[1]div jz);f[1]:=f[1]mod jz end
  end;
exit(b)
end;

operator +(a,b:cmp)c:cmp;inline;
begin
  c.x:=a.x+b.x;
  c.y:=a.y+b.y;
end;
operator -(a,b:cmp)c:cmp;inline;
begin
  c.x:=a.x-b.x;
  c.y:=a.y-b.y;
end;
operator *(a,b:cmp)c:cmp;inline;
begin
  c.x:=a.x*b.x-a.y*b.y;
  c.y:=a.x*b.y+a.y*b.x;
end;
operator /(a:cmp;b:longint)c:cmp;inline;
begin
  c.x:=a.x/b;
  c.y:=a.y/b
end;
procedure fft(var a:cmparr;lg:longint);
var h:array[0..dmaxlen-1]of longint;
    tmp:cmp;t,i,j,x,len:longint;
begin
    fillchar(h,sizeof(h),0);
    len:=1<<lg;
    for i:=0 to len-1 do
      if h[i]=0 then
        begin
          x:=rev[lg,i];
          tmp:=a[i];a[i]:=a[x];a[x]:=tmp;
          h[x]:=1;
        end;
    t:=1;
    for i:=1 to lg do
      begin
        fillchar(h,sizeof(h),0);
        for j:=0 to len-1 do
          if h[j]=0 then
            begin
              x:=t xor j;
              a[x]:=a[x]*w[lg,(x and (1<<(i-1)-1))<<(lg-i)];
              tmp:=a[j]+a[x];
              a[x]:=a[j]-a[x];
              a[j]:=tmp;h[x]:=1;
            end;
        t:=t<<1;
      end;
end;
var c1,c2,c3:cmparr;
operator *(a,b:float)c:float;
var la,lb,i,len1,len2,len:longint;tmp:qword;
begin
   la:=l;lb:=l;
   while (la>0)and(a.f[la]=0)do dec(la);
   while (lb>0)and(b.f[lb]=0)do dec(lb);
   ftoc(a,la,c1,len1);
   ftoc(b,lb,c2,len2);
   if len1>maxlen then
      begin
        la:=la-len1+maxlen;
        for i:=maxlen to len1-1 do begin c1[i].x:=0;c1[i].y:=0;end;
        len1:=maxlen;
      end;
   if len2>maxlen then
      begin
        lb:=lb-len2+maxlen;
        for i:=maxlen to len2-1 do begin c2[i].x:=0;c2[i].y:=0;end;
        len2:=maxlen;
      end;
   len:=trunc(ln(len1+len2)/ln(2))+1;
   if len>lg then len:=lg;
   fft(c1,len);fft(c2,len);
   for i:=0 to 1<<len-1 do
      begin
        c3[i]:=c1[i]*c2[i];
        c3[i].y:=-c3[i].y;
      end;
   fft(c3,len);len:=1<<len;
   for i:=0 to len-1 do c3[i]:=c3[i]/len;
   len:=len1+len2-1;
   for i:=len-1 downto 1 do
      if c3[i].x+1e-6>=jz then
         begin
            tmp:=trunc(c3[i].x/jz+1e-6);
            c3[i-1].x:=c3[i-1].x+tmp;
            c3[i].x:=c3[i].x-tmp*jz;
         end;
   if c3[0].x+1e-6>=jz then
      begin
         for i:=len-1 downto 0 do
           c3[i+1].x:=c3[i].x;
         c3[0].x:=trunc(c3[1].x/jz+1e-6);
         c3[1].x:=c3[1].x-c3[0].x*jz;
         inc(len);
      end;
   ctof(c3,len,a.sgn*b.sgn,la+lb,c);
end;
operator /(a:float;b:longint)c:float;//b in [2..jz-1]
var i,t,x:longint;
begin
fillchar(c,sizeof(c),0);
with c do
  begin
    int:=a.int div b;
    sgn:=a.sgn;
    t:=a.int mod b;
    x:=t*jz+a.f[1];
    f[1]:=x div b;
    t:=x mod b;
    for i:=2 to maxlen do
      begin
        x:=t*jz+a.f[i];
        f[i]:=x div b;
        t:=x mod b;
      end;
    if t>b>>1 then inc(f[maxlen])
  end
end;
procedure ds(a:float;var x:float);//a.sgn=1
var t:extended;
    i:longint;
begin
    t:=1/(a.int+a.f[1]/jz+a.f[2]/(jz*jz));
    x.int:=trunc(t);
    x.sgn:=1;t:=frac(t);
    for i:=1 to 4 do
      begin
        t:=t*jz;
        x.f[i]:=trunc(t);
        t:=frac(t)
      end;
    fillchar(x.f[5],(maxlen-4)*8,0);
    l:=2;
    for i:=1 to lg-1 do
      begin
        x:=x*(2-a*x);
        l:=l<<1;
      end;
    l:=maxlen;
    x:=x*(2-a*x)
end;
operator /(a,b:float)c:float;//b.sgn=1
begin
    ds(b,c);
    exit(c*a);
end;
procedure fsqrt(a:float;var x:float);//a.sgn=1
var t:extended;
    i:longint;
begin
    t:=1/sqrt(a.int+a.f[1]/jz+a.f[2]/(jz*jz));
    x.int:=trunc(t);
    x.sgn:=1;t:=frac(t);
    for i:=1 to 4 do
      begin
        t:=t*jz;
        x.f[i]:=trunc(t);
        t:=frac(t)
      end;
    fillchar(x.f[5],(maxlen-4)*8,0);
    l:=2;
    for i:=1 to lg-1 do
      begin
        x:=x+x*(1-a*x*x)/2;
        l:=l<<1;
      end;
    l:=maxlen;
    x:=x+x*(1-a*x*x)/2;
    ds(x,x);
end;

procedure print(a:float);
var i:longint;s:string;
begin
   assign(output,'pi.txt');
   rewrite(output);
   write(a.int,'.');
   for i:=1 to maxlen-2 do
     begin
       str(a.f[i],s);
       while length(s)<4 do s:='0'+s;
       write(s);
     end;
   str(a.f[maxlen-1],s);
   delete(s,length(s)-1,2);
   writeln(s);
   close(output)
end;
procedure init;
var i,k,x:longint;
begin
  t1:=gettickcount;
  x:=2;
  for k:=1 to lg do
    begin
      for i:=0 to x-1 do
        begin
          w[k,i].x:=cos(-2*pi*i/x);
          w[k,i].y:=sin(-2*pi*i/x);
        end;
      x:=x<<1;
    end;
  for i:=0 to dmaxlen-1 do
    begin f[i]:=i>>1;rev[1,i]:=i and 1;end;
  for k:=2 to lg do
    for i:=0 to dmaxlen-1 do
      begin
          rev[k,i]:=(rev[k-1,i]<<1) or (f[i] and 1);
          f[i]:=f[i]>>1;
      end;
  a.int:=1;a.sgn:=1;l:=2;
  with b do begin sgn:=1;f[1]:=7100;end;
  for i:=1 to lg-1 do
    begin
      b:=b-b*b*b+b/2;
      l:=l<<1;
    end;
  l:=maxlen;
  b:=b-b*b*b+b/2;
  with t do
   begin sgn:=1;f[1]:=2500;end;
  p:=1;
end;
begin
  init;
  for i:=1 to lg do
    begin
      tmp:=a;
      a:=(a+b)/2;
      fsqrt(tmp*b,b);
      t:=t-p*(tmp-a)*(tmp-a);
      p:=p<<1;
      writeln(i/lg*100:0:2,'%');
    end;
  t2:=gettickcount;
  writeln;
  writeln('time : ',(t2-t1)/1000:0:2,'s');
  print((a+b)*(a+b)/(4*t))
end.
