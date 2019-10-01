program Connect6{LiuZiQi};
{$APPTYPE GUI}
uses Graph,WinCRT,WinMouse,Windows,DOS;
label l1,l2,lt1,lt2,start;
const c1=yellow;
      c2=LightGreen;
      p1=black;p2=white;
      MaxSize=41;
type arr=array[1..MaxSize,1..MaxSize]of integer;
var wj,f,t:integer;
    x,y,x1,y1,lx1,ly1,lx2,ly2:integer;
    max,g,q,WMaxX,WMaxY,wx:integer;
    wx1,wy1,wx2,wy2,s1,s2:integer;
    a,b:arr;
    mx,my,ms,mouse:longint;s:string;
    jmp,undo,bj,lzbs,deuce:boolean;
function lqd(x:integer):integer;
begin
     lqd:=(x-1)*g+30;
end;
procedure hqz(x,y,r,c,f:integer);
var s:string;x1,y1:integer;
begin
    if f=1
       then SetColor(white)
       else SetColor(c);
    SetFillStyle(1,c);
    FillEllipse(x,y,r,r);
    if (f=0)and lzbs then
      begin
        x1:=round((x-30)/g+1);
        y1:=round((y-30)/g+1);
        str(b[x1,y1],s);
        SetColor(15-c);
        case length(s) of
          1:OutTextXY(x-3,y-3,s);
          2:OutTextXY(x-6,y-3,s);
          3:OutTextXY(x-9,y-3,s);
        end;
      end;
end;
procedure HuaQiPan;
var i,j,m:integer;st:string;
begin
   if WMaxY-12<Max*20 then
      begin
        WMaxX:=max*20+172;WMaxY:=max*20+12;
        wx:=(GetMaxX-WMaxX-16)>>1;
        SetWindowPos(GraphWindow,HWnd_top,wx,0,WMaxX+16,WMaxY+38,0);
      end;
   SetFillStyle(1,black);
   bar(1,1,WMaxX+50,WMaxY+50);
   g:=(WMaxY-40) div (max-1);
   if g<26
     then q:=round(g*0.35)
     else q:=10;
   hqz(WMaxX-80,WMaxY-95,8,black,1);
   hqz(WMaxX-50,WMaxY-95,8,white,1);
   hqz(WMaxX-20,WMaxY-95,8,black,1);
   if lzbs then
     begin
       SetColor(white);
       OutTextXY(WMaxX-83,WMaxY-98,'1');
       SetColor(black);
       OutTextXY(WMaxX-53,WMaxY-98,'2');
       SetColor(white);
       OutTextXY(WMaxX-23,WMaxY-98,'3');
     end;
   SetTextStyle(1,4,2);
   OutTextXY(WMaxX-70,WMaxY-80,'+ -');
   SetTextStyle(1,4,1);
   OutTextXY(WMaxX-100,WMaxY-60,'Undo (Ctrl+Z)');
   OutTextXY(WMaxX-100,WMaxY-45,'Help     (F1)');
   OutTextXY(WMaxX-100,WMaxY-30,'Exit    (Esc)');
   SetFillStyle(4,red);
   bar(WMaxY,WMaxY-15,WMaxX,WMaxY);
   SetColor(c1);
   OutTextXY(WMaxY+2,WMaxY-10,'Player 1');
   SetColor(c2);
   OutTextXY(WMaxX-62,WMaxY-10,'Player 2');
   SetFillStyle(1,white);
   m:=(WMaxX+WMaxY)>>1;
   bar(m-15,WMaxY-15,m+15,WMaxY);
   SetColor(black);
   str(s1,st);
   OutTextXY(m-13,WMaxY-10,st);
   str(s2,st);
   OutTextXY(m+7,WMaxY-10,st);
   OutTextXY(m-2,WMaxY-10,':');
   SetFillStyle(1,brown);
   SetColor(black);
   bar(1,1,WMaxY,WMaxY);
   for i:=0 to max-1 do
     begin
       line(i*g+30,30,i*g+30,30+(max-1)*g);
       line(30,i*g+30,30+(max-1)*g,i*g+30);
     end;
   SetColor(red);
   for i:=0 to max-1 do
     begin
      str(i+1:2,s);
      OutTextXY(i*g+25,10,s);
      OutTextXY(3,i*g+25,s);
     end;
   for i:=1 to max do
     for j:=1 to max do
       if a[i,j]<>0 then
         begin
           if a[i,j]=1
             then hqz(lqd(i),lqd(j),q,p1,0)
             else hqz(lqd(i),lqd(j),q,p2,0);
           if ((i=lx1)and(j=ly1)or(i=lx2)and(j=ly2))and(t>1)and(not lzbs)
             then
               begin
                 SetFillStyle(1,red);SetColor(red);
                 FillEllipse(lqd(i),lqd(j),2,2);
               end;
         end;
