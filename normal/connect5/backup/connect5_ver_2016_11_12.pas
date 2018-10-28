{$inline on}
uses math;
const m=7;n=15;maxv=8;
      sh=3;chong=2;huo=1;
      inf=1000000;
type arr=array[-1..n+2,-1..n+2]of longint;
var x,y,f,i,j,bi,bj,i1,j1,m1:longint;
    a,b,sx:arr;s:string;
function i5(a:arr;x:longint):boolean;
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
function i4(x:longint):longint;
var i,j,c4,y:longint;
function i4l(var a,b,c,d,e,f,x:longint):longint;inline;
begin
    if(a<>x)and(e<>x)then exit(0);
    if(a=x)and(b=x)and(c<0)and(d=x)and(e=x)and(f<>x)or
      (a=x)and(b<0)and(c=x)and(d=x)and(e=x)and(f<>x)or
      (a=x)and(b=x)and(c=x)and(d<0)and(e=x)and(f<>x)then exit(chong);
    if(a<0)and(b=x)and(c=x)and(d=x)and(e=x)
      then if(f<0)then exit(huo)else if(f<>x)then exit(chong);
    if(b=x)and(c=x)and(d=x)and(e=x)and(f<0)
      then if(a<0)then exit(huo)else if(a<>x)then exit(chong);
    exit(0);
end;
begin
    c4:=0;y:=1 xor x;
    for i:=-1 to n+2 do
      begin
         a[i,-1]:=y;a[i,0]:=y;a[0,i]:=y;a[-1,i]:=y;
         a[i,n+1]:=y;a[i,n+2]:=y;a[n+1,i]:=y;a[n+2,i]:=y;
      end;
    for i:=0 to n-4 do
      for j:=1 to n do
        begin
           case i4l(a[i,j],a[i+1,j],a[i+2,j],a[i+3,j],a[i+4,j],a[i+5,j],x)of
             chong:inc(c4);
             huo:exit(huo);
           end;
           case i4l(a[j,i],a[j,i+1],a[j,i+2],a[j,i+3],a[j,i+4],a[j,i+5],x)of
             chong:inc(c4);
             huo:exit(huo);
           end;
        end;
    for i:=0 to n-4 do
      for j:=0 to n-4 do
        case i4l(a[i,j],a[i+1,j+1],a[i+2,j+2],a[i+3,j+3],a[i+4,j+4],a[i+5,j+5],x)of
          chong:inc(c4);
          huo:exit(huo);
        end;
    for i:=5 to n+1 do
      for j:=0 to n-4 do
        case i4l(a[i,j],a[i-1,j+1],a[i-2,j+2],a[i-3,j+3],a[i-4,j+4],a[i-5,j+5],x)of
          chong:inc(c4);
          huo:exit(huo);
        end;
    if c4>1
      then exit(sh);
    if c4>0
      then exit(chong);
    exit(0);
end;
function i3(x:longint):longint;
var i,j,c3,h3,y:longint;
function i3l(var a,b,c,d,e,f,g,x:longint):longint;inline;
var y:longint;
begin
   y:=1 xor x;
   if (c=x)and(d=x)and(e=x)and(f<>x)and(b<>x) then
     begin
       if (b=y)and(f=y)or(b=y)and(g=y)or(a=y)and(f=y)
          or(a=x)and(b<>y)or(g=x)and(f<>y)
          then exit(0);
       if (f=y)or(b=y)or(a=y)and(g=y) then exit(chong);
       exit(huo);
     end;
   if (b=x)and(d=x)and(e=x)and(c<0) then
     begin
       if (a=y)and(f=y)or(a=x)or(f=x) then exit(0);
       if (a=y)or(f=y) then exit(chong);
       exit(huo);
     end;
   if (b=x)and(c=x)and(e=x)and(d<0) then
     begin
       if (a=y)and(f=y)or(a=x)or(f=x) then exit(0);
       if (a=y)or(f=y) then exit(chong);
       exit(huo);
     end;
   if (a=x)and(c=x)and(e=x)and(b<0)and(d<0) then exit(chong);
   exit(0);
