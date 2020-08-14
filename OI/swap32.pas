var a:longint;
    b:array[1..2]of word absolute a;
{$ASMMODE INTEL}
begin
read(a);
{method1} asm ror a,16 end;
//method2 a:=swap(a);
//method3 a:=lo(a)<<16+hi(a);
//method4 a:=a>>16+a and $FFFF<<16;
//method5 a:=b[2]<<16+b[1];
writeln(a);
end.
