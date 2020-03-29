{$APPTYPE GUI}
{$INLINE ON}
program Tetris;

uses Windows,Graph,WinMouse,DOS,WinCRT;

const pixel=25;
      colors:array[1..7]of integer
            =(LightGray,green,brown,LightRed,LightBlue,magenta,LightMagenta);
      base:array[1..7,1..4,1..4]of integer=
       (((1,0,0,0),(1,0,0,0),(1,0,0,0),(1,0,0,0)),
        ((1,1,0,0),(1,0,0,0),(1,0,0,0),(0,0,0,0)),
        ((1,0,0,0),(1,0,0,0),(1,1,0,0),(0,0,0,0)),
        ((1,0,0,0),(1,1,0,0),(1,0,0,0),(0,0,0,0)),
        ((1,0,0,0),(1,1,0,0),(0,1,0,0),(0,0,0,0)),
        ((1,1,0,0),(0,1,1,0),(0,0,0,0),(0,0,0,0)),
        ((1,1,0,0),(1,1,0,0),(0,0,0,0),(0,0,0,0)));

type RkRec=record sc,y,m,d:longint;end;

var x,y,dy:integer;
    MaxLv,level,score,row,TRow,TotRank:longint;
    mx,my,ms:longint;
    LTime,CTime:dword;
    blocks:array[1..7,1..4,1..4,1..4]of integer;
    PlayField:array[1..10,-3..15]of integer;
    RankList:array[1..10]of RkRec;
    tm:array[1..20]of dword;
    IsLine:boolean;
    NextBlock,CurBlock:record k,r:integer;end;

procedure GetMouseState(var mx,my,ms:longint);inline;
begin
    WinMouse.GetMouseState(mx,my,ms);
    if FindWindow(nil,'Tetris')=0 then halt;
end;

function ReadKey():char;inline;
begin
    ReadKey:=WinCRT.ReadKey();
    if FindWindow(nil,'Tetris')=0 then halt;
end;

function GetForegroundWindow():dword;inline;
begin
    GetForegroundWindow:=Windows.GetForegroundWindow();
    if FindWindow(nil,'Tetris')=0 then halt;
end;

procedure WaitMouseUp();
begin
    repeat
       GetMouseState(mx,my,ms);
    until ms=0;
end;

procedure InitData();
begin
    IsLine:=false;
    score:=0;
    row:=0;TRow:=0;
    FillChar(PlayField,sizeof(PlayField),0);
end;

procedure WriteLine(s:string);
begin
    if FindWindow(nil,'Tetris')=0 then halt;
    SetColor(yellow);
    SetTextStyle(1,4,2);
    if IsLine
      then begin
             OutTextXY(15,415,s);
             IsLine:=false;
           end
      else begin
             SetFillStyle(1,black);
             bar(10,390,260,435);
             OutTextXY(15,395,s);
             IsLine:=true;
           end;
end;

procedure DrawButton(l,u,r,d,color:integer;s:string;ButtonClicked:boolean);
var red,g,b:integer;
begin
    SetFillStyle(1,color);
    bar(l,u,r,d);
    GetRGBPalette(color,red,g,b);
    if red<20 then red:=0 else dec(red,20);
    if g<20 then g:=0 else dec(g,20);
    if b<20 then b:=0 else dec(b,20);
    SetRGBPalette(16,red,g,b);
    SetFillStyle(1,16);
    if ButtonClicked
      then begin
             bar(l,u,r,u+4);
             bar(l,u,l+4,d);
           end
      else begin
             bar(r-4,u,r,d);
             bar(l,d-4,r,d);
           end;
    if red>215 then red:=255 else inc(red,40);
    if g>215 then g:=255 else inc(g,40);
    if b>215 then b:=255 else inc(b,40);
    SetRGBPalette(16,red,g,b);
    SetFillStyle(1,16);
    if not ButtonClicked
      then begin
              bar(l,u,r,u+4);
              bar(l,u,l+4,d);
           end
      else begin
             bar(r-4,u,r,d);
             bar(l,d-4,r,d);
           end;
    SetFillStyle(1,color);
    SetColor(color);
    bar(r-4,u,r,u+4);
    bar(l,d-4,l+4,d);
    if ButtonClicked
      then SetColor(LightGray)
      else SetColor(white);
    SetTextStyle(1,4,2);
    OutTextXY((r-l-TextWidth(s))>>1+l,(d-u-TextHeight(s))>>1+u,s);
