{han nuo ta ( hanoi ) }
uses crt;
var s:string[10];
    step:integer;
    a,b,c:byte;
    a1,b1,c1:array[1..8]of byte;
procedure readstr;
var k:char;
begin
     textbackground(green);
     textcolor(yellow);
     gotoxy(3,18);
     s:='';
     k:=readkey;
     while k<>#13 do
       begin
        if k=#8
          then
            begin
              if wherex<>1
                then
                  begin
                    gotoxy(wherex-1,wherey);
                    write(' ');
                    gotoxy(wherex-1,wherey);
                    delete(s,length(s),1);
                  end
            end
          else begin write(k);s:=s+k;end;
        k:=readkey;
       end;
     gotoxy(1,wherey+1)
end;
procedure chushihua;
var i,j:integer;
begin
    textbackground(cyan);
    clrscr;
    gotoxy(35,21);
    textcolor(black);
    write('Qing shao hou......');
    gotoxy(1,1);
    for i:=1 to 80 do
      case i of
         7:begin textcolor(blue);write('H');end;
         8:write('a');9:write('n');
         10:write('o');11:write('i');
         else
            if odd(i)
               then begin textcolor(black);write('*');end
               else begin textcolor(white);write('*');end;
      end;
    for i:=2 to 14 do
      if odd(i)
         then
            begin
               textcolor(black);
               gotoxy(1,i);
               write('*');
               textcolor(white);
               gotoxy(80,i);
               write('*');
            end
         else
            begin
               textcolor(white);
               gotoxy(1,i);
               write('*');
               textcolor(black);
               gotoxy(80,i);
               write('*');
            end;
    for i:=5 to 14 do
       begin
         if i>6
           then
              begin
                 textbackground(red);
                 gotoxy(26-i,i);
                 for j:=1 to (i-6)*2+1 do write(' ');
              end
           else
              begin
                  textbackground(black);
                  gotoxy(20,i);write(' ');
              end;
         textbackground(black);
         gotoxy(40,i);write(' ');
         gotoxy(60,i);write(' ');
       end;
    textbackground(black);
    for i:=1 to 80 do
       begin gotoxy(i,15);write(' ');end;
    textbackground(green);
    for i:=16 to 25 do
       begin gotoxy(1,i);clreol;end;
    gotoxy(3,20);
    textcolor(black);
    writeln('Bu zhou shu : 0');
    textcolor(blue);
    a:=8;b:=0;c:=0;
    for i:=1 to 8 do a1[i]:=(9-i)*2+1;
    fillchar(b1,sizeof(b1),0);
    fillchar(c1,sizeof(c1),0);
    step:=0;
end;
procedure cuowuchuli;
begin
    highvideo;
    textcolor(red);
    gotoxy(3,19);
    write('Cuo wu chu li!');
    delay(1000);
    gotoxy(1,19);
    clreol;
    textcolor(black);
end;
procedure chuli;
var f:boolean;
    i:integer;
    t:byte;
