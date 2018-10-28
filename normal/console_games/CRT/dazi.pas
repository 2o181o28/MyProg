{da zi lian xi}
uses  crt,dos;
var   s,time,cj,sum,i,jh:longint;
      a1,b1,c1,d1,a2,b2,c2,d2,y,d:word;
      x,c:char;f:boolean;st:string;
procedure qp;
begin
     textbackground(white);
     clrscr;
     textcolor(lightred);
     gotoxy(1,2);
     write('Level':40,' ',d);
     textcolor(black)
end;
procedure qg;
begin
     textcolor(red);
     write(' ');
     textcolor(darkgray);
end;
label l;
const sj:array[1..6]of integer=(3000,2000,1500,1000,750,750);
      cs:array[1..6]of integer=(30,50,50,75,100,200);
begin
   l:randomize;
     cursoroff;
     textbackground(white);
     clrscr;
     gotoxy(36,12);
     sum:=0;cj:=0;jh:=2;
     textcolor(black);
     write(' Level:');
     gotoxy(34,13);
     textcolor(white);
     write('[1]');qg;
     write('[2]');qg;
     write('[3]');qg;
     gotoxy(34,14);
     write('[4]');qg;
     write('[5]');qg;
     write('[6]');qg;
     gotoxy(34,13);
     x:=readkey;
     if x=#0 then c:=readkey;
     d:=1;
     while x<>#13 do
       begin
         case c of
           #77:
              if (wherex<>42)or(wherey<>14)then
              if (wherex=42)and(wherey=13)
                 then
                    begin
                       textcolor(darkgray);
                       write('[3]');
                       gotoxy(34,14);
                       textcolor(white);
                       d:=4;
                       write('[4]');
                       gotoxy(34,14);
                    end
                 else
                    begin
                       textcolor(darkgray);
                       d:=(wherey-13)*3+(wherex-30) div 4;
                       write('[',d,']');
                       gotoxy(wherex+1,wherey);
                       textcolor(white);
                       inc(d);
                       write('[',d,']');
                       gotoxy(wherex-3,wherey);
                    end;
           #75:if (wherex<>34)or(wherey<>13)then
               if (wherex=34)and(wherey=14)
                  then
                     begin
                        textcolor(darkgray);
                        write('[4]');
                        gotoxy(42,13);
                        textcolor(white);
                        d:=3;
                        write('[3]');
                        gotoxy(42,13);
                     end
                  else
                    begin
                       textcolor(darkgray);
                       d:=(wherey-13)*3+(wherex-30) div 4;
                       write('[',d,']');
                       gotoxy(wherex-7,wherey);
                       textcolor(white);
                       dec(d);
                       write('[',d,']');
                       gotoxy(wherex-3,wherey);
                    end;
         end;
         x:=readkey;
         if x=#0 then c:=readkey;
       end;
     qp;gotoxy(32,12);
     textcolor(black);
     write('Press any key to start');
     repeat until keypressed;x:=readkey;
     qp;textbackground(cyan);
     gotoxy(50,10);
     textcolor(yellow);
     write('Score:    ');
     str(cj,st);
     for i:=1 to 15-length(st) do write(' ');
     gotoxy(50,11);
     for i:=1 to jh+1 do write(#2);
     for i:=1 to 23-jh do write(' ');
     gotoxy(50,12);
     write('Average time:           ');
     while cj<cs[d] do
       begin
         textcolor(white);
         textbackground(cyan);
         gotoxy(60,10);
         write(cj);
         gotoxy(50,11);
         textcolor(lightred);
         for i:=1 to jh+1 do write(#2);
         for i:=1 to 3-jh do write(' ');
         textcolor(white);
         gotoxy(64,12);
         if cj<>0 then
           write(sum/cj/1000:0:4,'s');
         if random(36) in [0..25]
            then s:=random(26)+97
            else s:=random(10)+48;
         gotoxy(40,8);
         textcolor(red);
         textbackground(white);
         write(chr(s));f:=false;
         textcolor(black);
         gettime(a1,b1,c1,d1);
         repeat until keypressed;
         gettime(a2,b2,c2,d2);
         time:=(a2-a1)*3600000+(b2-b1)*60000+(c2-c1)*1000+(d2-d1)*10;
         if (time>sj[d])and(cj>0) then f:=true;
         sum:=sum+time;
         x:=readkey;
         if x<>chr(s)then f:=true;
         if f then dec(jh);
         if jh=-1 then
           begin
             qp;gotoxy(35,11);
             writeln('Input error three times!');
             writeln('Score: ':41,cj);
             if cj<>0 then writeln('Average time: ':48,sum/cj/1000:0:3,'s');
             delay(1000);qp;
             gotoxy(35,12);
             writeln('Try again?');
             gotoxy(35,13);
             textcolor(white);
             y:=1;
             write('[Yes]');qg;
             write('[No]');
             gotoxy(35,13);
             x:=readkey;
             if x=#0 then c:=readkey;
             while x<>#13 do
                begin
                  case c of
                     #77:if wherex=35 then
                         begin
                            textcolor(darkgray);
                            write('[Yes]');
                            gotoxy(41,13);
                            textcolor(white);
                            y:=0;
                            write('[No]');
                            gotoxy(41,13);
                         end;
                     #75:if wherex=41 then
                         begin
                            textcolor(darkgray);
                            write('[No]');
                            gotoxy(35,13);
                            textcolor(white);
                            y:=1;
                            write('[Yes]');
                            gotoxy(35,13);
                         end;
                  end;
                  x:=readkey;
                  if x=#0 then c:=readkey;
                end;
             if y=1 then goto l else exit;
           end;{if}
         if not f then inc(cj);
         gotoxy(40,12);
       end;{while}
     qp;
     gotoxy(35,11);
     write('Well done!');
     gotoxy(1,12);
     if cj<>0 then write('Average time: ':48,sum/cj/1000:0:3,'s');
     gotoxy(35,13);
     write('Try again?');
     gotoxy(35,14);
     clreol;
     textcolor(white);
     y:=1;
     write('[Yes]');
     textcolor(darkgray);
     write(' [No]');
     gotoxy(35,14);
     x:=readkey;
     if x=#0 then c:=readkey;
     while x<>#13 do
       begin
         case c of
           #77:if wherex=35 then
               begin
                  textcolor(darkgray);
                  write('[Yes]');
                  gotoxy(41,14);
                  textcolor(white);
                  y:=0;
                  write('[No]');
                  gotoxy(41,14);
               end;
           #75:if wherex=41 then
               begin
                  textcolor(darkgray);
                  write('[No]');
                  gotoxy(35,14);
                  textcolor(white);
                  y:=1;
                  write('[Yes]');
                  gotoxy(35,14);
               end;
         end;
         x:=readkey;
         if x=#0 then c:=readkey;
       end;
     if y=1 then goto l;
     cursoron;
end.
