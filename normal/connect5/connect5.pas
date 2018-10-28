{$INLINE ON}
uses math,windows;
const n=15;
      maxv:array[1..14]of longint=(20,8,7,7,7,6,6,6,6,5,5,5,5,5);
      lian=3;jian=2;t=1;
      sh=2;chong=1;huo=3;
      inf=1000000;
      smod=100000007;lmod=1000000000000000003;
type arr=array[-1..n+2,-1..n+2]of longint;
     htype=record sh:longint;lh:qword;end;
var x,y,i,j,i1,j1,m1,br:longint;
    c,d:char;
    max,bi,bj:array[0..20]of longint;
    a,b,sx:arr;s:string;tot,stime,node:dword;
    zhb:array[0..smod-1]of record key:qword;val,dep:longint;end;
    maxnode:dword=600000;code:integer;
function i5(var a:arr;x:longint):boolean;
var i,j:longint;
begin
    for i:=1 to n-4 do
      for j:=1 to n do
        if (a[i,j]=x)and(a[i+1,j]=x)and(a[i+2,j]=x)and(a[i+3,j]=x)and(a[i+4,j]=x)
         or(a[j,i]=x)and(a[j,i+1]=x)and(a[j,i+2]=x)and(a[j,i+3]=x)and(a[j,i+4]=x)
           then exit(true);
    for i:=1 to n-4 do
      for j:=1 to n-4 do
        if (a[i,j]=x)and(a[i+1,j+1]=x)and(a[i+2,j+2]=x)and(a[i+3,j+3]=x)and(a[i+4,j+4]=x)
           then exit(true);
    for i:=5 to n do
      for j:=1 to n-4 do
        if (a[i,j]=x)and(a[i-1,j+1]=x)and(a[i-2,j+2]=x)and(a[i-3,j+3]=x)and(a[i-4,j+4]=x)
           then exit(true);
    exit(false);
end;
function i4l(var a,b,c,d,e,f,x:longint):longint;inline;
begin
    if(a<>x)and(e<>x)then exit(0);
    if(a=x)and(b=x)and(c=-1)and(d=x)and(e=x)and(f<>x)or
      (a=x)and(b=-1)and(c=x)and(d=x)and(e=x)and(f<>x)or
      (a=x)and(b=x)and(c=x)and(d=-1)and(e=x)and(f<>x)then exit(chong);
    if(a=-1)and(b=x)and(c=x)and(d=x)and(e=x)
      then if(f=-1)then exit(huo)else if(f<>x)then exit(chong);
    if(b=x)and(c=x)and(d=x)and(e=x)and(f=-1)
      then if(a=-1)then exit(huo)else if(a<>x)then exit(chong);
    exit(0);
end;
function i3l(var a,b,c,d,e,f,g,x:longint):longint;inline;
var y:longint;
begin
   y:=1 xor x;
   if (a=x)and(b=-1)and(c=x)and(d=x)and(e=-1)and(f=x)then exit(0);
   if (a=x)and(b=-1)and(c=x)and(d=-1)and(e=x)and(f=-1)and(g=x)then exit(huo);
   if (c=x)and(d=x)and(e=x)and(f<>x)and(b<>x) then
     begin
       if (b=y)and(f=y)or(b=y)and(g=y)or(a=y)and(f=y)
          or(a=x)and(b<>y)or(g=x)and(f<>y)
          then exit(0);
       if (f=y)or(b=y)or(a=y)and(g=y) then exit(chong);
       exit(huo);
     end;
   if (b=x)and(d=x)and(e=x)and(c=-1) then
     begin
       if (a=y)and(f=y)or(a=x)or(f=x) then exit(0);
       if (a=y)or(f=y) then exit(chong);
       exit(huo);
     end;
   if (b=x)and(c=x)and(e=x)and(d=-1) then
     begin
       if (a=y)and(f=y)or(a=x)or(f=x) then exit(0);
       if (a=y)or(f=y) then exit(chong);
       exit(huo);
     end;
   if (a=x)and(c=x)and(e=x)and(b=-1)and(d=-1) then exit(chong);
   exit(0);