begin
     f:=true;
     case s[1] of
       'A':case s[3] of
             'B':if (a=0)or((b<>0)and(a1[a]>b1[b]))
                   then begin f:=false;cuowuchuli;end
                   else
                      begin
                         textbackground(cyan);
                         for i:=1 to a1[a] do
                             begin
                                gotoxy(19-((a1[a]-1)div 2)+i,15-a);
                                write(' ');
                             end;
                         textbackground(black);
                         gotoxy(20,15-a);
                         write(' ');
                         textbackground(red);
                         inc(b);
                         b1[b]:=a1[a];
                         for i:=1 to b1[b] do
                             begin
                                gotoxy(39-((b1[b]-1)div 2)+i,15-b);
                                write(' ');
                             end;
                         a1[a]:=0;
                         dec(a);
                      end;
             'C':if (a=0)or((c<>0)and(a1[a]>c1[c]))
                   then begin f:=false;cuowuchuli;end
                   else
                      begin
                         textbackground(cyan);
                         for i:=1 to a1[a] do
                             begin
                                gotoxy(19-((a1[a]-1)div 2)+i,15-a);
                                write(' ');
                             end;
                         textbackground(black);
                         gotoxy(20,15-a);
                         write(' ');
                         textbackground(red);
                         inc(c);
                         c1[c]:=a1[a];
                         for i:=1 to c1[c] do
                             begin
                                gotoxy(59-((c1[c]-1)div 2)+i,15-c);
                                write(' ');
                             end;
                         a1[a]:=0;
                         dec(a);
                      end;
             else begin f:=false;cuowuchuli;end;
           end;
       'B':case s[3] of
             'A':if (b=0)or((a<>0)and(b1[b]>a1[a]))
                   then begin f:=false;cuowuchuli;end
                   else
                      begin
                         textbackground(cyan);
                         for i:=1 to b1[b] do
                             begin
                                gotoxy(39-((b1[b]-1)div 2)+i,15-b);
                                write(' ');
                             end;
                         textbackground(black);
                         gotoxy(40,15-b);
                         write(' ');
                         textbackground(red);
                         inc(a);
                         a1[a]:=b1[b];
                         for i:=1 to a1[a] do
                             begin
                                gotoxy(19-((a1[a]-1)div 2)+i,15-a);
                                write(' ');
                             end;
                         b1[b]:=0;
                         dec(b);
                      end;
             'C':if (b=0)or((c<>0)and(b1[b]>c1[c]))
                   then begin f:=false;cuowuchuli;end
                   else
                      begin
                         textbackground(cyan);
                         for i:=1 to b1[b] do
                             begin
                                gotoxy(39-((b1[b]-1)div 2)+i,15-b);
                                write(' ');
                             end;
                         textbackground(black);
                         gotoxy(40,15-b);
                         write(' ');
                         textbackground(red);
                         inc(c);
                         c1[c]:=b1[b];
                         for i:=1 to c1[c] do
                             begin
                                gotoxy(59-((c1[c]-1)div 2)+i,15-c);
                                write(' ');
                             end;
                         b1[b]:=0;
                         dec(b);
                      end;
             else begin f:=false;cuowuchuli;end;
           end;
       'C':case s[3] of
             'A':if (c=0)or((a<>0)and(c1[c]>a1[a]))
                   then begin f:=false;cuowuchuli;end
                   else
                      begin
                         textbackground(cyan);
                         for i:=1 to c1[c] do
                             begin
                                gotoxy(59-((c1[c]-1)div 2)+i,15-c);
                                write(' ');
                             end;
                         textbackground(black);
                         gotoxy(60,15-c);
                         write(' ');
                         textbackground(red);
                         inc(a);
                         a1[a]:=c1[c];
                         for i:=1 to a1[a] do
                             begin
                                gotoxy(19-((a1[a]-1)div 2)+i,15-a);
                                write(' ');
                             end;
                         c1[c]:=0;
                         dec(c);
                      end;
             'B':if (c=0)or((b<>0)and(c1[c]>b1[b]))
                   then begin f:=false;cuowuchuli;end
                   else
                      begin
                         textbackground(cyan);
                         for i:=1 to c1[c] do
                             begin
                                gotoxy(59-((c1[c]-1)div 2)+i,15-c);
                                write(' ');
                             end;
                         textbackground(black);
                         gotoxy(60,15-c);
                         write(' ');
                         textbackground(red);
                         inc(b);
                         b1[b]:=c1[c];
                         for i:=1 to b1[b] do
                             begin
                                gotoxy(39-((b1[b]-1)div 2)+i,15-b);
                                write(' ');
                             end;
                         c1[c]:=0;
                         dec(c);
                      end;
             else begin f:=false;cuowuchuli;end;
           end;
       else begin f:=false;cuowuchuli;end;
     end;
     textbackground(green);
     textcolor(black);
     gotoxy(1,18);
     clreol;
     if f then inc(step);
     gotoxy(3,20);
     textcolor(black);
     writeln('Bu zhou shu : ',step);
end;
procedure tongji;
var i:integer;
begin
     textcolor(red);
     gotoxy(35,21);
     write('Wan cheng yi dong!');
     delay(1000);
     textbackground(cyan);
     clrscr;
     textcolor(black);
     gotoxy(1,25);
     for i:=1 to 60 do writeln;
     gotoxy(33,12);
     write('Bu zhou shu : ',step);
     gotoxy(30,13);
     write('Biao zhun bu zhou shu : 255');
     gotoxy(31,14);
     write('An ren yi jian tui chu');
     repeat until keypressed;
end;
begin
    chushihua;
    while c<8 do
      begin
          readstr;
          chuli;
      end;
    tongji;
end.
