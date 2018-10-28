label a,b;
var n,r,step:longint;
    s:string;
{hen jian dan de cai shu you xi.
gei chu 1000 yi nei de sui ji shu,
cai cai shi duo shao.
ke ying yong er fen fa,
ye ke yi hu cai,
dan hu cai yao ping yun qi.
mi ji:
kai zhe ji suan qi jie da!}
begin
     randomize;
     b:step:=0;
     r:=random(1000);
     write('Shu ru yi ge 1000 yi nei de shu: ');
     a:readln(n);
     if n=r
        then
            begin
                 writeln('You are right!');
                 writeln('step: ',step+1);
                 writeln('Try again?   (0:yes   1:no)');
                 readln(s);
                 if s='0'
                    then goto b
                    else exit;
            end
        else
            begin
                 inc(step);
                 if n<r
                    then writeln(#24)
                    else writeln(#25);
                 goto a;
            end;
     readln
end.
