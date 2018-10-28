{$apptype gui}
{$define PC}
program minesweeper;
uses dos,sysutils,graph,windows,winmouse;
label l;
const px=33;
      {$ifdef beginner}
          r=9;c=9;mnum=10;
      {$else}{$ifdef expert}
          r=16;c=30;mnum=99;
      {$else}
          r=16;c=16;mnum=40;
      {$endif}{$endif}
      wl=px*c;wh=px*r+px*2;
      appname='MineSweeper';
      cl:array[1..8]of longint=(lightblue,green,lightred,blue,brown,cyan,black,16);
var mx,my,ms:longint;time,stime:dword;
    sx,sy,ex,ey,win,m,x,y,bs,s,i,j,go:longint;rf:text;
    flag,map,open:array[0..101,0..101]of longint;
    fpoly:array[1..5]of record x,y:word;end;

procedure outnum(x,num:longint);
var s:string;
begin
  setcolor(black);
  str(num,s);
  if num>=0
     then while length(s)<3 do s:='0'+s
     else while length(s)<3 do insert('0',s,2);
  setfillstyle(1,white);
  bar(x-10,1,x+100,2*px-2);
  outtextxy(x,20,s);
end;

procedure waitmouse;
var t:dword;mx1,my1,ms1:longint;
begin
  repeat
    getmousestate(mx,my,ms);
    t:=gettickcount;
    if t-time>=1000 then
      begin
        time:=t;
        outnum(20,(time-stime) div 1000);
      end;
    if findwindow(nil,appname)=0 then halt;
  until (ms>0)and(mx>0)and(mx<wl)and(my>2*px)and(my<wh);
  {$ifdef PC}
  repeat
    getmousestate(mx1,my1,ms1);
  until ms1=0;
  {$endif}
end;

procedure initgr;
var gd,gm:smallint;
begin
  randomize;
  gd:=0;gm:=0;
  initgraph(gd,gm,'');
  setwindowpos(graphwindow,hwnd_top,0,0,wl+16,wh+38,0);
  setwindowtext(graphwindow,appname);
  if fsearch('msdata','')=''then
    begin
      assign(rf,'msdata');
      rewrite(rf);
      write(rf,'1000000');
      close(rf);
    end;
  assign(rf,'msdata');
  reset(rf);
  read(rf,bs);
  close(rf);
  setrgbpalette(16,192,192,192);
  setrgbpalette(17,160,160,160);
end;

procedure fill(x,y:longint);
begin
  if (map[x,y]>=0)and(flag[x,y]=0) then
     begin
       open[x,y]:=1;
       setfillstyle(1,white);
       bar((x-1)*px+1,(y+1)*px+1,x*px-1,(y+2)*px-1);
       if map[x,y]>0 then
          begin
            setcolor(cl[map[x,y]]);
            outtextxy((x-1)*px+7,(y+1)*px+7,inttostr(map[x,y]));
          end;
     end;
  if (map[x,y]=0)and(flag[x,y]=0) then
     begin
       if (x>1)and(open[x-1,y]=0) then fill(x-1,y);
       if (y>1)and(open[x,y-1]=0) then fill(x,y-1);
       if (x<c)and(open[x+1,y]=0) then fill(x+1,y);
       if (y<r)and(open[x,y+1]=0) then fill(x,y+1);
       if (x>1)and(y>1)and(open[x-1,y-1]=0) then fill(x-1,y-1);
       if (x>1)and(y<r)and(open[x-1,y+1]=0) then fill(x-1,y+1);
       if (x<c)and(y>1)and(open[x+1,y-1]=0) then fill(x+1,y-1);
       if (x<c)and(y<r)and(open[x+1,y+1]=0) then fill(x+1,y+1);
     end;
end;

procedure init;
var h:array[1..100,1..100]of longint;
    i,j,ct,mx1,my1,ms1:longint;
begin
  setfillstyle(1,white);
  bar(1,1,wl,wh);
  setcolor(darkgray);
  for i:=1 to r do
    for j:=1 to c do
      begin
        graph.rectangle((j-1)*px,(i+1)*px,j*px,(i+2)*px);
        setfillstyle(1,16);
        bar((j-1)*px+1,(i+1)*px+1,j*px-1,(i+2)*px-1);
        setfillstyle(1,17);
        bar((j-1)*px+5,(i+1)*px+5,j*px-5,(i+2)*px-5);
      end;
  m:=mnum;
  settextstyle(1,4,3);
  outnum(20,0);
  outnum(wl-20-textwidth('a')*3,m);
  repeat
    getmousestate(mx,my,ms);
    if findwindow(nil,appname)=0 then halt;
  until (ms>0)and(mx>0)and(mx<wl)and(my>2*px)and(my<wh);
  {$ifdef PC}
  repeat
    getmousestate(mx1,my1,ms1);
  until ms1=0;
  {$endif}
  win:=0;
  fillchar(flag,sizeof(flag),0);
  fillchar(h,sizeof(h),0);
  fillchar(map,sizeof(map),0);
  fillchar(open,sizeof(open),0);
  h[mx div px+1,my div px-1]:=1;
  ct:=0;
  while ct<mnum do
    begin
      repeat
        i:=random(c)+1;j:=random(r)+1;
      until h[i,j]=0;
      h[i,j]:=1;inc(ct);
      map[i,j]:=-1;
    end;
  for i:=1 to c do
    for j:=1 to r do
      if map[i,j]=0 then
         map[i,j]:=-min(map[i-1,j-1],0)-min(map[i-1,j],0)-min(map[i-1,j+1],0)
                   -min(map[i,j-1],0)-min(map[i,j+1],0)
                   -min(map[i+1,j-1],0)-min(map[i+1,j],0)-min(map[i+1,j+1],0);
  stime:=gettickcount;
  time:=stime;
  fill(mx div px+1,my div px-1);