end;
procedure FangDa;
begin
   if (WMaxX+12<GetMaxX)and(WMaxY+12<GetMaxY)then
     begin
       inc(WMaxX,12);inc(WMaxY,12);
       dec(wx,6);
       SetWindowPos(GraphWindow,HWnd_top,wx,0,WMaxX+16,WMaxY+38,0);
       HuaQiPan;
     end;
end;
procedure SuoXiao;
begin
   if (WMaxY-12>Max*20)and(WMaxY>200)then
     begin
       dec(WMaxX,12);dec(WMaxY,12);
       inc(wx,6);
       SetWindowPos(GraphWindow,HWnd_top,wx,0,WMaxX+16,WMaxY+38,0);
       HuaQiPan;
     end;
end;
procedure Ext;
var f:text;
begin
    case MessageBox(GraphWindow,'游戏正在进行，您希望退出吗？'#13#10'退出时选择“是”保存，选择“否”不保存。',
                    '六子棋',MB_YesNoCancel or MB_IconWarning) of
         2:begin
             repeat
               GetMouseState(mx,my,ms);
             until ms=0;
             exit
           end;
         7:begin
             assign(f,'lzqdata.dat');
             rewrite(f);
             close(f);halt
           end;
         else
           begin
             assign(f,'lzqdata.dat');
             rewrite(f);
             WriteLn(f,max);
             for x:=1 to max do
               begin
                for y:=1 to max do
                  write(f,a[x,y],' ',b[x,y],' ');
                WriteLn(f)
               end;
             if lzbs
                then WriteLn(f,1)
                else WriteLn(f,0);
             WriteLn(f,WMaxX,' ',WMaxY);
             WriteLn(f,wj,' ',s1,' ',s2);
             WriteLn(f,t,' ',lx1,' ',ly1,' ',lx2,' ',ly2);
             close(f);halt
           end
    end;
end;
procedure Help;
begin
    MessageBox(GraphWindow,
'    这是基于Free Pascal的一个小游戏程序。'#13#10'    第一名玩家首先下一枚棋子，以后双方每次轮流下两枚棋子，最先将己方的六枚棋子在横、竖或对角线上连成一排者胜。'#13#10'    在棋盘上点击鼠标左键，或输入棋子的坐标以落棋。',
               '六子棋V1.5 by Wei - 游戏帮助',0);
    repeat
     GetMouseState(mx,my,ms);
    until ms=0;
end;
procedure GRead(var n:integer;x,y,f:integer);
var c:char;s:string;
    l:integer;tmp:longint;
