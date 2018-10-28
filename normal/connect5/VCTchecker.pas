{$inline on}
const n=15;
type fmtstr=string[8];htype=record sh:longint;lh:qword;end;
const smod=100000007;lmod=100000000000000003;
var a:array[-2..n+3,-2..n+3]of longint;
    bx,by:array[1..14]of longint;
    nod,i,j,tdep:longint;
    tb:array[0..smod-1]of record key:qword;val,dep:longint;end;
function check(x,y:longint):boolean;
var i,j,f:longint;
begin
   if a[x,y]>-1 then exit(false);
   f:=0;
   for i:=x-2 to x+2 do
     for j:=y-2 to y+2 do
       if not((i<1)or(j<1)or(i>n)or(j>n))and(a[i,j]>-1)then begin f:=1;break;end;
   if f=0 then exit(false) else exit(true);
end;
function hash:htype;
var t:htype;i,j:longint;
begin
   t.sh:=0;t.lh:=0;
   for i:=1 to n do
     for j:=1 to n do begin
       t.sh:=(t.sh*3+(a[i,j]+1)) mod smod;
       t.lh:=(t.lh*3+(a[i,j]+1)) mod lmod;
     end;
   exit(t);
end;
function i5(x:longint):boolean;
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
function ch(p,x:longint):char;inline;
begin
   if x=-1 then ch:='.' else
   if x=p then ch:='X' else ch:='O';
end;
function i3b(p,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6,x7,y7,x8,y8:longint):boolean;
var s:fmtstr;
begin
   s:=ch(p,a[x1,y1])+ch(p,a[x2,y2])+ch(p,a[x3,y3])+ch(p,a[x4,y4])
     +ch(p,a[x5,y5])+ch(p,a[x6,y6])+ch(p,a[x7,y7])+ch(p,a[x8,y8]);
   if (s='...XXX.O')or(s='..XXX...')or(s='..XXX..O')or
      (s='O.XXX...')or(s='O.XXX..O')or(s='O..XXX.O')or
      (copy(s,2,6)='.XX.X.')or(copy(s,2,6)='.X.XX.')
      then exit(true)
      else exit(false);
   exit(false);
end;
function i4b(p,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6:longint;var x,y:longint):boolean;
var s:fmtstr;
begin
   s:=ch(p,a[x1,y1])+ch(p,a[x2,y2])+ch(p,a[x3,y3])
     +ch(p,a[x4,y4])+ch(p,a[x5,y5])+ch(p,a[x6,y6]);
   if s='.XXXXO' then begin
      x:=x1;y:=y1;exit(true);
   end else if s='OXXXX.' then begin
      x:=x6;y:=y6;exit(true);
   end else if (s='X.XXX.')or(s='X.XXXO')then begin
      x:=x2;y:=y2;exit(true);
   end else if (s='XXX.X.')or(s='XXX.XO')then begin
      x:=x4;y:=y4;exit(true);
   end else if (s='XX.XX.')or(s='XX.XXO')then begin
      x:=x3;y:=y3;exit(true);
   end else if s='.XXXX.' then begin
      x:=x1;y:=y1;exit(true);
   end;
   exit(false);
end;
function i3(x:longint):longint;
var i,j:longint;
begin
   for i:=1 to n do for j:=0 to n-6 do
      if i3b(x,i,j,i,j+1,i,j+2,i,j+3,i,j+4,i,j+5,i,j+6,i,j+7) then exit(1);
   for i:=0 to n-6 do for j:=1 to n do
      if i3b(x,i,j,i+1,j,i+2,j,i+3,j,i+4,j,i+5,j,i+6,j,i+7,j) then exit(1);
   for i:=0 to n-6 do for j:=0 to n-6 do
      if i3b(x,i,j,i+1,j+1,i+2,j+2,i+3,j+3,i+4,j+4,i+5,j+5,i+6,j+6,i+7,j+7) then exit(1);
   for i:=0 to n-6 do for j:=7 to n+1 do
      if i3b(x,i,j,i+1,j-1,i+2,j-2,i+3,j-3,i+4,j-4,i+5,j-5,i+6,j-6,i+7,j-7) then exit(1);
   exit(0);
