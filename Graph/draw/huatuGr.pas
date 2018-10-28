{$APPTYPE GUI}
uses winmouse,graph,wincrt,dos;
var x,y,i,j,color:integer;
    a1,b1,c1,d1,a2,b2,c2,d2:word;
    mx,my,lx,ly,ms:longint;
procedure setc;
begin
     setcolor(lightgray);
     if color in [0..15] then
        rectangle(color mod 2*20+13,color div 2*20+33,
                  color mod 2*20+27,color div 2*20+47);
     color:=getpixel(mx,my);
     setfillstyle(1,color);
     bar(47,7,57,17);
     setcolor(black);
     if color in [0..15] then
     rectangle(color mod 2*20+13,color div 2*20+33,
               color mod 2*20+27,color div 2*20+47);
     rectangle(47,7,57,17);
end;
procedure more;
label l;
var a:array[61..300,195..380]of byte;
   procedure huifu;
   var i,j:longint;
   begin
     for i:=61 to 300 do
       for j:=195 to 380 do
         begin
           putpixel(i,j,a[i,j]);
           putpixel(361-i,575-j,a[361-i,575-j]);
         end;
   end;
begin
     for i:=61 to 300 do
       for j:=195 to 380 do
         a[i,j]:=getpixel(i,j);
     setfillstyle(1,lightgray);
     bar(61,195,300,380);
     setcolor(black);
     rectangle(61,195,300,380);
     outtextxy(65,202,'More colors');
     line(62,215,300,215);
     for i:=16 to 31 do
      begin
        setfillstyle(1,i);
        bar(i*11-80,220,i*11-70,230);
      end;
     for i:=32 to 247 do
      begin
        setfillstyle(1,i);
        bar((i-12) mod 20*11+70,(i-12) div 20*11+230,
            (i-12) mod 20*11+80,(i-12) div 20*11+240);
      end;
     delay(50);
   l:repeat
        getmousestate(mx,my,ms);
     until ms>0;
     if (mx>60)and(mx<301)and(my>194)and(my<381)
        then if getpixel(mx,my) in [1..14]
                then goto l
                else begin setc;huifu end
        else huifu;
end;
begin
    x:=detect;
    initgraph(x,y,'');
    setfillstyle(1,white);
    bar(1,1,getmaxx,getmaxy);
    setcolor(black);
    setfillstyle(1,lightgray);
    bar(1,1,60,215);
    rectangle(1,1,60,215);
    outtextxy(5,10,'Color');
    line(1,25,60,25);
    line(1,195,60,195);
    setcolor(red);
    outtextxy(5,200,'More...');
    for i:=0 to 15 do
      begin
         setfillstyle(1,i);
         setcolor(black);
         bar(i mod 2*20+15,i div 2*20+35,
             i mod 2*20+25,i div 2*20+45);
         rectangle(i mod 2*20+14,i div 2*20+34,
                   i mod 2*20+26,i div 2*20+46);
      end;
    color:=black;
    setfillstyle(1,black);
    bar(47,7,57,17);
    rectangle(color mod 2*20+13,color div 2*20+33,
              color mod 2*20+27,color div 2*20+47);
    a1:=0;b1:=0;c1:=0;d1:=0;
    repeat
      getmousestate(mx,my,ms);
      if ms=0 then continue;
      gettime(a2,b2,c2,d2);
      if (a2-a1)*3600000+(b2-b1)*60000+(c2-c1)*1000+(d2-d1)<10
        then
          begin
            setcolor(color);
            if ((mx>60)or(my>215))and((lx>60)or(ly>215))
              then line(lx,ly,mx,my)
              else if (mx in [15..25,35..45])and(my<=190)
                      and((my-34)mod 20 in [1..10])
                        then setc
                        else if my>190 then more;
          end
        else
            if (mx>60)or(my>215)
              then putpixel(mx,my,color)
              else if (mx in [15..25,35..45])and(my<=190)
                      and((my-34)mod 20 in [1..10])
                        then setc
                        else if my>190 then more;
      a1:=a2;b1:=b2;c1:=c2;d1:=d2;lx:=mx;ly:=my;
    until false
end.