end;
function h2l(var a,b,c,d,e,f,g,x:longint):longint;inline;
var y:longint;
begin
    y:=1 xor x;
    if(a=-1)and(b=-1)and(c=-1)and(d=x)and(e=x)and(f=-1)and(g=y)or
      (a=-1)and(b=-1)and(c=x)and(d=x)and(e=-1)and(f=-1)or
      (a=y)and(b=-1)and(c=x)and(d=x)and(e=-1)and(f=-1)and(g=-1)
      then exit(lian);
    if(a=-1)and(b=x)and(c=-1)and(d=x)and(e=-1)and(f=-1)or
      (a=-1)and(b=-1)and(c=x)and(d=-1)and(e=x)and(f=-1)and(g=y)
      then exit(jian);
    if(a=-1)and(b=x)and(c=-1)and(d=-1)and(e=x)and(f=-1)
      then exit(t);
    h2l:=0;
end;
function tj(p:longint):longint;//now turn to player q(1-p),
                               //return the value of player p
var c3_p,c3_q,i4_p,i4_q,i4_p1,i4_p2,i4_p3,i4_p4,
    i4_q1,i4_q2,i4_q3,i4_q4,x,q,h3_p,h3_q,i,j,c:longint;
begin
    inc(tot);
    q:=1 xor p;x:=0;
    h3_p:=0;c3_p:=0;i4_p1:=0;i4_p2:=0;i4_p3:=0;i4_p4:=0;
    h3_q:=0;c3_q:=0;i4_q1:=0;i4_q2:=0;i4_q3:=0;i4_q4:=0;
    //p's value
    for i:=-1 to n+2 do
      begin
         a[i,-1]:=q;a[i,0]:=q;a[0,i]:=q;a[-1,i]:=q;
         a[i,n+1]:=q;a[i,n+2]:=q;a[n+1,i]:=q;a[n+2,i]:=q;
      end;
    for i:=1 to n do
      for j:=-1 to n-4 do
        begin
          case i3l(a[i,j],a[i,j+1],a[i,j+2],a[i,j+3],a[i,j+4],a[i,j+5],a[i,j+6],p) of
            huo:inc(h3_p);
            chong:inc(c3_p);
          end;
          case i3l(a[j,i],a[j+1,i],a[j+2,i],a[j+3,i],a[j+4,i],a[j+5,i],a[j+6,i],p) of
            huo:inc(h3_p);
            chong:inc(c3_p);
          end;
          if j=-1 then continue;

          case h2l(a[i,j],a[i,j+1],a[i,j+2],a[i,j+3],a[i,j+4],a[i,j+5],a[i,j+6],p) of
            lian:inc(x,16);
            jian:inc(x,12);
            t:inc(x,7);
          end;
          case h2l(a[j,i],a[j+1,i],a[j+2,i],a[j+3,i],a[j+4,i],a[j+5,i],a[j+6,i],p) of
            lian:inc(x,16);
            jian:inc(x,12);
            t:inc(x,7);
          end;

          case i4l(a[i,j],a[i,j+1],a[i,j+2],a[i,j+3],a[i,j+4],a[i,j+5],p)of
            chong:i4_p1:=1;
            huo:i4_p:=huo;
          end;
          if(j>2)and(a[i,j-2]=p)and(a[i,j-1]=-1)and(a[i,j]=p)and(a[i,j+1]=p)
            and(a[i,j+2]=p)and(a[i,j+3]=-1)and(a[i,j+4]=p)
            then i4_p1:=2;
          case i4l(a[j,i],a[j+1,i],a[j+2,i],a[j+3,i],a[j+4,i],a[j+5,i],p)of
            chong:i4_p2:=1;
            huo:i4_p:=huo;
          end;
          if(j>2)and(a[j-2,i]=p)and(a[j-1,i]=-1)and(a[j,i]=p)and(a[j+1,i]=p)
            and(a[j+2,i]=p)and(a[j+3,i]=-1)and(a[j+4,i]=p)
            then i4_p2:=2;
        end;
    for i:=-1 to n-4 do
      for j:=-1 to n-4 do
        begin
          case i3l(a[i,j],a[i+1,j+1],a[i+2,j+2],a[i+3,j+3],a[i+4,j+4],a[i+5,j+5],a[i+6,j+6],p) of
            huo:inc(h3_p);
            chong:inc(c3_p);
          end;
          if (i=-1)or(j=-1)then continue;

          case h2l(a[i,j],a[i+1,j+1],a[i+2,j+2],a[i+3,j+3],a[i+4,j+4],a[i+5,j+5],a[i+6,j+6],p) of
            lian:inc(x,16);
            jian:inc(x,12);
            t:inc(x,7);
          end;

          case i4l(a[i,j],a[i+1,j+1],a[i+2,j+2],a[i+3,j+3],a[i+4,j+4],a[i+5,j+5],p)of
            chong:i4_p3:=1;
            huo:i4_p:=huo;
          end;
          if(j>2)and(i>2)and(a[i-2,j-2]=p)and(a[i-1,j-1]=-1)and(a[i,j]=p)and(a[i+1,j+1]=p)
            and(a[i+2,j+2]=p)and(a[i+3,j+3]=-1)and(a[i+4,j+4]=p)
            then i4_p3:=2;
        end;
    for i:=5 to n+2 do
      for j:=-1 to n-4 do
        begin
          case i3l(a[i,j],a[i-1,j+1],a[i-2,j+2],a[i-3,j+3],a[i-4,j+4],a[i-5,j+5],a[i-6,j+6],p) of
            huo:inc(h3_p);
            chong:inc(c3_p);
          end;
          if(j=-1)or(i=n+2)then continue;

          case i4l(a[i,j],a[i-1,j+1],a[i-2,j+2],a[i-3,j+3],a[i-4,j+4],a[i-5,j+5],p)of
            chong:i4_p4:=1;
            huo:i4_p:=huo;
          end;
          if(j>2)and(i<n-1)and(a[i+2,j-2]=p)and(a[i+1,j-1]=-1)and(a[i,j]=p)and(a[i-1,j+1]=p)
            and(a[i-2,j+2]=p)and(a[i-3,j+3]=-1)and(a[i-4,j+4]=p)
            then i4_p4:=2;

          case h2l(a[i,j],a[i-1,j+1],a[i-2,j+2],a[i-3,j+3],a[i-4,j+4],a[i-5,j+5],a[i-6,j+6],p) of
            lian:inc(x,16);
            jian:inc(x,12);
            t:inc(x,7);
          end;
        end;
    if i4_p<>huo then i4_p:=i4_p1+i4_p2+i4_p3+i4_p4;

    //q's value
    for i:=2 to n-1 do
      for j:=2 to n-1 do
        begin
          c:=0;
          if a[i,j-1]>=0 then inc(c);
          if a[i,j+1]>=0 then inc(c);
          if a[i-1,j]>=0 then inc(c);
          if a[i+1,j]>=0 then inc(c);
          if a[i-1,j-1]>=0 then inc(c);
          if a[i-1,j+1]>=0 then inc(c);
          if a[i+1,j-1]>=0 then inc(c);
          if a[i+1,j+1]>=0 then inc(c);
          if (a[i,j]=q)and(c<4) then dec(x,8);
        end;
    for i:=-1 to n+2 do
      begin
         a[i,-1]:=p;a[i,0]:=p;a[0,i]:=p;a[-1,i]:=p;
         a[i,n+1]:=p;a[i,n+2]:=p;a[n+1,i]:=p;a[n+2,i]:=p;
      end;
    for i:=1 to n do
      for j:=-1 to n-4 do
        begin
          case i3l(a[i,j],a[i,j+1],a[i,j+2],a[i,j+3],a[i,j+4],a[i,j+5],a[i,j+6],q) of
            huo:inc(h3_q);
            chong:inc(c3_q);
          end;
          case i3l(a[j,i],a[j+1,i],a[j+2,i],a[j+3,i],a[j+4,i],a[j+5,i],a[j+6,i],q) of
            huo:inc(h3_q);
            chong:inc(c3_q);
          end;
          if j=-1 then continue;

          case h2l(a[i,j],a[i,j+1],a[i,j+2],a[i,j+3],a[i,j+4],a[i,j+5],a[i,j+6],q) of
            lian:dec(x,42);
            jian:dec(x,39);
            t:dec(x,36);
          end;
          case h2l(a[j,i],a[j+1,i],a[j+2,i],a[j+3,i],a[j+4,i],a[j+5,i],a[j+6,i],q) of
            lian:dec(x,42);
            jian:dec(x,39);
            t:dec(x,36);
          end;

          case i4l(a[i,j],a[i,j+1],a[i,j+2],a[i,j+3],a[i,j+4],a[i,j+5],q)of
            chong:i4_q1:=1;
            huo:i4_q:=huo;
          end;
          if(j>2)and(a[i,j-2]=q)and(a[i,j-1]=-1)and(a[i,j]=q)and(a[i,j+1]=q)
            and(a[i,j+2]=q)and(a[i,j+3]=-1)and(a[i,j+4]=q)
            then i4_q1:=2;
          case i4l(a[j,i],a[j+1,i],a[j+2,i],a[j+3,i],a[j+4,i],a[j+5,i],q)of
            chong:i4_q2:=1;
            huo:i4_q:=huo;
          end;
          if(j>2)and(a[j-2,i]=q)and(a[j-1,i]=-1)and(a[j,i]=q)and(a[j+1,i]=q)
            and(a[j+2,i]=q)and(a[j+3,i]=-1)and(a[j+4,i]=q)
            then i4_q2:=2;
        end;
    for i:=-1 to n-4 do
      for j:=-1 to n-4 do
        begin
          case i3l(a[i,j],a[i+1,j+1],a[i+2,j+2],a[i+3,j+3],a[i+4,j+4],a[i+5,j+5],a[i+6,j+6],q) of
            lian:dec(x,42);
            jian:dec(x,39);
            t:dec(x,36);
          end;
          if (i=-1)or(j=-1)then continue;

          case h2l(a[i,j],a[i+1,j+1],a[i+2,j+2],a[i+3,j+3],a[i+4,j+4],a[i+5,j+5],a[i+6,j+6],q) of
            lian:dec(x,42);
            jian:dec(x,39);
            t:dec(x,36);
          end;

          case i4l(a[i,j],a[i+1,j+1],a[i+2,j+2],a[i+3,j+3],a[i+4,j+4],a[i+5,j+5],q)of
            chong:i4_q3:=1;
            huo:i4_q:=huo;
          end;
          if(j>2)and(i>2)and(a[i-2,j-2]=q)and(a[i-1,j-1]=-1)and(a[i,j]=q)and(a[i+1,j+1]=q)
            and(a[i+2,j+2]=q)and(a[i+3,j+3]=-1)and(a[i+4,j+4]=q)
            then i4_q3:=2;
        end;
    for i:=5 to n+2 do
      for j:=-1 to n-4 do
        begin
          case i3l(a[i,j],a[i-1,j+1],a[i-2,j+2],a[i-3,j+3],a[i-4,j+4],a[i-5,j+5],a[i-6,j+6],q) of
            huo:inc(h3_q);
            chong:inc(c3_q);
          end;
          if(j=-1)or(i=n+2)then continue;

          case i4l(a[i,j],a[i-1,j+1],a[i-2,j+2],a[i-3,j+3],a[i-4,j+4],a[i-5,j+5],q)of
            chong:i4_q4:=1;
            huo:i4_q:=huo;
          end;
          if(j>2)and(i<n-1)and(a[i+2,j-2]=q)and(a[i+1,j-1]=-1)and(a[i,j]=q)and(a[i-1,j+1]=q)
            and(a[i-2,j+2]=q)and(a[i-3,j+3]=-1)and(a[i-4,j+4]=q)
            then i4_q4:=2;

          case h2l(a[i,j],a[i-1,j+1],a[i-2,j+2],a[i-3,j+3],a[i-4,j+4],a[i-5,j+5],a[i-6,j+6],q) of
            lian:dec(x,42);
            jian:dec(x,39);
            t:dec(x,36);
          end;
        end;
    if i4_q<>huo then i4_q:=i4_q1+i4_q2+i4_q3+i4_q4;

    if (i4_p=chong)or(h3_p=1) then inc(x,55);
    dec(x,c3_q*39);
    inc(x,c3_p*12);
    if i5(a,p) then exit(x+10000);
    if i4_q<>0 then exit(x-9500);
    if i4_p=huo then exit(x+9000);
    if (i4_p=chong)and(h3_p=1)or(i4_p=sh) then exit(x+8500);
    if ((h3_q=1)or(h3_q=sh))and(i4_p<>chong) then exit(x-8000);
    if h3_p=sh then exit(x+7500);
    tj:=x;
