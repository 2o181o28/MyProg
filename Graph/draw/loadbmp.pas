uses sysutils,windows,winmouse,wincrt,graph;
var x,y:integer;f:file of char;
    head:array[1..54]of char;
    color:array[0..2000,0..1000]of record r,g,b:byte;end;
    i,j,k:longint;c1,c2,c3,temp:char;
    s:string;
    mx,my,ms:longint;
begin
   readln(s);
   initgraph(x,y,'');
   assign(f,s);reset(f);
   for i:=1 to 54 do read(f,head[i]);
   x:=ord(head[19])+ord(head[20])<<8+ord(head[21])<<16+ord(head[22])<<24;
   y:=ord(head[23])+ord(head[24])<<8+ord(head[25])<<16+ord(head[26])<<24;
   setwindowpos(graphwindow,hwnd_top,0,0,x+16,y+38,0);
   setwindowtext(graphwindow,@s[1]);
   for j:=0 to y-1 do
     begin
       for i:=0 to x-1 do
         begin
            read(f,c1,c2,c3);
            setrgbpalette(16,ord(c3),ord(c2),ord(c1));
            with color[i,y-j] do begin r:=ord(c3);g:=ord(c2);b:=ord(c1);end;
            putpixel(i,y-j,16);
         end;
       for i:=1 to (4-(x*3)and 3)and 3 do read(f,temp);
     end;
   close(f);
   while not keypressed do
     begin
       repeat
          if keypressed then exit;
          getmousestate(mx,my,ms);
       until ms>0;
       with color[mx,my] do messagebox(graphwindow,
                 pchar('Red='+inttostr(r)+#13#10'Green='+inttostr(g)+#13#10'Blue='+inttostr(b)),
                 pchar('Color of ('+inttostr(mx)+','+inttostr(my)+')'),
                 mb_iconinformation);
       repeat
          getmousestate(mx,my,ms);
       until ms=0;
     end;
end.
