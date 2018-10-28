uses sysutils,windows,winmouse,wincrt,graph;
var board,tmp:array[0..2000,0..2000]of longint;
    x,y,cnt:integer;
    i,j,r,g,b,t:longint;
    a:array[1..4,1..3]of longint;
    f:file of char;
    head:array[1..54]of char;
    k:longint;c1,c2,c3,temp:char;
    s:string;
procedure GetRGB(color:longint;var r,g,b:longint);
begin
    b:=color and 255;
    color:=color>>8;
    g:=color and 255;
    color:=color>>8;
    r:=color;
end;

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
            board[i,y-j]:=rgb(ord(c3),ord(c2),ord(c1));
         end;
       for i:=1 to (4-(x*3)and 3)and 3 do read(f,temp);
     end;
   close(f);
repeat
   for i:=0 to x do
        for j:=0 to y do
               begin
                   cnt:=4;
                   fillchar(a,sizeof(a),0);
                   if i=0 then dec(cnt)
                   else GetRGB(board[i-1,j],a[1,1],a[1,2],a[1,3]);
                   if j=0 then dec(cnt)
                   else GetRGB(board[i,j-1],a[2,1],a[2,2],a[2,3]);
                   if i=getmaxx then dec(cnt)
                   else GetRGB(board[i+1,j],a[3,1],a[3,2],a[3,3]);
                   if j=getmaxy then dec(cnt)
                   else GetRGB(board[i,j+1],a[4,1],a[4,2],a[4,3]);
                   r:=0;g:=0;b:=0;
                   for t:=1 to 4 do begin
                     inc(r,a[t,1]);inc(g,a[t,2]);inc(b,a[t,3]);
                   end;
                   r:=round(r/cnt);g:=round(g/cnt);b:=round(b/cnt);
                   tmp[i,j]:=RGB(b,g,r);
               end;
    for i:=0 to x do for j:=0 to y do begin
        board[i,j]:=tmp[i,j];
        GetRGB(board[i,j],r,g,b);
        SetRGBPalette(16,b,g,r);
        PutPixel(i,j,16);
    end;
until false;
end.