end;
function check(x,y:longint):boolean;
var i,j:longint;
begin
    if a[x,y]>=0 then exit(false);
    for i:=x-2 to x+2 do
      for j:=y-2 to y+2 do
        if (i>0)and(j>0)and(i<=n)and(j<=n)and(a[i,j]>=0)
          then exit(true);
    exit(false);
end;
function hash:htype;
var i,j:longint;sret,lret:int64;
begin
    sret:=0;lret:=0;
    for i:=1 to n do
      for j:=1 to n do
        begin
          sret:=(sret*3+a[i,j]+1)mod smod;
          lret:=(lret*3+a[i,j]+1)mod lmod;
        end;
    hash.sh:=sret;
    hash.lh:=lret;
end;
function minimax(maxd,d,p,alpha,beta:longint):longint;
var i,j,k,v,sum,tdep,u,mul:longint;tmp:array[1..4]of longint;
    s:array[1..n*n,1..4]of longint;h:htype;xorb:boolean;
    hs:array[1..n*n]of htype;
begin
    sum:=0;mul:=p<<1-1;xorb:=not boolean(p);
    for i:=1 to n do
      for j:=1 to n do
        if check(i,j) then
          begin
            inc(sum);
            a[i,j]:=p;
            h:=hash();
            if (zhb[h.sh].val<1000000)and(zhb[h.sh].key=h.lh)
            and((zhb[h.sh].dep>0)or(d=maxd))
              then s[sum,1]:=zhb[h.sh].val
              else begin
                      if d>maxd-2
                         then begin s[sum,1]:=mul*tj(p);zhb[h.sh].dep:=0;end
                         else begin
                                s[sum,1]:=minimax(d+1,d+1,p xor 1,alpha,beta);
                                zhb[h.sh].dep:=1;
                              end;
                      zhb[h.sh].val:=s[sum,1];
                      zhb[h.sh].key:=h.lh;
                   end;
            a[i,j]:=-1;
            s[sum,2]:=i;s[sum,3]:=j;s[sum,4]:=zhb[h.sh].dep;
            hs[sum]:=h;
            k:=sum;
            while (k>1) and ( //TOO HARD!!!
             (s[k-1,4]=s[k,4]) and ((s[k-1,1]<s[k,1]) xor xorb) or
             (s[k-1,4]>s[k,4]) and ((s[k-1,1]<s[k,1]-20)xor xorb) or
             (s[k-1,4]<s[k,4]) and ((s[k-1,1]<s[k,1]+20)xor xorb)) do begin
                tmp:=s[k];s[k]:=s[k-1];s[k-1]:=tmp;
                h:=hs[k];hs[k]:=hs[k-1];hs[k-1]:=h;dec(k);
            end;
          end;
    if d=1 then
       writeln('Debugging : DEP=1');
    if (s[1,1]<-5000)and(p=0)or(s[1,1]>5000)and(p=1) then begin
        if d=1 then begin bi[maxd]:=s[1,2];bj[maxd]:=s[1,3];end;
        exit(s[1,1]);
    end;
    u:=min(sum,maxv[d]);
    while(u<sum)and(s[u+1,1]=s[u,1])and(s[u+1,4]=s[u,4])do inc(u);
    for i:=1 to u do
      begin
        if tot>maxnode then
           begin br:=1;break;end;
        if(p=1)and(i>1)and(s[i,1]<-5000)or(p=0)and(i>1)and(s[i,1]>5000)
           then continue;
        a[s[i,2],s[i,3]]:=p;
        if d<maxd then begin
            h:=hs[i];
            tdep:=ceil(sqr((u-i+1)/u)*(maxd-d)+d);
            if (zhb[h.sh].val<1000000)and(zhb[h.sh].key=h.lh)and
               (zhb[h.sh].dep>=tdep-d)
               then v:=zhb[h.sh].val
               else begin
                       v:=minimax(tdep,d+1,p xor 1,alpha,beta);
                       if (tdep<maxd)and(br=0)and((p=1)and((v>alpha)or(alpha<-5000))
                          or(p=0)and((v<beta)or(beta>5000)))
                          then v:=minimax(maxd,d+1,p xor 1,alpha,beta);
                    end;
          end else v:=s[i,1];
        a[s[i,2],s[i,3]]:=-1;
        if (d=1)and(v>alpha)then begin bi[maxd]:=s[i,2];bj[maxd]:=s[i,3];end;
        if br=0 then if p=1
          then alpha:=math.max(alpha,v)
          else beta:=math.min(beta,v);
        if beta<=alpha then break;
      end;
    h:=hash();
    if br=0 then begin
       if p=1
         then zhb[h.sh].val:=alpha
         else zhb[h.sh].val:=beta;
       zhb[h.sh].key:=h.lh;
       zhb[h.sh].dep:=maxd-d+1;
       exit(zhb[h.sh].val)
    end;
    if p=1
      then exit(alpha)
      else exit(beta);