end;

procedure DrawBlock(x,y,rot,BNum,f:integer);
var i,j,l,r,u,d:integer;
begin
    for i:=1 to 4 do
      for j:=1 to 4 do
        if (blocks[BNum,i,j,rot]=1)and(y+(j-1)*pixel+1>=10) then
          begin
             l:=x+(i-1)*pixel+1;
             r:=x+i*pixel-1;
             u:=y+(j-1)*pixel+1;
             d:=y+j*pixel-1;
             case f of
               0:DrawButton(l,u,r,d,colors[BNum],'',false);
               1:begin
                      SetRGBPalette(16,64,96,64);
                      SetFillStyle(1,16);
                      bar(l,u,r,d);
                 end;
               2:begin
                      SetRGBPalette(16,32,64,32);
                      SetFillStyle(1,16);
                      bar(l,u,r,d);
                 end;
             end;
          end;
end;

procedure ranking();
var i:longint;
    st,s1,s2:string;
begin
    DrawButton(100,350,300,400,red,'Ranking',true);
    WaitMouseUp();
    SetFillStyle(1,LightGreen);
    SetColor(black);
    bar(1,1,400,550);
    SetTextStyle(1,4,4);
    OutTextXY((400-TextWidth('a')*7)>>1,40,'Ranking');
    SetColor(red);
    OutTextXY((400-TextWidth('a')*7)>>1-3,43,'Ranking');
    SetColor(green);
    SetTextStyle(1,4,2);
    for i:=1 to 11 do
      line(10,44*i+36,390,44*i+36);
    line(10,80,10,520);
    line(390,80,390,520);
    for i:=1 to TotRank do
      with RankList[i] do begin
        str(i,st);
        SetColor(black);
        OutTextXY(15,44*i+54,st);
        SetColor(blue);
        str(y,st);
        str(m,s1);
        if length(s1)<2 then s1:='0'+s1;
        str(d,s2);
        if length(s2)<2 then s2:='0'+s2;
        st:=st+'/'+s1+'/'+s2;
        OutTextXY(230,44*i+54,st);
        SetColor(red);
        str(sc:5,st);
        OutTextXY(100,44*i+54,st);
      end;
    SetColor(black);
    for i:=TotRank+1 to 10 do
      begin
        str(i,st);
        OutTextXY(15,44*i+54,st);
      end;
    DrawButton(10,30,55,75,green,#27,false);
    repeat
       GetMouseState(mx,my,ms);
    until (ms>0)and(mx>10)and(my>30)and(mx<55)and(my<75);
    DrawButton(10,30,55,75,green,#27,true);
    WaitMouseUp();
end;

procedure ShowMenu();
var s:string;c:char;
begin
    SetFillStyle(1,LightGreen);
    bar(1,1,400,550);
    SetTextStyle(1,4,7);
    SetColor(black);
    OutTextXY((400-6*TextWidth('a'))>>1,50,'TETRIS');
    OutTextXY((400-6*TextWidth('a'))>>1+3,53,'TETRIS');
    DrawButton(100,200,300,260,blue,'',false);
    DrawButton(100,260,300,300,blue,'Play',false);
    str(MaxLv,s);
    SetColor(white);
    SetTextStyle(1,4,2);
    OutTextXY(110,205,'Level(1~'+s+'):');
    SetFillStyle(1,white);
    bar(110,230,290,250);
    DrawButton(100,350,300,400,red,'Ranking',false);
    SetFillStyle(1,white);
    SetColor(black);
    SetTextStyle(1,4,1);
    s:='';
    repeat
       if KeyPressed() then
         begin
           c:=ReadKey();
           if c=#27 then halt;
           if c in ['0'..'9'] then s:=s+c;
           OutTextXY(110,240,s);
           if c=#13 then
             begin
               val(s,level);
               if (level<1)or(level>MaxLv) then
                 begin
                   bar(110,230,290,250);
                   s:='';continue;
                 end;
               DrawButton(100,260,300,300,blue,'Play',true);
               WaitMouseUp();exit;
             end;
           if (c=#8)and(length(s)>0) then
             begin
               delete(s,length(s),1);
               bar(110,230,290,250);
               OutTextXY(110,240,s);
             end;
         end;
       GetMouseState(mx,my,ms);
       if (ms>0)and(mx>100)and(mx<300)and(my>260)and(my<300) then
          begin
            val(s,level);
            if (level<1)or(level>MaxLv) then
               begin
                  bar(110,230,290,250);
                  s:='';continue;
               end;
            DrawButton(100,260,300,300,blue,'Play',true);
            WaitMouseUp();exit;
          end;
       if (ms>0)and(mx>100)and(mx<300)and(my>350)and(my<400)then
         begin ranking();ShowMenu();exit;end;
    until false;
end;

procedure init();
var f:text;s:PathStr;t:extended;
    BNum,i,j,rot,maxj,mini:integer;
begin
    randomize;
    tm[1]:=1280;t:=tm[1];
    for i:=2 to 20 do
      begin t:=t/8*7;tm[i]:=round(t);end;
    InitGraph(x,y,'');
    SetWindowText(GraphWindow,'Tetris');
    SetWindowPos(GraphWindow,HWnd_Top,(GetMaxX-416)>>1,0,416,588,0);
    s:=FSearch('tetlevel','');
    if s='' then
      begin
        assign(f,'tetlevel');
        rewrite(f);
        write(f,1);close(f);
      end;
    assign(f,'tetlevel');reset(f);
    read(f,MaxLv);
    close(f);
    s:=FSearch('tetrank','');
    if s='' then
      begin
        assign(f,'tetrank');
        rewrite(f);
        writeln(f,0);close(f);
      end;
    assign(f,'tetrank');reset(f);
    read(f,TotRank);
    for i:=1 to TotRank do
      with RankList[i] do
        read(f,sc,y,m,d);
    close(f);
    for BNum:=1 to 7 do
      for i:=1 to 4 do
        for j:=1 to 4 do
         begin
           blocks[BNum,i,j,1]:=base[BNum,i,j];
           blocks[BNum,i,j,2]:=base[BNum,5-j,i];
           blocks[BNum,i,j,3]:=base[BNum,5-i,5-j];
           blocks[BNum,i,j,4]:=base[BNum,j,5-i];
         end;
    for BNum:=1 to 7 do
      for rot:=1 to 4 do
        begin
           maxj:=-1;
           for j:=4 downto 1 do
             begin
               for i:=1 to 4 do
                 if blocks[BNum,i,j,rot]=1
                    then begin maxj:=j;break;end;
               if maxj>0 then break;
             end;
           for j:=maxj downto 1 do
             for i:=1 to 4 do
               blocks[BNum,i,4-maxj+j,rot]:=blocks[BNum,i,j,rot];
           for i:=1 to 4 do
             for j:=1 to 4-maxj do
               blocks[BNum,i,j,rot]:=0;
           mini:=-1;
           for i:=1 to 4 do
             begin
               for j:=1 to 4 do
                 if blocks[BNum,i,j,rot]=1
                    then begin mini:=i;break;end;
               if mini>0 then break;
             end;
           for i:=mini to 4 do
             for j:=1 to 4 do
               blocks[BNum,i-mini+1,j,rot]:=blocks[BNum,i,j,rot];
           for i:=6-mini to 4 do
             for j:=1 to 4 do
               blocks[BNum,i,j,rot]:=0;
        end;
end;

procedure DrawDArrow(d:integer);
var tmp:array[1..10]of record x,y:integer;end;
begin
    SetRGBPalette(16,0,96,0);
    tmp[1].x:=218+d;tmp[1].y:=460+d;
    tmp[2].x:=253+d;tmp[2].y:=530+d;
    tmp[3].x:=288+d;tmp[3].y:=460+d;
    tmp[4].x:=273+d;tmp[4].y:=460+d;
    tmp[5].x:=253+d;tmp[5].y:=500+d;
    tmp[6].x:=233+d;tmp[6].y:=460+d;
    tmp[7]:=tmp[1];
    SetColor(green);
    SetFillStyle(1,green);
    FillPoly(7,tmp);
    tmp[4].x:=281+d;tmp[4].y:=464+d;
    tmp[5].y:=519+d;
    tmp[6].x:=225+d;tmp[6].y:=464+d;
    SetColor(16);
    SetFillStyle(1,16);
    FillPoly(7,tmp);
end;

procedure DrawRArrow(d:integer);
var tmp:array[1..10]of record x,y:integer;end;
begin
    SetRGBPalette(16,0,96,0);
    tmp[1].x:=118+d;tmp[1].y:=460+d;
    tmp[2].x:=183+d;tmp[2].y:=495+d;
    tmp[3].x:=118+d;tmp[3].y:=530+d;
    tmp[4].x:=118+d;tmp[4].y:=515+d;
    tmp[5].x:=158+d;tmp[5].y:=495+d;
    tmp[6].x:=118+d;tmp[6].y:=475+d;
    tmp[7]:=tmp[1];
    SetColor(green);
    SetFillStyle(1,green);
    FillPoly(7,tmp);
    tmp[4].x:=120+d;tmp[4].y:=523+d;
    tmp[5].x:=174+d;
    tmp[6].x:=120+d;tmp[6].y:=467+d;
    SetColor(16);
    SetFillStyle(1,16);
    FillPoly(7,tmp);
end;

procedure DrawLArrow(d:integer);
var tmp:array[1..10]of record x,y:integer;end;
begin
    SetRGBPalette(16,0,96,0);
    tmp[1].x:=83+d;tmp[1].y:=460+d;
    tmp[2].x:=18+d;tmp[2].y:=495+d;
    tmp[3].x:=83+d;tmp[3].y:=530+d;
    tmp[4].x:=83+d;tmp[4].y:=515+d;
    tmp[5].x:=43+d;tmp[5].y:=495+d;
    tmp[6].x:=83+d;tmp[6].y:=475+d;
    tmp[7]:=tmp[1];
    SetColor(16);
    SetFillStyle(1,16);
    FillPoly(7,tmp);
    tmp[4].x:=80+d;tmp[4].y:=520+d;
    tmp[5].x:=33+d;
    tmp[6].x:=80+d;tmp[6].y:=470+d;
    SetColor(green);
    SetFillStyle(1,green);
    FillPoly(7,tmp);
end;

procedure DrawRotArrow(d:integer);
var tmp:array[1..10]of record x,y:integer;end;
begin
    SetRGBPalette(16,0,96,0);
    SetColor(green);
    SetFillStyle(1,green);
    sector(348+d,495+d,30,160,32,35);
    sector(348+d,495+d,210,340,32,35);
    SetFillStyle(1,16);
    sector(348+d,495+d,30,160,26,29);
    sector(348+d,495+d,210,340,26,29);
    SetColor(LightGreen);
    SetFillStyle(1,LightGreen);
    FillEllipse(348+d,495+d,19,22);
    tmp[1].x:=363+d;tmp[1].y:=489+d;
    tmp[2].x:=379+d;tmp[2].y:=490+d;
    tmp[3].x:=375+d;tmp[3].y:=468+d;
    tmp[4]:=tmp[1];
    SetFillStyle(1,green);
    SetColor(green);
    FillPoly(4,tmp);
    tmp[3].x:=367+d;tmp[3].y:=475+d;
    SetFillStyle(1,16);
    SetColor(16);
    FillPoly(4,tmp);
    tmp[1].x:=333+d;tmp[1].y:=501+d;
    tmp[2].x:=317+d;tmp[2].y:=500+d;
    tmp[3].x:=321+d;tmp[3].y:=522+d;
    tmp[4]:=tmp[1];
    SetFillStyle(1,green);
    SetColor(green);
    FillPoly(4,tmp);
    tmp[3].x:=329+d;tmp[3].y:=515+d;
    SetFillStyle(1,16);
    SetColor(16);
    FillPoly(4,tmp);
end;

procedure DrawPlayField();
var i:integer;s:string;
begin
    SetFillStyle(1,LightGreen);
    bar(1,1,400,550);
    SetFillStyle(1,Green);
    bar(5,5,265,440);
    bar(275,5,385,115);
    SetRGBPalette(16,32,64,32);
    SetFillStyle(1,16);
    bar(10,10,260,385);
    bar(280,10,380,110);
    SetColor(black);
    for i:=2 to 15 do
      line(10,i*pixel-15,260,i*pixel-15);
    for i:=2 to 10 do
      line(i*pixel-15,10,i*pixel-15,385);
    for i:=2 to 4 do
      line(280,i*pixel-15,380,i*pixel-15);
    for i:=2 to 4 do
      line(i*pixel+255,10,i*pixel+255,110);
    SetTextStyle(1,4,1);
    OutTextXY(290,160,'Level');
    OutTextXY(290,245,'Score');
    OutTextXY(290,330,'Row');
    SetTextStyle(1,4,2);
    SetColor(red);
    str(level:5,s);
    OutTextXY(280,185,s);
    InitData();
    OutTextXY(280,270,'    0');
    OutTextXY(280,355,'    0');
    SetFillStyle(1,black);
    bar(10,390,260,435);
    DrawButton(280,390,385,435,red,'PAUSE',false);
    DrawLArrow(0);DrawRArrow(0);
    DrawDArrow(0);DrawRotArrow(0);
    WriteLine('3');
    delay(1000);
    WriteLine('2');
    delay(1000);
    WriteLine('1');
    delay(1000);
    WriteLine('START');
end;

function GameOver():integer;
var s:string;f:text;
    tmp,i,j,find:integer;last:RkRec;
    year,month,day,dw:word;
begin
    WriteLine('GAME OVER');
    delay(1000);
    SetFillStyle(1,LightGreen);
    bar(1,1,400,550);
    SetColor(black);
    SetTextStyle(1,4,4);
    OutTextXY((400-9*TextWidth('a'))>>1,40,'Game Over');
    SetColor(red);
    OutTextXY((400-9*TextWidth('a'))>>1-3,43,'Game Over');
    SetColor(black);
    SetTextStyle(1,4,2);
    OutTextXY(30,120,'Current level  :');
    OutTextXY(30,170,'Destroyed rows :');
    OutTextXY(30,220,'Score          :');
    SetColor(blue);
    str(level:5,s);
    tmp:=30+17*TextWidth('a');
    OutTextXY(tmp,120,s);
    str(row:5,s);
    OutTextXY(tmp,170,s);
    str(score:5,s);
    OutTextXY(tmp,220,s);
    find:=0;
    for i:=TotRank downto 1 do
      if RankList[i].sc>score
        then begin find:=1;break;end;
    if (i<>TotRank)or(TotRank<10) then
      begin
        if find=0 then i:=1 else inc(i);
        if TotRank in [1..9] then last:=RankList[TotRank];
        for j:=TotRank-1 downto i do
          RankList[j+1]:=RankList[j];
        if TotRank in [1..9] then
          begin inc(TotRank);RankList[TotRank]:=last;end;
        if TotRank=0 then TotRank:=1;
        with RankList[i] do
          begin
            GetDate(year,month,day,dw);
            y:=year;m:=month;d:=day;
            sc:=score;
          end;
        SetColor(black);
        OutTextXY(30,270,'Rank           :');
        SetColor(blue);
        str(i:5,s);
        OutTextXY(30+17*TextWidth('a'),270,s);
        assign(f,'tetrank');
        rewrite(f);
        WriteLn(f,TotRank);
        for i:=1 to TotRank do
           with RankList[i] do
             WriteLn(f,sc,' ',y,' ',m,' ',d);
        close(f);
      end;
    DrawButton(50,320,170,370,green,'Restart',false);
    DrawButton(230,320,350,370,green,'Menu',false);
    repeat
      GetMouseState(mx,my,ms);
    until (ms>0)and(my>320)and(my<370)and
          ((mx>50)and(mx<170) or (mx>230)and(mx<350));
    InitData();
    if mx<200
      then begin
             DrawButton(50,320,170,370,green,'Restart',true);
             WaitMouseUp();exit(0);
           end
      else begin
             DrawButton(230,320,350,370,green,'Menu',true);
             WaitMouseUp();exit(1);
           end;
end;

function pause():integer;
var ly:integer;
    s:string;

    procedure WriteTitle();
    begin
        OutTextXY(300,260,'Resume');
        OutTextXY(300,310,'Restart');
        OutTextXY(300,360,'Menu');
    end;

    procedure resume();
    begin
        SetFillStyle(1,LightGreen);
        bar(280,240,385,390);
        SetColor(black);
        SetTextStyle(1,4,1);
        OutTextXY(290,245,'Score');
        OutTextXY(290,330,'Row');
        SetTextStyle(1,4,2);
        SetColor(red);
        str(score:5,s);
        OutTextXY(280,270,s);
        str(row:5,s);
        OutTextXY(280,355,s);
        DrawButton(280,390,385,435,red,'PAUSE',false);
        LTime:=GetTickCount();
    end;

begin
    DrawButton(280,390,385,435,red,'PAUSE',true);
    SetFillStyle(1,LightGray);
    SetColor(black);
    bar(280,240,385,390);
    rectangle(280,240,385,390);
    line(280,290,385,290);
    line(280,340,385,340);
    SetTextStyle(1,4,1);
    WriteTitle();
    repeat
      GetMouseState(mx,my,ms);
    until ms=0;
    ly:=0;
    repeat
      GetMouseState(mx,my,ms);
      if (mx>280)and(mx<385)and(my>240)and(my<390)then
        begin
          SetFillStyle(1,DarkGray);
          case my>>1 of
             120..145:if (ly<240)or(ly>290) then
               begin
                 bar(281,241,384,289);
                 SetFillStyle(1,LightGray);
                 bar(281,291,384,339);
                 bar(281,341,384,389);
                 WriteTitle();ly:=my;
               end;
             146..170:if (ly<290)or(ly>340) then
               begin
                 bar(281,291,384,339);
                 SetFillStyle(1,LightGray);
                 bar(281,241,384,289);
                 bar(281,341,384,389);
                 WriteTitle();ly:=my;
               end;
             171..195:if ly<340 then
               begin
                 bar(281,341,384,389);
                 SetFillStyle(1,LightGray);
                 bar(281,291,384,339);
                 bar(281,241,384,289);
                 WriteTitle();ly:=my;
               end;
          end;
        end;
    until ms>0;
    if (mx>280)and(mx<385)and(my>240)and(my<390) then
        case my>>1 of
            120..145:begin resume();exit(0);end;
            146..170:exit(1);
            171..195:exit(2);
        end else begin WaitMouseUp();resume();exit(0)end;
end;

function GetDY(k,x,r:integer):integer;
var i,min,max,ix:integer;
begin
    GetDY:=12;
    for ix:=1 to 4 do
      if x+ix<12 then
        begin
          min:=16;max:=-MaxInt;
          for i:=1 to 15 do
            if PlayField[x+ix-1,i]>0
               then begin min:=i;break;end;
          for i:=4 downto 1 do
            if blocks[k,ix,i,r]=1
               then begin max:=i;break;end;
          if min-max<GetDY
            then GetDY:=min-max;
        end;
end;

procedure GetDY();
begin
    with CurBlock do
      begin
        dy:=GetDY(k,x,r);
        DrawBlock(10+pixel*(x-1),10+pixel*(dy-1),r,k,1);
      end;
end;

procedure left();
var ty:integer;
begin
if x>1 then with CurBlock do
  begin
    ty:=GetDY(k,x-1,r);
    if ty<y then exit;
    DrawBlock(10+pixel*(x-1),10+pixel*(dy-1),r,k,2);
    DrawBlock(10+pixel*(x-1),10+pixel*(y-1),r,k,2);
    dec(x);dy:=ty;
    DrawBlock(10+pixel*(x-1),10+pixel*(dy-1),r,k,1);
    DrawBlock(10+pixel*(x-1),10+pixel*(y-1),r,k,0);
  end;
end;

procedure right();
var t,i,j,ty:integer;
begin
with CurBlock do
  begin
    t:=0;
    for i:=1 to 4 do
      for j:=1 to 4 do
        if (blocks[k,i,j,r]=1)and(i>t)
           then t:=i;
    ty:=GetDY(k,x+1,r);
    if (x+t>10)or(ty<y) then exit;
    DrawBlock(10+pixel*(x-1),10+pixel*(dy-1),r,k,2);
    DrawBlock(10+pixel*(x-1),10+pixel*(y-1),r,k,2);
    inc(x);dy:=ty;
    DrawBlock(10+pixel*(x-1),10+pixel*(dy-1),r,k,1);
    DrawBlock(10+pixel*(x-1),10+pixel*(y-1),r,k,0);
  end;
end;

procedure rotate();
var t,i,j,ty,tr,tx:integer;
begin
with CurBlock do
  begin
    t:=0;tr:=r;
    if r=1 then r:=4 else dec(r);
    for i:=1 to 4 do
      for j:=1 to 4 do
        if (blocks[k,i,j,r]=1)and(i>t)
           then t:=i;
    ty:=GetDY(k,x,r);tx:=x;
    if ty<y then begin r:=tr;exit;end;
    if x+t>11 then
       repeat
         if x=1 then begin x:=tx;r:=tr;exit;end;
         dec(x);
         ty:=GetDY(k,x,r);
         if ty<y then begin x:=tx;r:=tr;exit;end;
       until x+t<12;
    DrawBlock(10+pixel*(tx-1),10+pixel*(dy-1),tr,k,2);
    DrawBlock(10+pixel*(tx-1),10+pixel*(y-1),tr,k,2);
    dy:=ty;
    DrawBlock(10+pixel*(x-1),10+pixel*(dy-1),r,k,1);
    DrawBlock(10+pixel*(x-1),10+pixel*(y-1),r,k,0);
  end;
end;

function FixUpPlayField():integer;
var i,j,k,f,sum:integer;
    s:string;fl:text;
    IsFull:array[-3..15]of boolean;
begin
    FillChar(IsFull,SizeOf(IsFull),false);
    sum:=0;
    for i:=-3 to 15 do
       begin
         f:=0;
         for j:=1 to 10 do
           if PlayField[j,i]=0
             then begin f:=1;break;end;
         if f=0 then
           begin IsFull[i]:=true;inc(sum);end;
       end;
    inc(row,sum);inc(TRow,sum);
    case sum of
      1:inc(score,100);
      2:begin WriteLine('Good');inc(score,240);end;
      3:begin WriteLine('Excellent');inc(score,420);end;
      4:begin WriteLine('Perfect');inc(score,640);end;
    end;
    if (TRow>24)and(level<20) then
      begin
        inc(level);
        TRow:=TRow mod 25;
        WriteLine('Level Up');
        if level>MaxLv then
          begin
            MaxLv:=level;
            assign(fl,'tetlevel');
            rewrite(fl);
            write(fl,MaxLv);close(fl);
          end;
      end;
    if sum>0 then
      begin
        SetFillStyle(1,LightGreen);
        bar(280,155,385,390);
        SetTextStyle(1,4,1);
        SetColor(black);
        OutTextXY(290,160,'Level');
        OutTextXY(290,245,'Score');
        OutTextXY(290,330,'Row');
        SetTextStyle(1,4,2);
        SetColor(red);
        str(level:5,s);
        OutTextXY(280,185,s);
        str(score:5,s);
        OutTextXY(280,270,s);
        str(row:5,s);
        OutTextXY(280,355,s);
      end;
    j:=15;
    for i:=15 downto -3 do
      if not IsFull[i] then
        begin
          for k:=1 to 10 do
             begin
               PlayField[k,j]:=PlayField[k,i];
               if j>0 then if PlayField[k,j]=0
                 then
                    begin
                      SetRGBPalette(16,32,64,32);
                      SetFillStyle(1,16);
                      bar(11+pixel*(k-1),11+pixel*(j-1),
                          9+pixel*k,9+pixel*j);
                    end
                 else DrawButton(11+pixel*(k-1),11+pixel*(j-1),
                                 9+pixel*k,9+pixel*j,
                                 colors[PlayField[k,j]],'',false);
             end;
          dec(j);
        end;
    for i:=-3 to j do
      for k:=1 to 10 do
        begin
           if i>0 then
             begin
               SetRGBPalette(16,32,64,32);
               SetFillStyle(1,16);
               bar(11+pixel*(k-1),11+pixel*(i-1),
                   9+pixel*k,9+pixel*i);
             end;
           PlayField[k,i]:=0;
        end;
    for i:=1 to 10 do
      if PlayField[i,1]>0 then exit(0);
    exit(1);
end;

function down():integer;
var i,j:integer;
begin
with CurBlock do
  begin
    DrawBlock(10+pixel*(x-1),10+pixel*(y-1),r,k,2);
    DrawBlock(10+pixel*(x-1),10+pixel*(dy-1),r,k,0);
    for i:=1 to 4 do
      for j:=1 to 4 do
        if (blocks[k,i,j,r]=1)and(i+x<12)
          then PlayField[i+x-1,j+dy-1]:=k;
    exit(FixUpPlayField());
  end;
end;

function Down1Pixel():integer;
begin
with CurBlock do
  begin
    if y<dy-1 then
      begin
        DrawBlock(10+pixel*(x-1),10+pixel*(y-1),r,k,2);
        inc(y);
        DrawBlock(10+pixel*(x-1),10+pixel*(y-1),r,k,0);
        exit(2);
      end;
    exit(down());
  end;
end;

function MainLoop():integer;
var d,i:integer;c:char;
    lt:dword;rp:boolean;
begin
    with CurBlock do
      begin
        r:=random(4)+1;k:=random(7)+1;
        x:=5;y:=-2;
        DrawBlock(10+(x-1)*pixel,10+(y-1)*pixel,r,k,0);
      end;
    with NextBlock do
      begin
        r:=random(4)+1;k:=random(7)+1;
        DrawBlock(280,10,r,k,0);
      end;
    GetDY();
    LTime:=GetTickCount();
    repeat
      d:=0;
      GetMouseState(mx,my,ms);
      if (mx>280)and(mx<390)and(my>385)and(my<435)and(ms>0)
         or(GetForegroundWindow()<>GraphWindow)
        then
          begin
            repeat
            until GetForegroundWindow()=GraphWindow;
            case pause() of
              1:exit(1);
              2:exit(2);
            end;
            continue;
          end;
      if ms>0 then
        begin
          SetFillStyle(1,LightGreen);
          if RPressed() then rp:=true else rp:=false;
          if (mx<100)and(my>460)and(my<530)
             then
               begin
                 lt:=GetTickCount();
                 bar(18,460,90,530);
                 DrawLArrow(5);left();
                 repeat
                    GetMouseState(mx,my,ms);
                 until ms=0;
                 if (GetTickCount()-lt>300) or rp
                    then for i:=1 to 9 do left()
                    else delay(15);
                 SetFillStyle(1,LightGreen);
                 bar(18,460,90,540);
                 DrawLArrow(0);
               end else
          if (mx>100)and(mx<200)and(my>460)and(my<530)
             then
               begin
                 lt:=GetTickCount();
                 bar(118,460,190,530);
                 DrawRArrow(5);right();
                 repeat
                    GetMouseState(mx,my,ms);
                 until ms=0;
                 if (GetTickCount()-lt>300) or rp
                    then for i:=1 to 9 do right()
                    else delay(15);
                 SetFillStyle(1,LightGreen);
                 bar(118,460,190,540);
                 DrawRArrow(0);
               end else
          if (mx>200)and(mx<300)and(my>460)and(my<530)
             then
               begin
                 bar(215,460,295,530);
                 DrawDArrow(5);
                 if down()=0 then exit(0);
                 d:=1;
                 SetFillStyle(1,LightGreen);
                 bar(218,460,295,540);
                 DrawDArrow(0);
                 repeat
                    GetMouseState(mx,my,ms);
                 until ms=0;
               end else
          if (mx>300)and(my>460)and(my<530)
             then
               begin
                 bar(318,460,390,530);
                 DrawRotArrow(5);rotate();
                 delay(15);
                 SetFillStyle(1,LightGreen);
                 bar(318,460,390,540);
                 DrawRotArrow(0);
                 repeat
                    GetMouseState(mx,my,ms);
                 until ms=0;
               end;
        end;
      if KeyPressed() then
        begin
          c:=ReadKey();
          case c of
            #27:begin
                  case pause() of
                     1:exit(1);
                     2:exit(2);
                  end;
                  continue;
                end;
            #32:begin if down()=0 then exit(0);d:=1;end;
            #0:begin
                   c:=ReadKey();
                   case c of
                      #72:rotate();
                      #80:case Down1Pixel() of 0:exit(0);1:d:=1;end;
                      #75:left();
                      #77:right();
                   end;
                 end;
          end;
        end;
      if d=0 then
        begin
          CTime:=GetTickCount();
          if CTime-LTime>tm[level] then
            begin
              case Down1Pixel() of
                 0:exit(0);
                 1:d:=1;
              end;
              LTime:=CTime;
            end
        end;
      if d=1 then
        begin
          CurBlock:=NextBlock;
          with CurBlock do
            begin
              x:=5;y:=-2;
              DrawBlock(10+(x-1)*pixel,10+(y-1)*pixel,r,k,0);
            end;
          SetRGBPalette(16,32,64,32);
          SetFillStyle(1,16);
          bar(280,10,380,110);
          SetColor(black);
          for i:=2 to 4 do
             line(280,i*pixel-15,380,i*pixel-15);
          for i:=2 to 4 do
             line(i*pixel+255,10,i*pixel+255,110);
          with NextBlock do
            begin
              r:=random(4)+1;k:=random(7)+1;
              DrawBlock(280,10,r,k,0);
            end;
          GetDY();
          LTime:=GetTickCount();
        end;
    until false;
end;

begin
    init();
    ShowMenu();
    repeat
      DrawPlayField();
      case MainLoop() of
        0:if GameOver()=1 then ShowMenu();
        1:InitData();
        2:begin InitData();ShowMenu();end;
      end;
    until false;
end.
