uses mmath,graph,math,wincrt,windows;
const eps=1e-1;
var gd,gm:integer;
    i,j,cl,s:longint;
    r,t,a,b,m1,m2,n1,n2,n3:extended;
procedure rd(var x:extended);
begin
    if random(2)=0 then x:=x+eps else x:=x-eps;
end;
begin
read(a,b,m1,m2,n1,n2,n3);
randomize;
initgraph(gd,gm,'');
SetWindowText(GraphWindow,'Superformula');
while 1=1 do begin
//    read(a,b,m1,m2,n1,n2,n3);
    case random(7) of
        0:rd(a);1:rd(b);2:rd(m1);3:rd(m2);4:rd(n1);5:rd(n2);6:rd(n3);
    end;
   // initgraph(gd,gm,'');
   // SetWindowText(GraphWindow,'Superformula');
   ClearDevice();
    setOxy();
   setscale(200,200);
    for i:=-3141 to 3141 do begin
        t:=i/1000;
        r:=power(
            power( abs(cos(m1*t/4) / a), n2) +
            power( abs(sin(m2*t/4) / b), n3),
            -1/n1);
        SetPolarPix(r,t);
    end;
  //  repeat
  //      s:=FindWindow(nil,'Superformula');
  //  until s=0;
  //  closegraph;
  sleep(10);
end
end.
