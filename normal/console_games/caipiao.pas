uses crt;
var a:array[1..6]of 1..20;
    b:set of byte;
    i,s,z,x:longint;
{zhe shi yi ge mai cai piao you xi.
di yi hang shu ru 6 ge hao ma,
di er hang shu ru mai duo shao zhu.
jiang zi dong sui ji xuan chu 6 ge zhong jiang hao ma,
ru guo xiang tong wei zhi shang de shu yi yang,
na me jiu zhong jiang le.
ding jia:
1 zhu cai piao  0.7 yuan}
begin
     randomize;
     s:=0;
     write('Shu ru 6 ge shu: ');
     for i:=1 to 6 do read(a[i]);
     write('Shu ru zhu shu: ');
     read(z);
     for i:=1 to 6 do begin x:=random(20)+1;write(x:3);b:=b+[x];end;
     writeln;
     for i:=1 to 6 do if a[i]in b then inc(s);
     case s of
          0:writeln('an wei jiang -',1.3*z:0:2,'Yuan');
          1:writeln('can yu jiang 0.00Yuan');
          2:writeln('si deng jiang ',17.3*z:0:2,'Yuan');
          3:writeln('san deng jiang ',87.3*z:0:2,'Yuan');
          4:writeln('er deng jiang ',587.3*z:0:2,'Yuan');
          5:writeln('yi deng jiang ',3887.3*z:0:2,'Yuan');
          6:writeln('te deng jiang ',9887.3*z:0:2,'Yuan');
     end;
     repeat until keypressed;
end.
