unit gui;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Windows, setwnd;

type

  { TForm1 }

  TForm1 = class(TForm)
    board: TImage;
    about: TButton;
    stop: TButton;
    opendlg: TOpenDialog;
    savedlg: TSaveDialog;
    setup: TButton;
    quit: TButton;
    newgame: TButton;
    help: TButton;
    redo: TButton;
    undo: TButton;
    save: TButton;
    load: TButton;
    log: TMemo;
    procedure aboutClick(Sender: TObject);
    procedure boardMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure helpClick(Sender: TObject);
    procedure loadClick(Sender: TObject);
    procedure newgameClick(Sender: TObject);
    procedure quitClick(Sender: TObject);
    procedure drawboard;
    procedure saveClick(Sender: TObject);
    procedure setupClick(Sender: TObject);
    procedure stopClick(Sender: TObject);
    procedure xiazi;
    procedure redoClick(Sender: TObject);
    procedure undoClick(Sender: TObject);
    procedure WndProc(var Message:TMessage);override;
  private
    { private declarations }
  public
    { public declarations }
  end;

const brname:string='pbrain-pela.exe';
  bdsize=15;pix=(470-30) div (bdsize-1)-1;
  tmarr:array[0..4]of dword=(2147483647,5000,10000,30000,90000);
  memarr:array[0..2]of dword=(128*1024*1024,1024*1024*1024,0);

var
  Form1: TForm1;
  fc:integer=0;
  bdarr,sxarr:array[-1..bdsize+2,-1..bdsize+2]of longint;
  ds,uds:array[1..1000]of record x,y,p,n:longint;end;
  dsn,udsn,gamefin:integer;
  cgd:boolean=false;justfin:boolean=false;
  sshun:integer=1;hssize:longint=1;ailv:longint=2;

implementation

{$R *.lfm}

function i5(x:longint):boolean;
var i,j:longint;
begin
    for i:=1 to bdsize-4 do
      for j:=1 to bdsize do
        if (bdarr[i,j]=x)and(bdarr[i+1,j]=x)and(bdarr[i+2,j]=x)and(bdarr[i+3,j]=x)and(bdarr[i+4,j]=x)
         or(bdarr[j,i]=x)and(bdarr[j,i+1]=x)and(bdarr[j,i+2]=x)and(bdarr[j,i+3]=x)and(bdarr[j,i+4]=x)
           then exit(true);
    for i:=1 to bdsize-4 do
      for j:=1 to bdsize-4 do
        if (bdarr[i,j]=x)and(bdarr[i+1,j+1]=x)and(bdarr[i+2,j+2]=x)and(bdarr[i+3,j+3]=x)and(bdarr[i+4,j+4]=x)
           then exit(true);
    for i:=5 to bdsize do
      for j:=1 to bdsize-4 do
        if (bdarr[i,j]=x)and(bdarr[i-1,j+1]=x)and(bdarr[i-2,j+2]=x)and(bdarr[i-3,j+3]=x)and(bdarr[i-4,j+4]=x)
           then exit(true);
    exit(false);
end;

function hq:boolean;
var i,j:longint;
begin
    hq:=true;
    for i:=1 to bdsize do
      for j:=1 to bdsize do
         if bdarr[i,j]<0 then exit(false)
end;

procedure reverse;
var i,j:integer;
begin
  if gamefin=1 then exit;
  fc:=fc xor 1;
  for i:=1 to bdsize do for j:=1 to bdsize do
    if bdarr[i,j]>=0 then bdarr[i,j]:=bdarr[i,j] xor 1;
  for i:=1 to dsn do ds[i].p:=ds[i].p xor 1;
  for i:=1 to udsn do uds[i].p:=uds[i].p xor 1;
end;

procedure startAI();
begin

end;

procedure SendMsg(msg:string);
begin

end;

procedure readxy(var x,y:integer);
begin

end;

{ TForm1 }

