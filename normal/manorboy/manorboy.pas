{$M 100000000,0,0}
uses math;
type fun=function:integer;

function zero:integer;begin zero:=0 end;
function one:integer;begin one:=1 end;
function negone:integer;begin negone:=-1 end;

function A(k:integer;x1,x2,x3,x4,x5:fun):integer;

function B():integer;
begin
  k:=k-1;
  B:=A(k,fun(@B),fun(x1),fun(x2),fun(x3),fun(x4))
end;

begin
  if k<=0
    then A:=x1()+x2()
    else A:=B()
end;


begin
  writeln(A(1,fun(@one),fun(@negone),fun(@negone),fun(@one),fun(@zero)))
end.
