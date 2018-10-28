uses windows,fftw_s;
const lg=17;jz=10000;
      dmaxlen=1<<lg;
      maxlen=dmaxlen>>1;
      fftwlib='libfftw3l';
type float=record
             sgn,int:longint;
             f:array[1..maxlen]of int64;
           end;
     complex_double=record
                      re,im:double;
                    end;
     pdouble=^double;
     pcomplex_double=^complex_double;
     fftw_plan_double=type pointer;
     fftw_flag=(fftw_measure,            {generated optimized algorithm}
                fftw_destroy_input,      {default}
                fftw_unaligned,          {data is unaligned}
                fftw_conserve_memory,    {needs no explanation}
                fftw_exhaustive,         {search optimal algorithm}
                fftw_preserve_input,     {don't overwrite input}
                fftw_patient,            {generate highly optimized alg.}
                fftw_estimate);          {don't optimize, just use an alg.}
     fftw_flagset=set of fftw_flag;
var a,b,t,tmp:float;c1,c2,c3:pcomplex_double;r1,r2,r3:pdouble;
    p,i,l:longint;t1,t2:dword;
function plan_dft_1d(n:cardinal;i:Pdouble;o:Pcomplex_double;
                          flags:fftw_flagset):fftw_plan_double;
         cdecl;external fftwlib name 'fftwl_plan_dft_r2c_1d';
function plan_dft_1d(n:cardinal;i:Pcomplex_double;o:Pdouble;
                          flags:fftw_flagset):fftw_plan_double;
         cdecl;external fftwlib name 'fftwl_plan_dft_c2r_1d';
procedure execute(plan:fftw_plan_double);
          cdecl;external fftwlib name 'fftwl_execute';
procedure destroy_plan(plan:fftw_plan_double);
          cdecl;external fftwlib name 'fftwl_destroy_plan';
procedure FtoC(a:float;d:longint;var b:pdouble;var len:longint);
var i:longint;t:extended;
begin
        len:=0;
        while a.int>0 do
          begin
            b[len]:=a.int mod jz;
            a.int:=a.int div jz;
            inc(len);
          end;
        dec(len);
        if len>=0 then for i:=0 to len>>1 do
          begin
            t:=b[len-i];
            b[len-i]:=b[i];
            b[i]:=t
          end;
        for i:=1 to d do
          if i+len<maxlen then b[i+len]:=a.f[i];
        inc(len,d+1);
        for i:=len to dmaxlen-1 do b[i]:=0;
end;
procedure CtoF(a:pdouble;len,s,d:longint;var b:float);
var i:longint;
begin
    if d>maxlen then begin len:=len-d+maxlen;d:=maxlen;end;
    if len>maxlen then begin d:=d-len+maxlen;len:=maxlen;end;
    fillchar(b,sizeof(b),0);
    with b do
      begin
        for i:=1 to len-d do
           int:=int*jz+round(a[i-1]);
        if len>=d
          then
            for i:=len+1-d to len do
              f[i-len+d]:=round(a[i-1])
          else
            for i:=d-len+1 to d do
              f[i]:=round(a[i-d+len-1]);
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
operator -(a:float;b:longint)c:float;
begin
   c:=a;
   dec(c.int,b)
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

operator >(a,b:float)c:boolean;  //a.sgn=1,b.sgn=1
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
    s:=(not s) and 1;
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
operator *(a,b:float)c:float;
var la,lb,i,len1,len2,len:longint;tmp:qword;p:fftw_plan_double;
begin
   la:=l;lb:=l;
   while (la>0)and(a.f[la]=0) do dec(la);
   while (lb>0)and(b.f[lb]=0) do dec(lb);
   ftoc(a,la,r1,len1);
   ftoc(b,lb,r2,len2);
   if len1>maxlen then
      begin
        la:=la-len1+maxlen;
        for i:=maxlen to len1-1 do r1[i]:=0;
        len1:=maxlen;
      end;
   if len2>maxlen then
      begin
        lb:=lb-len2+maxlen;
        for i:=maxlen to len2-1 do r2[i]:=0;
        len2:=maxlen;
      end;
   len:=1<<(trunc(ln(len1+len2)/ln(2))+1);
   if len>dmaxlen then len:=dmaxlen;
   p:=plan_dft_1d(len,r1,c1,[fftw_estimate]);
   execute(p);
   p:=plan_dft_1d(len,r2,c2,[fftw_estimate]);
   execute(p);
   destroy_plan(p);
   for i:=0 to len-1 do
      begin
        c3[i].re:=c1[i].re*c2[i].re-c1[i].im*c2[i].im;
        c3[i].im:=c1[i].re*c2[i].im+c2[i].re*c1[i].im;
      end;
   p:=plan_dft_1d(len,c3,r3,[fftw_estimate]);
   execute(p);
   for i:=0 to len-1 do r3[i]:=r3[i]/len;
   len:=len1+len2-1;
   for i:=len-1 downto 1 do
      if r3[i]+1e-6>=jz then
         begin
            tmp:=trunc(r3[i]/jz+1e-6);
            r3[i-1]:=r3[i-1]+tmp;
            r3[i]:=r3[i]-tmp*jz;
         end;
   if r3[0]+1e-6>=jz then
      begin
         for i:=len-1 downto 0 do
           r3[i+1]:=r3[i];
         r3[0]:=trunc(r3[1]/jz+1e-6);
         r3[1]:=r3[1]-r3[0]*jz;
         inc(len);
      end;
   ctof(r3,len,a.sgn*b.sgn,la+lb,c);
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
   assign(output,'d:\pi.txt');
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
var i,k:longint;
begin
  t1:=gettickcount;
  fftw_getmem(c1,dmaxlen<<3);
  fftw_getmem(c2,dmaxlen<<3);
  fftw_getmem(c3,dmaxlen<<3);
  fftw_getmem(r1,dmaxlen<<2);
  fftw_getmem(r2,dmaxlen<<2);
  fftw_getmem(r3,dmaxlen<<2);
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