end;
procedure draw;
var i,j:longint;
begin
    write(' ':3);
    for i:=1 to n do write(chr(i+64):2);
    writeln;
    for i:=n downto 1 do
      begin
        write(i:3);
        for j:=1 to n do
          case b[i,j] of
            -1:write('ú':2);
            0:write('X':2);
            1:write('O':2);
          end;
        writeln
      end;
end;
procedure xiazi;
var dep,win:longint;
begin
    a:=b;tot:=0;dep:=4;win:=0;
    stime:=gettickcount;
    for i:=1 to n do begin
        for j:=1 to n do if a[i,j]=-1 then begin
            a[i,j]:=1;
            if i5(a,1) then begin
                win:=1;
                bi[0]:=i;bj[0]:=j;
                max[0]:=100000;
                a[i,j]:=-1;
                break;
            end;
            a[i,j]:=-1;
        end;
        if win=1 then break;
    end;
    if win=0 then case m1 of
      0:begin dep:=1;bi[0]:=(n+1)>>1;bj[0]:=bi[0];max[0]:=0;end;
      1:repeat
            dep:=1;max[0]:=0;bi[0]:=random(3)+x-1;bj[0]:=random(3)+y-1;
        until (bi[0]<=n)and(bi[0]>0)and(bj[0]<=n)and(bj[0]>0)and(sx[bi[0],bj[0]]=0);
      else repeat
                br:=0;
                max[dep]:=minimax(dep,1,1,-inf,inf);
                writeln(chr(bj[dep]+64),bi[dep],'(DEP=',dep,') : ',gettickcount-stime,'ms');
                inc(dep);
           until (tot>maxnode)or(max[dep-1]>5000)or(max[dep-1]<-5000);
    end;
    if tot<=maxnode then dec(dep) else dec(dep,2);
    if win=1 then dep:=0;
    b[bi[dep],bj[dep]]:=1;
    writeln(chr(bj[dep]+64),bi[dep]);
    writeln('Value   : ',max[dep]);
    writeln('Depth   : ',dep);
    writeln('Node(s) : ',tot);
    draw;
    inc(m1);sx[bi[dep],bj[dep]]:=m1;
