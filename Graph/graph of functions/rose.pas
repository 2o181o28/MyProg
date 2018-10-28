uses graph;
var x,y:integer;
    k:extended;
begin
x:=VGA;y:=VGAHi;
initgraph(x,y,'');
while 1=1 do
  begin
   write('Input k (1..10^18):  ');
   read(k);
   flush(output);
   cleardevice;
   for x:=1 to 3142 do
      putpixel(round(cos(k*x/1000)*cos(x/1000)*200)+getmaxx div 2,
               round(cos(k*x/1000)*sin(x/1000)*200)+getmaxy div 2,
               magenta);
  end;
end.