end;

procedure gameover(x,y:longint);
var text,bss:string;
begin
  setfillstyle(1,red);
  bar((x-1)*px+1,(y+1)*px+1,x*px-1,(y+2)*px-1);
  if bs=1000000
     then bss:='无'
     else bss:=inttostr(bs)+'秒';
  text:='用时：'+inttostr((time-stime)div 1000)+'秒'#13#10'最佳记录：'+bss;
  text:=text+#13#10'要再来一局吗？';
  if messagebox(graphwindow,@(text[1]),'您输了，下次好运！',
                mb_yesno or mb_iconquestion)=idno
     then halt;
end;

procedure checkwin;
var i,j,t:longint;text,bss:string;
begin
  for i:=1 to c do
    for j:=1 to r do
      if (map[i,j]>=0)and(open[i,j]=0)then exit;
  win:=1;
  t:=(time-stime)div 1000;
  if t<bs then
     begin
       text:='你创造了新的记录！'#13#10;
       bs:=t;
       assign(rf,'msdata');
       rewrite(rf);
       write(rf,t);
       close(rf);
     end
     else text:='';
  if bs=1000000
     then bss:='无'
     else bss:=inttostr(bs)+'秒';
  text:=text+'用时：'+inttostr(t)+'秒'#13#10'最佳记录：'+bss;
  text:=text+#13#10'要再来一局吗？';
  if messagebox(graphwindow,@(text[1]),'恭喜，你成功了！',
                mb_yesno or mb_iconquestion)=idno
     then halt;
end;

begin
  initgr;
  repeat
    init;
  l:waitmouse;
    x:=mx div px+1;y:=my div px-1;
    sx:=(x-1)*px+1;sy:=(y+1)*px+1;
    ex:=x*px-1;ey:=(y+2)*px-1;
    if ms=RButton then
      begin
        if (open[x,y]=1)or(flag[x,y]=1) then goto l;
        if map[x,y]=-1
           then begin gameover(x,y);continue;end
           else fill(x,y);
        checkwin;
        if win=1 then continue;
        goto l;
      end else
      begin
        if open[x,y]=0
           then if flag[x,y]=0 then
                  begin
                    flag[x,y]:=1;
                    dec(m);
                    outnum(wl-20-textwidth('a')*3,m);
                    setcolor(black);
                    setfillstyle(1,lightred);
                    fpoly[1].x:=sx+10;fpoly[1].y:=ey-5;
                    fpoly[2].x:=sx+10;fpoly[2].y:=sy+5;
                    fpoly[3].x:=ex-10;fpoly[3].y:=ey-15;
                    fpoly[4].x:=sx+10;fpoly[4].y:=ey-15;
                    fpoly[5]:=fpoly[1];
                    fillpoly(5,fpoly);
                  end else
                  begin
                    flag[x,y]:=0;
                    inc(m);
                    outnum(wl-20-textwidth('a')*3,m);
                    setfillstyle(1,16);
                    bar(sx,sy,ex,ey);
                    setfillstyle(1,17);
                    bar(sx+4,sy+4,ex-4,ey-4);
                  end
           else begin
                  s:=0;
                  for i:=-1 to 1 do
                    for j:=-1 to 1 do
                      inc(s,flag[x+i,y+j]);
                  if s<>map[x,y] then goto l;
                  go:=0;
                  for i:=-1 to 1 do
                    begin
                      for j:=-1 to 1 do
                        if (x+i>0)and(x+i<=c)and(y+j>0)and(y+j<=r) then
                          begin
                            if (map[x+i,y+j]=-1)and(flag[x+i,y+j]=0)
                               then begin gameover(x+i,y+j);go:=1;break;end;
                            if ((i<>0)or(j<>0))and(flag[x+i,y+j]=0) then fill(x+i,y+j);
                          end;
                      if go=1 then break;
                    end;
                  if go=1 then continue;
                end;
         checkwin;
         if win=1 then continue;
         goto l;
      end;
  until false;
end.