procedure TForm1.WndProc(var Message:TMessage);
begin
  case Message.msg of
       WM_USER:begin
           hssize:=setwnd.hssize;
           ailv:=setwnd.ailv;
           sshun:=setwnd.sshun;
           drawboard;
       end;
       else inherited;
  end;
end;

procedure TForm1.quitClick(Sender: TObject);
var b:boolean;
begin
  FormCloseQuery(Sender,b);
  if b then begin sendmsg('END');halt;end;
end;

procedure TForm1.xiazi;
var x,y:integer;
begin
  readxy(x,y);
  bdarr[x,y]:=1;
  inc(dsn);
  ds[dsn].x:=x;ds[dsn].y:=y;ds[dsn].p:=1;ds[dsn].n:=dsn;
  sxarr[x,y]:=dsn;cgd:=true;
  drawboard;
  if i5(1) then begin
     MessageBox(Form1.Handle,'电脑获胜!','Connect5',MB_IconInformation);
     gamefin:=2;
  end;
  if hq then begin
     MessageBox(Form1.Handle,'和棋!','Connect5',MB_IconInformation);
     gamefin:=2;
  end;
end;

procedure TForm1.boardMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var px,py:integer;
begin
  if justfin then begin justfin:=false;exit;end;
  if Button=mbRight then begin UndoClick(Sender);exit;end;
  if gamefin<>0 then begin
     MessageBox(Form1.Handle,'本局已结束','Connect5',MB_IconWarning);
     exit;
  end;
  px:=bdsize-round((y-20)/pix);
  py:=round((x-30)/pix)+1;
  if(px=0)or(py=0)or(px>bdsize)or(py>bdsize)or(bdarr[px,py]>=0)then exit;
  bdarr[px,py]:=0;
  inc(dsn);udsn:=0;
  ds[dsn].x:=px;ds[dsn].y:=py;ds[dsn].p:=0;ds[dsn].n:=dsn;
  sxarr[x,y]:=dsn;
  sendmsg('TURN '+inttostr(x)+','+inttostr(y));
  if i5(0) then begin
     drawboard;
     MessageBox(Form1.Handle,'玩家获胜!','Connect5',MB_IconInformation);
     gamefin:=1;
  end else if hq then begin
     drawboard;
     MessageBox(Form1.Handle,'和棋!','Connect5',MB_IconInformation);
     gamefin:=1;
  end else begin xiazi;{UndoClick(Sender);}end;
end;