end;
procedure findmax;
var x,y,max,m1:longint;
begin
    max:=0;
    for x:=1 to n do
      for y:=1 to n do
        if sx[x,y]>max
          then begin i:=x;j:=y;max:=sx[x,y];end;
    m1:=0;
    for x:=1 to n do
      for y:=1 to n do
        if (sx[x,y]>m1)and(sx[x,y]<max)
          then begin i1:=x;j1:=y;m1:=sx[x,y];end;
end;
begin
    randomize;
    for i:=1 to n do
      for j:=1 to n do
        b[i,j]:=-1;
    fillchar(zhb,sizeof(zhb),127); //not used
    readln(s);
    if s='B' then for i:=1 to n do begin
        for j:=1 to n do begin
            read(d,c);
            if c='X' then begin b[n+1-i,j]:=0;inc(m1);end else
            if c='O' then begin b[n+1-i,j]:=1;inc(m1);end
        end;
        readln;
    end;
    readln(s);
    if s='O' then xiazi;
    if i5(b,1) then begin writeln('Computer wins!');readln;exit;end;
    while 1=1 do
      begin
        repeat
          readln(s);
          x:=0;y:=0;
          if s[1] in['A'..'Z']
           then y:=ord(s[1])-64
           else y:=ord(s[1])-96;
          val(copy(s,2,length(s)-1),x);
          if (s='undo')and(m1>2)
            then begin
                   dec(m1,2);findmax;
                   sx[i,j]:=0;b[i,j]:=-1;
                   sx[i1,j1]:=0;b[i1,j1]:=-1;
                   draw;
                 end;
          if copy(s,1,4)='node' then begin
            val(copy(s,pos(' ',s)+1,length(s)-pos(' ',s)),node,code);
            if code=0 then maxnode:=node;
          end;
        until (x>0)and(y>0)and(x<=n)and(y<=n)and(b[x,y]=-1);
        inc(m1);sx[x,y]:=m1;
        b[x,y]:=0;
        if i5(b,0) then begin writeln('You win!');readln;exit;end;
        xiazi;
        if i5(b,1) then begin writeln('Computer wins!');readln;exit;end;
      end;
end.