begin
    c:=ReadKey;undo:=false;
    if c=#0 then c:=ReadKey;
    if (f>1)and(c=#27) then begin Ext;n:=-1;exit;end;
    if (f>1)and(c=#26) then begin undo:=true;exit;end;
    if c=#101 then begin Help;n:=-1;exit;end;
    s:='';
    SetFillStyle(1,black);
    l:=getcolor;
    SetColor(white);
    while c<>#13 do
      begin
        if (s='')and(c=#8)then begin c:=ReadKey;continue;end;
        if c=#8
           then delete(s,length(s),1)
           else s:=s+c;
        bar(x,y-3,WMaxX,y+6);
        OutTextXY(x,y,s);
        while not KeyPressed do
          begin
            GetMouseState(mx,my,ms);
            if (f>0)and(ms>0) then begin mouse:=1;exit;end;
          end;
        c:=ReadKey;
        if c=#0 then c:=ReadKey;
        if (f>1)and(c=#27) then begin Ext;n:=-1;exit;end;
        if (f>1)and(c=#26) then begin undo:=true;exit;end;
        if c=#101 then begin Help;n:=-1;exit;end;
     end;
    val(s,tmp);
    if tmp>maxint
      then n:=0
      else n:=tmp;
    SetColor(l);
end;
procedure init(f:integer);
var x,y,i,j,m,tmp:integer;
    st1:PathStr;tx:text;
begin
   FillChar(a,SizeOf(a),0);
   FillChar(b,SizeOf(b),0);
   lx1:=-1;ly1:=-1;lx2:=-1;ly2:=-1;
   jmp:=false;lzbs:=false;deuce:=false;
   if f=0 then
     begin
       WMaxX:=640;WMaxY:=480;
       m:=WMaxX>>1;
       x:=0;y:=0;
       InitGraph(x,y,'');
       wx:=(GetMaxX-WMaxX-16)>>1;
       SetWindowText(GraphWindow,'六子棋 - 双人对战');
       SetWindowPos(GraphWindow,HWnd_top,wx,0,WMaxX+16,WMaxY+38,0);
       st1:=FSearch('lzqdata.dat','');
       if (st1<>'')then
         begin
           assign(tx,st1);
           reset(tx);
           if not eof(tx)and(MessageBox(GraphWindow,'您想继续保存的游戏吗？','找到保存的游戏',
            MB_YesNo or MB_IconQuestion)=IdYes)then
              begin
                read(tx,max);
                for i:=1 to max do
                  for j:=1 to max do
                    read(tx,a[i,j],b[i,j]);
                read(tx,tmp);
                if tmp=1
                  then lzbs:=true
                  else lzbs:=false;
                read(tx,WMaxX,WMaxY,wj,s1,s2,t,lx1,ly1,lx2,ly2);
                SetWindowPos(GraphWindow,HWnd_Top,
                             wx,1,WMaxX+16,WMaxY+38,0);
                HuaQiPan;
                close(tx);
                assign(tx,st1);
                rewrite(tx);
                close(tx);
                jmp:=true;exit
              end;
            close(tx);
         end;
     end;
   ClearDevice;
   m:=WMaxX>>1;
   SetTextStyle(1,4,2);
   SetColor(white);
   OutTextXY(m-105,50,'Connect6 Game');
   SetColor(yellow);
   OutTextXY(m-106,49,'Connect6 Game');
   SetColor(c1);
   SetTextStyle(1,4,1);
   OutTextXY(m-70,100,'Board size:');
   GRead(max,m+20,100,0);
   while (max<6)or(max>MaxSize) do
      begin
        SetFillStyle(1,black);
        bar(m+20,95,WMaxX,110);
        GRead(max,m+20,100,0);
      end;
   HuaQiPan;
end;
procedure first;
label l;
begin
   f:=1;wj:=1;t:=1;
 l:SetColor(c1);
   SetFillStyle(1,black);
   bar(WMaxY+10,10,WMaxX-10,56);
   OutTextXY(WMaxY+15,20,'   Player 1 (   )');
   hqz(WMaxY+130,20,8,p1,1);
   SetColor(c1);
   OutTextXY(WMaxY+15,40,'x:');
   OutTextXY(WMaxY+15,50,'y:');
   repeat
      if KeyPressed then
          begin
            GRead(x,WMaxY+50,40,1);
            if mouse=1 then begin mouse:=0;break;end;
            while (x<1)or(x>max) do
               begin
                  SetFillStyle(1,black);
                  bar(WMaxY+50,37,WMaxX,46);
                  GRead(x,WMaxY+50,40,1);
                  if mouse=1 then break;
               end;
            while not KeyPressed do
              begin
                GetMouseState(mx,my,ms);
                if (f>0)and(ms>0) then begin mouse:=1;break;end;
              end;
            if mouse=1 then begin mouse:=0;break;end;
            GRead(y,WMaxY+50,50,1);
            if mouse=1 then begin mouse:=0;break;end;
            while (y<1)or(y>max) do
               begin
                  SetFillStyle(1,black);
                  bar(WMaxY+50,47,WMaxX,56);
                  GRead(y,WMaxY+50,50,1);
                  if mouse=1 then break;
               end;
            if mouse=1 then mouse:=0;
            break;
          end;
      GetMouseState(mx,my,ms);
   until ms>0;
   if ms>0 then
     begin
       if (mx>WMaxX-101)and(mx<WMaxX-10)and(my<WMaxY-35)then
           begin
             if my>WMaxY-50 then help else if my>WMaxY-89 then
             if mx<WMaxX-45 then FangDa else SuoXiao else
             if my<WMaxY-88 then begin lzbs:=not lzbs;HuaQiPan;end;
             delay(156);goto l;
           end;
       x:=round((mx-30)/g+1);
       y:=round((my-30)/g+1);
       if (x>max)or(x<1)or(y>max)or(y<1)
          then begin delay(156);goto l;end;
       SetColor(white);
       str(x,s);OutTextXY(WMaxY+50,40,s);
       str(y,s);OutTextXY(WMaxY+50,50,s);
       delay(300)
     end;
   if not lzbs then
     begin
       SetFillStyle(1,red);SetColor(red);
       FillEllipse(lqd(x),lqd(y),2,2);
     end;
   a[x,y]:=wj;wj:=2;
   b[x,y]:=1;lx1:=x;ly1:=y;
   hqz(lqd(x),lqd(y),q,p1,0);
   x1:=0;y1:=0;
end;
procedure clear(x,y,f:integer);
var lx,ly:integer;
begin
    if f=1 then
      if wj=2 then wj:=1 else wj:=2;
    dec(t);
    b[x,y]:=0;a[x,y]:=0;
    SetColor(brown);
    SetFillStyle(1,brown);
    lx:=lqd(x);ly:=lqd(y);
    FillEllipse(lx,ly,q,q);
    SetColor(black);
    if (x>1)and(x<max)
       then line(lx-q,ly,lx+q,ly) else
    if x=1
       then line(lx,ly,lx+q,ly)
       else line(lx-q,ly,lx,ly);
    if (y>1)and(y<max)
       then line(lx,ly-q,lx,ly+q) else
    if y=1
       then line(lx,ly,lx,ly+q)
       else line(lx,ly-q,lx,ly);
    if t=1
      then
        begin
          SetFillStyle(1,p1);SetColor(p1);
          FillEllipse(lqd(lx1),lqd(ly1),2,2);
          exit;
        end;
    if not lzbs then
      if f=0
        then begin
          if wj=2
            then begin SetFillStyle(1,p1);SetColor(p1);end
            else begin SetFillStyle(1,p2);SetColor(p2);end;
          FillEllipse(lqd(lx1),lqd(ly1),2,2);
          FillEllipse(lqd(lx2),lqd(ly2),2,2);
        end
        else begin
          if wj=2
            then begin SetFillStyle(1,p2);SetColor(p2);end
            else begin SetFillStyle(1,p1);SetColor(p1);end;
          FillEllipse(lqd(lx1),lqd(ly1),2,2);
          bj:=false
        end
end;
procedure draw(f:integer);
var s1,s2:string;
begin
    if wj=1
      then SetColor(c1)
      else SetColor(c2);
    SetFillStyle(1,black);
    bar(WMaxY+10,10,WMaxY+150,86);
    if wj=1
     then
        begin
          OutTextXY(WMaxY+15,20,'   Player 1 (   )');
          hqz(WMaxY+130,20,8,p1,1);
          SetColor(c1);
        end
      else
        begin
          OutTextXY(WMaxY+15,20,'   Player 2 (   )');
          hqz(WMaxY+130,20,8,p2,1);
          SetColor(c2);
        end;
    OutTextXY(WMaxY+15,40,'x1:');
    OutTextXY(WMaxY+15,50,'y1:');
    OutTextXY(WMaxY+15,60,'x2:');
    OutTextXY(WMaxY+15,70,'y2:');
    if f=1 then
      begin
        str(x,s1);str(y,s2);
        SetColor(white);
        OutTextXY(WMaxY+50,40,s1);
        OutTextXY(WMaxY+50,50,s2);
      end;
end;
function check6(x,y:integer;a:arr):boolean;
var x1,y1,x2,y2,f:integer;
begin
    x1:=x;y1:=y;f:=a[x,y];
    while (x1>1)and(y1>1)and(a[x1-1,y1-1]=f)do begin dec(x1);dec(y1);end;
    x2:=x;y2:=y;
    while (x2<max)and(y2<max)and(a[x2+1,y2+1]=f)do begin inc(x2);inc(y2);end;
    if y2-y1>4 then begin wx1:=x1;wy1:=y1;wx2:=x2;wy2:=y2;exit(true);end;
    x1:=x;y1:=y;
    while (x1>1)and(y1<max)and(a[x1-1,y1+1]=f)do begin dec(x1);inc(y1);end;
    x2:=x;y2:=y;
    while (x2<max)and(y2>1)and(a[x2+1,y2-1]=f)do begin inc(x2);dec(y2);end;
    if y1-y2>4 then begin wx1:=x1;wy1:=y1;wx2:=x2;wy2:=y2;exit(true);end;
    x1:=x;x2:=x;
    while (x1>1)and(a[x1-1,y]=f)do dec(x1);
    while (x2<max)and(a[x2+1,y]=f)do inc(x2);
    if x2-x1>4 then begin wx1:=x1;wy1:=y;wx2:=x2;wy2:=y;exit(true);end;
    y1:=y;y2:=y;
    while (y1>1)and(a[x,y1-1]=f)do dec(y1);
    while (y2<max)and(a[x,y2+1]=f)do inc(y2);
    if y2-y1>4 then begin wx1:=x;wy1:=y1;wx2:=x;wy2:=y2;exit(true);end;
    exit(false);
end;
function IsDeuce:boolean;
var t:array[1..MaxSize,1..MaxSize]of integer;
    i,j:integer;
begin
    t:=a;
    for i:=1 to max do
      for j:=1 to max do
        begin
          if t[i,j]=0
            then t[i,j]:=1;
          if check6(i,j,t)
            then exit(false);
        end;
    t:=a;
    for i:=1 to max do
      for j:=1 to max do
        begin
          if t[i,j]=0
            then t[i,j]:=2;
          if check6(i,j,t)
            then exit(false);
        end;
    exit(true)
end;
procedure win;
var c:PChar;s:string;
begin
     SetFillStyle(1,black);
     bar(WMaxY+10,10,WMaxX-10,90);
     SetColor(lightred);
     if not deuce then
       begin
         SetLineStyle(0,2,3);
         line(lqd(wx1),lqd(wy1),lqd(wx2),lqd(wy2));
         SetLineStyle(0,2,1);
       end;
     if deuce then begin c:='Deuce!!!';s:=c;end
        else if wj=1
           then begin inc(s1);c:='Player 1 wins!!!';s:=c;end
           else begin inc(s2);c:='Player 2 wins!!!';s:=c;end;
     OutTextXY(WMaxY+15,30,s);
     if MessageBox(GraphWindow,'再玩一局?',c,
                   MB_IconQuestion or MB_YesNo)=IdYes
        then
          begin
            repeat
              GetMouseState(mx,my,ms);
            until ms=0;
            exit
          end
        else halt
end;
begin
   {$ifndef Win32}
     exit;
   {$endif}
   f:=0;
start:init(f);
   if not jmp
     then first;
   repeat
  l1:bj:=true;draw(0);
 lt1:SetFillStyle(1,black);
     bar(WMaxY+50,40,WMaxY+120,56);
     repeat
        if KeyPressed then
          begin
            repeat
              SetFillStyle(1,black);
              bar(WMaxY+50,37,WMaxX,46);
              GRead(x,WMaxY+50,40,2);
              if mouse=1 then break;
              if undo and(x1<>0)and(y1<>0)then
                begin clear(x1,y1,1);goto l2;end;
            until (x>0)and(x<=max);
            while not KeyPressed do
              begin
                GetMouseState(mx,my,ms);
                if (f>0)and(ms>0) then begin mouse:=1;break;end;
              end;
            if mouse=1 then begin mouse:=0;break;end;
            repeat
              SetFillStyle(1,black);
              bar(WMaxY+50,47,WMaxX,56);
              GRead(y,WMaxY+50,50,2);
              if mouse=1 then break;
              if undo and(x1<>0)and(y1<>0)then
                begin clear(x1,y1,1);goto l2;end;
            until (y>0)and(y<=max);
            if mouse=1 then begin mouse:=0;break;end;
            if a[x,y]>0 then goto lt1;
            break;
          end;
        GetMouseState(mx,my,ms);
     until ms>0;
     if ms>0 then
       begin
         if (mx>WMaxX-101)and(mx<WMaxX-10)and(my<WMaxY-20)then
           begin
             if my>WMaxY-35 then ext else
             if my>WMaxY-50 then help else
             if my>WMaxY-65 then
                begin delay(156);clear(x1,y1,1);goto l2;end else
             if my>WMaxY-89 then
                if mx<WMaxX-45 then FangDa else SuoXiao else
             begin
               lzbs:=not lzbs;
               HuaQiPan;
             end;
             delay(156);goto l1;
           end;
         x:=round((mx-30)/g+1);
         y:=round((my-30)/g+1);
         if (x>max)or(x<1)or(y>max)or(y<1)or(a[x,y]>0)
           then begin delay(156);goto lt1;end;
         SetColor(White);
         str(x,s);OutTextXY(WMaxY+50,40,s);
         str(y,s);OutTextXY(WMaxY+50,50,s);
       end;
     a[x,y]:=wj;
     inc(t);b[x,y]:=t;
     if wj=1
        then hqz(lqd(x),lqd(y),q,p1,0)
        else hqz(lqd(x),lqd(y),q,p2,0);
     if check6(x,y,a) then begin win;goto start;end;
     if IsDeuce then
       begin
          deuce:=true;win;
          goto start;
       end;

  l2:draw(1);
 lt2:SetFillStyle(1,black);
     bar(WMaxY+50,60,WMaxY+120,76);
     repeat
        if KeyPressed then
          begin
            repeat
              SetFillStyle(1,black);
              bar(WMaxY+50,57,WMaxX,66);
              GRead(x1,WMaxY+50,60,2);
              if mouse=1 then break;
              if undo then
                begin clear(x,y,0);goto l1;end;
            until (x1>0)and(x1<=max);
            while not KeyPressed do
              begin
                GetMouseState(mx,my,ms);
                if (f>0)and(ms>0) then begin mouse:=1;break;end;
              end;
            if mouse=1 then begin mouse:=0;break;end;
            repeat
              SetFillStyle(1,black);
              bar(WMaxY+50,67,WMaxX,76);
              GRead(y1,WMaxY+50,70,2);
              if mouse=1 then break;
              if undo then
                begin clear(x,y,0);goto l1;end;
            until (y1>0)and(y1<=max);
            if mouse=1 then begin mouse:=0;break;end;
            if a[x1,y1]>0 then goto lt2;
            break;
          end;
        GetMouseState(mx,my,ms);
     until ms>0;
     if ms>0 then
       begin
         if (mx>WMaxX-101)and(mx<WMaxX-10)and(my<WMaxY-20)then
           begin
             if my>WMaxY-35 then ext else
             if my>WMaxY-50 then help else
             if my>WMaxY-65 then
                begin delay(156);clear(x,y,0);goto l1;end else
             if my>WMaxY-89 then
                if mx<WMaxX-45 then FangDa else SuoXiao else
             begin
               lzbs:=not lzbs;
               HuaQiPan;
             end;
             delay(156);goto l2;
           end;
         x1:=round((mx-30)/g+1);
         y1:=round((my-30)/g+1);
         if (x1>max)or(x1<1)or(y1>max)or(y1<1)or(a[x1,y1]>0)
           then begin delay(156);goto lt2;end;
         SetColor(White);
         str(x1,s);OutTextXY(WMaxY+50,60,s);
         str(y1,s);OutTextXY(WMaxY+50,70,s);
         delay(300);
       end;
     a[x1,y1]:=wj;
     inc(t);b[x1,y1]:=t;
     if wj=1
        then hqz(lqd(x1),lqd(y1),q,p1,0)
        else hqz(lqd(x1),lqd(y1),q,p2,0);
     if check6(x1,y1,a) then begin win;goto start;end;
     if IsDeuce then
       begin
          deuce:=true;win;
          goto start;
       end;

     if not lzbs then
       begin
        SetFillStyle(1,red);SetColor(red);
        FillEllipse(lqd(x1),lqd(y1),2,2);
        FillEllipse(lqd(x),lqd(y),2,2);
       end;
     if wj=1
       then begin SetFillStyle(1,p2);SetColor(p2);end
       else begin SetFillStyle(1,p1);SetColor(p1);end;
     if bj and(not lzbs) then
       begin
         FillEllipse(lqd(lx1),lqd(ly1),2,2);
         if t<>3 then
           FillEllipse(lqd(lx2),lqd(ly2),2,2);
       end;
     lx1:=x;ly1:=y;lx2:=x1;ly2:=y1;
     if wj=2
        then wj:=1
        else wj:=2;
   until false
end.