procedure TForm1.aboutClick(Sender: TObject);
begin
  MessageBox(Form1.Handle,'Connect5'#13#10'GUI版本:1.0(2017-06-04)'#13#10'作者:Wei Yijun','关于Connect5',MB_IconInformation);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=false;
  if cgd then case MessageBox(Form1.Handle,'保存此棋局吗？','退出Connect5',MB_IconQuestion or MB_YesNoCancel) of
       IdCancel:exit;
       IdYes:saveClick(Sender)
  end;
  CanClose:=true;
end;

procedure TForm1.drawboard;
var i,bx,by:integer;s:string;
begin
  with board.Canvas do begin
       Brush.Color:=$c0c0c0;
       FillRect(0,0,470,470);
       Brush.Color:=clBlack;
       rectangle(28,18,pix*(bdsize-1)+33,pix*(bdsize-1)+23);
       Brush.Color:=$c0c0c0;
       rectangle(29,19,pix*(bdsize-1)+32,pix*(bdsize-1)+22);
       Font.Color:=clBlack;
       for i:=1 to bdsize do begin
            Brush.Color:=$c0c0c0;
            str(16-i:2,s);
            textout(0,pix*(i-1)+13,s);
            moveto(30,pix*(i-1)+20);
            Brush.Color:=clBlack;
            lineto(pix*(bdsize-1)+30,pix*(i-1)+20);
       end;
       for i:=1 to bdsize do begin
            Brush.Color:=$c0c0c0;
            textout(pix*(i-1)+25,470-15,chr(i+64));
            moveto(pix*(i-1)+30,20);
            Brush.Color:=clBlack;
            lineto(pix*(i-1)+30,pix*(bdsize-1)+20);
       end;
       Brush.Color:=clBlack;
       bx:=bdsize>>1*pix+30;by:=bdsize>>1*pix+20;
       rectangle(bx-2,by-2,bx+3,by+3);
       bx:=3*pix+30;by:=(bdsize-4)*pix+20;
       rectangle(bx-2,by-2,bx+3,by+3);
       bx:=3*pix+30;by:=3*pix+20;
       rectangle(bx-2,by-2,bx+3,by+3);
       bx:=(bdsize-4)*pix+30;by:=3*pix+20;
       rectangle(bx-2,by-2,bx+3,by+3);
       bx:=(bdsize-4)*pix+30;by:=(bdsize-4)*pix+20;
       rectangle(bx-2,by-2,bx+3,by+3);
       for i:=1 to dsn do begin
           bx:=(ds[i].y-1)*pix+30;by:=(bdsize-ds[i].x)*pix+20;
           if (fc=0)and(ds[i].p=0)or(fc=1)and(ds[i].p=1)
             then begin Brush.Color:=clBlack;Font.Color:=clWhite;end
             else begin Brush.Color:=clWhite;Font.Color:=clBlack;end;
           Chord(bx-(pix-6)>>1,by-(pix-6)>>1,bx+(pix-6)>>1,by+(pix-6)>>1,
               bx+(pix-6)>>1,by,bx+(pix-6)>>1,by);
           str(ds[i].n,s);
           Brush.Style:=bsClear;
           if i=dsn then
              if odd(i) then Font.Color:=$0040ff else Font.Color:=$0000ff;
           if sshun=1 then textout(bx-textwidth(s)>>1,by-9,s);
       end;
       if sshun=0 then begin
           Brush.Color:=clRed;
           bx:=(ds[dsn].y-1)*pix+30;by:=(bdsize-ds[dsn].x)*pix+20;
           FillRect(bx-4,by-1,bx+4,by+1);
           FillRect(bx-1,by-4,bx+1,by+4);
           //Chord(bx-4,by-4,bx+4,by+4,bx+4,by,bx+4,by);
       end;
  end;
end;

procedure TForm1.saveClick(Sender: TObject);
var s:string;i:longint;
begin
  savedlg.InitialDir:=ExtractFilePath(Application.ExeName);
  if savedlg.Execute then begin
    s:=savedlg.FileName;
    if lowercase(ExtractFileExt(s))<>'.c5f' then s:=s+'.c5f';
    system.assign(output,s);
    rewrite(output);
    writeln(fc,' ',dsn);
    for i:=1 to dsn do writeln(i,' ',ds[i].x,' ',ds[i].y,' ',ds[i].p);
    system.close(output);
    log.Lines.Add('SaveFile: '+s);
    cgd:=false;justfin:=true;
  end;
end;

procedure TForm1.setupClick(Sender: TObject);
begin
  Form2.Show;
  InitSettings(handle,hssize,ailv,sshun);
end;

procedure TForm1.stopClick(Sender: TObject);
var f:text;i,j:integer;
begin
  if gamefin<>0 then begin
     MessageBox(Form1.Handle,'本局已结束','Connect5',MB_IconWarning);
     exit;
  end;
  system.assign(f,'F:\test.txt');
  system.rewrite(f);
  for i:=1 to bdsize do begin
      for j:=1 to bdsize do
        if bdarr[i,j]<0
           then write(f,bdarr[i,j]:3)
           else write(f,1 xor bdarr[i,j]:3);
      writeln(f);
  end;
  system.close(f);
  //sendmsg//HERE
end;

procedure TForm1.redoClick(Sender: TObject);
begin     //HERE
  if udsn>0 then begin
    inc(dsn);
    ds[dsn].x:=uds[udsn].x;ds[dsn].y:=uds[udsn].y;
    ds[dsn].p:=uds[udsn].p;ds[dsn].n:=uds[udsn].n;
    bdarr[ds[dsn].x,ds[dsn].y]:=ds[dsn].p;
    sxarr[ds[dsn].x,ds[dsn].y]:=ds[dsn].n;
    dec(udsn);
    reverse;
    if i5(1) or i5(0) or hq then if ds[dsn].p=1 then gamefin:=2 else gamefin:=1;
    drawboard;cgd:=true;
  end;
end;

procedure TForm1.undoClick(Sender: TObject);
begin     //HERE
  if dsn>0 then begin
    inc(udsn);
    uds[udsn].x:=ds[dsn].x;uds[udsn].y:=ds[dsn].y;
    uds[udsn].p:=ds[dsn].p;uds[udsn].n:=ds[dsn].n;
    bdarr[ds[dsn].x,ds[dsn].y]:=-1;
    sxarr[ds[dsn].x,ds[dsn].y]:=0;
    dec(dsn);
    reverse;
    gamefin:=0;
    drawboard;cgd:=true;
  end;
end;

procedure Init;
begin
  fillchar(bdarr,sizeof(bdarr),255);
  fillchar(sxarr,sizeof(sxarr),0);
  fillchar(ds,sizeof(ds),0);
  fillchar(uds,sizeof(uds),0);
  dsn:=0;udsn:=0;
  gamefin:=0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  startAI();
  sendmsg('INFO timeout_match 0');
  sendmsg('INFO game_type 0');
  sendmsg('INFO rule 1');
  sendmsg('INFO max_memory '+inttostr(memarr[hssize]));
  if ailv<5
     then sendmsg('INFO timeout_turn '+inttostr(tmarr[ailv]))
     else sendmsg('TNFO timeout_turn '+inttostr(ailv));
  init;
  drawboard;
end;

procedure TForm1.helpClick(Sender: TObject);
begin   //HERE!!!
  if gamefin<>0 then begin
     MessageBox(Form1.Handle,'本局已结束','Connect5',MB_IconWarning);
     exit;
  end;
  reverse;
  xiazi;
end;

procedure TForm1.loadClick(Sender: TObject);
var s:string;i,x:longint;
begin     //HERE
  opendlg.InitialDir:=ExtractFilePath(Application.ExeName);
  opendlg.Options:=opendlg.Options+[ofHideReadOnly];
  if opendlg.Execute then begin
    init;
    s:=opendlg.FileName;
    if lowercase(ExtractFileExt(s))<>'.c5f' then s:=s+'.c5f';
    system.assign(input,s);
    reset(input);
    read(fc,dsn);
    for i:=1 to dsn do begin
        read(x);ds[x].n:=x;
        with ds[x] do read(x,y,p);
    end;
    system.close(input);
    for i:=1 to dsn do with ds[i] do begin
        bdarr[x,y]:=p;
        sxarr[x,y]:=n;
    end;
    if i5(1) then gamefin:=2;
    if i5(0) then gamefin:=1;
    if hq then if ds[dsn].p=1 then gamefin:=2 else gamefin:=1;
    log.Lines.Add('LoadFile: '+s);
    drawboard;cgd:=false;justfin:=true;
  end;
end;

procedure TForm1.newgameClick(Sender: TObject);
begin
  case MessageBox(Form1.Handle,'计算机先手吗？','新局',
         MB_YesNoCancel or MB_IconQuestion) of
     idYes:fc:=1;
     idNo:fc:=0;
     else exit;
  end;
  sendmsg('START '+inttostr(bdsize));
  if fc=1 then begin sendmsg('BEGIN');xiazi;cgd:=true end else cgd:=false;
  drawboard;
end;

end.