end;
function i4(x:longint;var fsx,fsy:longint):longint;
var i,j:longint;
begin
   i4:=0;
   for i:=1 to n do for j:=0 to n-4 do
      if i4b(x,i,j,i,j+1,i,j+2,i,j+3,i,j+4,i,j+5,fsx,fsy) then inc(i4);
   for i:=0 to n-4 do for j:=1 to n do
      if i4b(x,i,j,i+1,j,i+2,j,i+3,j,i+4,j,i+5,j,fsx,fsy) then inc(i4);
   for i:=0 to n-4 do for j:=0 to n-4 do
      if i4b(x,i,j,i+1,j+1,i+2,j+2,i+3,j+3,i+4,j+4,i+5,j+5,fsx,fsy) then inc(i4);
   for i:=0 to n-4 do for j:=5 to n+1 do
      if i4b(x,i,j,i+1,j-1,i+2,j-2,i+3,j-3,i+4,j-4,i+5,j-5,fsx,fsy) then inc(i4);
end;
procedure fill(y:longint);
var i,j:longint;
begin
   for i:=-2 to n+3 do for j:=-2 to n+3 do
      if (i<1)or(j<1)or(i>n)or(j>n)then a[i,j]:=y;
end;
function CheckVCT(x,tp,d:longint):longint;
var fnd,fs,y,tx1,ty1,tx,ty,f,i,j,t1,t2:longint;h:htype;
procedure save(v:longint);inline;
begin
   with tb[h.sh] do begin
      key:=h.lh;
      val:=v;
      dep:=tdep-d+1;
   end;
end;
begin
   inc(nod);
   h:=hash;
   if (x=1)and(tb[h.sh].key=h.lh)and((tb[h.sh].val>0)or(tb[h.sh].dep>=tdep-d+1))
      then exit(tb[h.sh].val);
   if d>tdep then exit(0);
   y:=1 xor x;
   fill(y);
   if i5(x) then begin save(1);exit(1);end;
   if i5(y) then begin save(0);exit(0);end;
   for i:=1 to n do
      for j:=1 to n do
        if a[i,j]<>-1 then fnd:=1;
   if fnd=0 then begin save(0);exit(0);end;
   if i4(x,tx,ty)<>0 then begin bx[1]:=tx;by[1]:=ty;save(1);exit(1);end;
   for i:=1 to n do
     for j:=1 to n do if check(i,j) then begin
         a[i,j]:=x;
         t1:=i4(x,tx,ty);t2:=i3(x);
         if t1>0 then begin
            fill(x);
            if i4(y,tx1,ty1)=0 then begin
            a[tx,ty]:=y;
            if (t2=0)and(t1=1)or(i4(y,tx1,ty1)>0)
               then f:=CheckVCT(x,tp,d+1)
               else f:=1;
            if f<>0 then begin
               bx[1]:=i;by[1]:=j;
               a[tx,ty]:=-1;a[i,j]:=-1;
               save(f);exit(f);
            end;
            a[tx,ty]:=-1;
            end;
            fill(y);
         end;
         if (tp=0)and((t2>0){or(CheckVCT(x,1,d+1)=1)})and(CheckVCT(y,1,d+1)<>1) then begin
            fs:=0;
            for tx1:=1 to n do begin
               for ty1:=1 to n do if check(tx1,ty1) then begin
                 a[tx1,ty1]:=y;
                 if ((i4(y,tx,ty)>0)or(i3(x)=0))and(CheckVCT(x,tp,d+1)=0) then begin
                    fs:=1;a[tx1,ty1]:=-1;break;
                 end;
                 a[tx1,ty1]:=-1;
               end;
               if fs=1 then break;
            end;
            if fs=0 then begin bx[1]:=i;by[1]:=j;a[i,j]:=-1;save(2);exit(2);end;
         end;
         a[i,j]:=-1;
     end;
   save(0);exit(0);
end;
begin
   assign(input,'F:\test.txt');
   reset(input);
   for i:=1 to n do
      for j:=1 to n do
         read(a[i,j]);
   tdep:=1;
   while 1=1 do begin
     if CheckVCT(1,0,1)>0 then begin
        writeln('Find VCT!!!     DEP=',tdep);
        writeln(chr(by[1]+64),bx[1]);
        break;
     end else writeln('Checking VCT... DEP=',tdep);
     inc(tdep);
   end;
   while 1=1 do;
   close(input);
end.