end;
begin
    y:=1 xor x;
    for i:=-1 to n+2 do
      begin
         a[i,-1]:=y;a[i,0]:=y;a[0,i]:=y;a[-1,i]:=y;
         a[i,n+1]:=y;a[i,n+2]:=y;a[n+1,i]:=y;a[n+2,i]:=y;
      end;
    c3:=0;h3:=0;
    for i:=-1 to n+2 do
      for j:=-1 to n-4 do
        begin
          case i3l(a[i,j],a[i,j+1],a[i,j+2],a[i,j+3],a[i,j+4],a[i,j+5],a[i,j+6],x) of
            huo:inc(h3);
            chong:inc(c3);
          end;
          case i3l(a[j,i],a[j+1,i],a[j+2,i],a[j+3,i],a[j+4,i],a[j+5,i],a[j+6,i],x) of
            huo:inc(h3);
            chong:inc(c3);
          end;
        end;
    for i:=-1 to n-4 do
      for j:=-1 to n-4 do
         case i3l(a[i,j],a[i+1,j+1],a[i+2,j+2],a[i+3,j+3],a[i+4,j+4],a[i+5,j+5],a[i+6,j+6],x) of
            huo:inc(h3);
            chong:inc(c3);
         end;
    for i:=5 to n+2 do
      for j:=-1 to n-4 do
         case i3l(a[i,j],a[i-1,j+1],a[i-2,j+2],a[i-3,j+3],a[i-4,j+4],a[i-5,j+5],a[i-6,j+6],x) of
            huo:inc(h3);
            chong:inc(c3);
         end;
    if h3=1 then exit(huo+c3*1000);
    if h3>1 then exit(sh+c3*1000);
    exit(c3*1000);
end;
function h2(p:longint):longint;
const lian=3;jian=2;t=1;
var i,j,c,q:longint;
function h2l(var a,b,c,d,e,f,g,x:longint):longint;inline;
begin
    if(a<0)and(b<0)and(c<0)and(d=x)and(e=x)and(f<0)and(g=1 xor x)or
      (a<0)and(b<0)and(c=x)and(d=x)and(e<0)and(f<0)or
      (a=1 xor x)and(b<0)and(c=x)and(d=x)and(e<0)and(f<0)and(g<0)
      then exit(lian);
    if(a<0)and(b=x)and(c<0)and(d=x)and(e<0)and(f<0)or
      (a<0)and(b<0)and(c=x)and(d<0)and(e=x)and(f<0)and(g=1 xor x)
      then exit(jian);
    if(a<0)and(b=x)and(c<0)and(d<0)and(e=x)and(f<0)
      then exit(t);
    h2l:=0;
end;
begin
    h2:=0;q:=1 xor p;
    for i:=-1 to n+2 do
      begin
         a[i,-1]:=q;a[i,0]:=q;a[0,i]:=q;a[-1,i]:=q;
         a[i,n+1]:=q;a[i,n+2]:=q;a[n+1,i]:=q;a[n+2,i]:=q;
      end;
    for i:=1 to n do
      for j:=0 to n-5 do
        begin
          case h2l(a[i,j],a[i,j+1],a[i,j+2],a[i,j+3],a[i,j+4],a[i,j+5],a[i,j+6],p) of
            lian:inc(h2,5);
            jian:inc(h2,4);
            t:inc(h2,3);
          end;
          case h2l(a[i,j],a[i,j+1],a[i,j+2],a[i,j+3],a[i,j+4],a[i,j+5],a[i,j+6],q) of
            lian:dec(h2,13);
            jian:dec(h2,12);
            t:dec(h2,11);
          end;
          case h2l(a[j,i],a[j+1,i],a[j+2,i],a[j+3,i],a[j+4,i],a[j+5,i],a[j+6,i],p) of
            lian:inc(h2,5);
            jian:inc(h2,4);
            t:inc(h2,3);
          end;
          case h2l(a[j,i],a[j+1,i],a[j+2,i],a[j+3,i],a[j+4,i],a[j+5,i],a[j+6,i],q) of
            lian:dec(h2,13);
            jian:dec(h2,12);
            t:dec(h2,11);
          end;
        end;
    for i:=0 to n-5 do
      for j:=0 to n-5 do
        begin
          case h2l(a[i,j],a[i+1,j+1],a[i+2,j+2],a[i+3,j+3],a[i+4,j+4],a[i+5,j+5],a[i+6,j+6],p) of
            lian:inc(h2,5);
            jian:inc(h2,4);
            t:inc(h2,3);
          end;
          case h2l(a[i,j],a[i+1,j+1],a[i+2,j+2],a[i+3,j+3],a[i+4,j+4],a[i+5,j+5],a[i+6,j+6],q) of
            lian:dec(h2,13);
            jian:dec(h2,12);
            t:dec(h2,11);
          end;
        end;
    for i:=6 to n+1 do
      for j:=0 to n-5 do
        begin
          case h2l(a[i,j],a[i-1,j+1],a[i-2,j+2],a[i-3,j+3],a[i-4,j+4],a[i-5,j+5],a[i-6,j+6],p) of
            lian:inc(h2,5);
            jian:inc(h2,4);
            t:inc(h2,3);
          end;
          case h2l(a[i,j],a[i-1,j+1],a[i-2,j+2],a[i-3,j+3],a[i-4,j+4],a[i-5,j+5],a[i-6,j+6],q) of
            lian:dec(h2,13);
            jian:dec(h2,12);
            t:dec(h2,11);
          end;
        end;
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
          if (a[i,j]=q)and(c<3) then dec(h2,3);
        end;
