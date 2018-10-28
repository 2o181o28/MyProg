uses math;
const e:extended=exp(1);
var n:qword;
begin
    read(n);
    if n<=1700 then begin
      writeln(n,'! ÷ ',sqrt(2*pi*n)*exp(n*ln(n/e))*exp(1/12/n):0:10);
      inc(n);
      writeln(n-1,'! ÷ ',
      sqrt(2*pi/n)*exp(n*ln(n/e*sqrt(n*sinh(1/n)+1/810/power(extended(n),6)))):0:10);
      dec(n);
    end;
    writeln('The length of ',n,'! ÷ ',
    trunc((n*ln(n)-n+ln(2*pi*n)/2+1/12/n-1/360/n/n/n+1/1260/power(extended(n),5))/ln(10))+1)
end.