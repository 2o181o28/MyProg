{$APPTYPE GUI}
uses graph,windows;
var x,y:integer;
    k:extended;
begin
x:=VGA;y:=VGAHi;
initgraph(x,y,'');
setwindowtext(graphwindow,'rose');
while k<100000000 do
  begin
   k:=k+1;
   sleep(10);
   if findwindow(nil,'rose')=0 then exit;
   cleardevice;
   for x:=1 to 3142 do
      putpixel(round(cos(k*x/1000)*cos(x/1000)*200)+getmaxx div 2,
               round(cos(k*x/1000)*sin(x/1000)*200)+getmaxy div 2,
               lightmagenta);
  end;
end.