end;
function tj(p,d:longint):longint;//now turn to player q(1-p),
                               //return the value of player p
var i3_p,i3_q,i4_p,i4_q,x,q,h3_p,h3_q:longint;
begin
    q:=1 xor p;
    i4_q:=i4(q);i4_p:=i4(p);
    i3_p:=i3(p);i3_q:=i3(q);
    h3_p:=i3_p mod 1000;h3_q:=i3_q mod 1000;
    x:=h2(p);
    if (i4_p=chong)or(h3_p=huo) then inc(x,18);
    dec(x,i3_q div 1000*13);
    inc(x,i3_p div 1000*4);
    if i5(a,p) then exit(x+20000-d*1000);
    if (i4_q=huo)or(i4_q=chong) then exit(x-9500);
    if i4_p=huo then exit(x+9000);
    if (i4_p=chong)and(h3_p=huo)or(i4_p=sh) then exit(x+8500);
    if ((h3_q=huo)or(h3_q=sh))and(i4_p<>chong) then exit(x-8000);
    if h3_p=sh then exit(x+7500);
    tj:=x
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
function minimax(d,p,alpha,beta:longint):longint;
var i,j,k,v,sum:longint;tmp:array[1..3]of longint;
    s:array[1..n*n,1..3]of longint;
begin
    sum:=0;
    for i:=1 to n do
      for j:=1 to n do
        if check(i,j) then
          begin
            inc(sum);
            a[i,j]:=p;
            s[sum,1]:=(p<<1-1)*tj(p,d);
            a[i,j]:=-1;
            s[sum,2]:=i;s[sum,3]:=j;
            k:=sum;
            while (k>1)and((s[k-1,1]<s[k,1])xor not boolean(p)) do
               begin tmp:=s[k];s[k]:=s[k-1];s[k-1]:=tmp;dec(k);end;
          end;
    for i:=1 to min(sum,maxv) do
      begin
        a[s[i,2],s[i,3]]:=p;
        if d<m then v:=minimax(d+1,p xor 1,alpha,beta) else v:=s[i,1];
        a[s[i,2],s[i,3]]:=-1;
        if (d=1)and(v>alpha)then begin bi:=s[i,2];bj:=s[i,3];end;
        if p=1
          then alpha:=max(alpha,v)
          else beta:=min(beta,v);
        if beta<=alpha then break;
      end;
    if p=1
      then exit(alpha)
      else exit(beta)
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
            -1:write('.':2);
            0:write('X':2);
            1:write('O':2);
          end;
        writeln
      end;
end;
procedure xiazi;
var max:longint;
begin
    a:=b;
    case m1 of
      0:begin bi:=(n+1)>>1;bj:=bi;max:=0;end;
      1:repeat
            max:=0;bi:=random(3)+x-1;bj:=random(3)+y-1;
        until (bi<=n)and(bi>0)and(bj<=n)and(bj>0)and(sx[bi,bj]=0);
      else max:=minimax(1,1,-inf,inf);
    end;
    b[bi,bj]:=1;
    writeln(chr(bj+64),bi,' (Value = ',max,')');
    draw;
    inc(m1);sx[bi,bj]:=m1;
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
    repeat
        readln(s);
        if (s='X')or(s='O')then break;
        if s[1] in['A'..'Z']
           then y:=ord(s[1])-64
           else y:=ord(s[1])-96;
        delete(s,1,1);
        val(copy(s,1,pos(' ',s)-1),x);
        if s[length(s)]='X'
           then b[x,y]:=0
           else b[x,y]:=1;
        inc(m1);
    until 1=0;
    if s='O' then xiazi;
    if i5(b,1) then begin writeln('Computer wins!');exit;end;
    while 1=1 do
      begin
        repeat
          readln(s);
          if s[1] in['A'..'Z']
           then y:=ord(s[1])-64
           else y:=ord(s[1])-96;
          val(copy(s,2,length(s)-1),x);
          if (s='undo')and(m1>2)
            then begin
                   findmax;
                   sx[i,j]:=0;b[i,j]:=-1;
                   sx[i1,j1]:=0;b[i1,j1]:=-1;
                   draw;
                 end;
        until (x>0)and(y>0)and(x<=n)and(y<=n)and(b[x,y]=-1);
        inc(m1);sx[x,y]:=m1;
        b[x,y]:=0;
        if i5(b,0) then begin writeln('You win!');readln;exit;end;
        xiazi;
        if i5(b,1) then begin writeln('Computer wins!');readln;exit;end;
      end;
end.
