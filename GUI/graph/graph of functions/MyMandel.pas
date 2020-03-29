{$APPTYPE GUI}
program MyMandel;
uses windows,graph,wincrt;
const maxx=640;maxy=480;
var i,j:longint;
    k,c,fd,heng,shu,max:int64;a,b,x,y,tx:extended;
    dx,dy:integer; st:dword;
begin
   initgraph(dx,dy,'');
   setwindowtext(graphwindow,'Mandelbrot Set');
   fd:=maxx>>2;max:=112;
   heng:=-fd div 3*2;shu:=0;
   setwindowpos(graphwindow,hwnd_top,300,200,maxx+16,maxy+38,0);
   repeat
   setwindowpos(graphwindow,hwnd_top,300,200,maxx+16,maxy+38,swp_nomove);
   cleardevice;
   for i:=-(maxx>>1) to maxx>>1 do
     for j:=-(maxy>>1) to maxy>>1 do
       begin
         a:=(i+heng)/fd;b:=(j+shu)/fd;
         x:=0;y:=0;c:=0;
         repeat
            tx:=x;
            x:=x*x-y*y+a;
            y:=2*tx*y+b;
            inc(c);
            if x*x+y*y>4 then break;
         until c>max;
         if c>max then setrgbpalette(16,0,0,0) else begin
            k:=round(sqrt(c*max)*256) div max;
            setrgbpalette(16,k,k,128);
         end;
         //setrgbpalette(16,0,0,c<<8 div (max+1));
         putpixel(i+maxx>>1,j+maxy>>1,16);
       end;
   repeat
      if findwindow(nil,'Mandelbrot Set')=0 then exit;
   until keypressed;
   case readkey of
      #61:begin               //+
            fd:=round(fd*1.5);
            shu:=round(shu*1.5);
            heng:=round(heng*1.5);
          end;
      #45:begin               //-
            fd:=round(fd/1.5);
            shu:=round(shu/1.5);
            heng:=round(heng/1.5);
          end;
      #27:exit;               //Esc
      #0:case readkey of
           #72:dec(shu,maxx>>3);  //up
           #80:inc(shu,maxx>>3);  //down
           #75:dec(heng,maxx>>3); //left
           #77:inc(heng,maxx>>3); //right
         end;
      #32:if max<1e15 then max:=max*3;      //space
      #8:if max>10 then max:=max div 3;      //bksp
   end;
   until false;
end.