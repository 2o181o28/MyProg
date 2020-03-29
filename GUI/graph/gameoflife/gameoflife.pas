{$APPTYPE GUI}

Program GameOfLife;

Uses sysutils,graph,winmouse,windows,wincrt;

Const pix = 6;

Var x,y,i,j,maxx,maxy,dx,dy,c,lx,ly: integer;
  mx,my,ms,tm: longint;
  ch: char;
  a,b: array[1..5000,1..5000] Of byte;
  f: array[0..242,0..242] Of byte;

Function TmStr():pchar;

Begin
    TmStr := pchar('Conway''s Game of Life     iteration #'+inttostr(tm));
End;

Procedure draw();

Var i,j: integer;
Begin
  For i:=1 To maxx Do
    For j:=1 To maxy Do
      If b[i,j]=1
        Then begin SetFillStyle(1,white);bar((i-1)*pix+1,(j-1)*pix+1,i*pix-1,j*pix-1);end
        Else if a[i,j]=1 then begin SetFillStyle(1,black);bar((i-1)*pix+1,(j-1)*pix+1,i*pix-1,j*pix-1);end;
  SetWindowText(GraphWindow,TmStr());
End;

Procedure Init();

Var i: integer;
Begin
  SetColor(DarkGray);
  for i:=1 to maxx-1 do
     Line(i*pix,1,i*pix,maxy*pix);
  for i:=1 to maxy-1 do
     Line(1,i*pix,maxx*pix,i*pix);
End;

{var f1:text;px,py:integer;c1:char;}

Begin
//  x:=VGA;y:=VGAHi;
  initgraph(x,y,'');
  setwindowtext(graphwindow,TmStr());
  randomize;
  maxx := getmaxx Div pix;
  maxy := getmaxy Div pix;
  lx := getmaxx+10;
  ly := getmaxy+10;


{assign(f1,'d:\1.txt');reset(f1);
    px:=100;py:=70;
    while not eof(f1) do begin
        while not eoln(f1) do begin
            read(f1,c1);
            if c1='X' then b[px,py]:=1;
            inc(px);
        end;
        read(f1,c1,c1);
        inc(py);px:=100;
    end;
    close(f1);draw();a:=b;}

  Init();
  While 1=1 Do
    Begin
      If findwindow(Nil,TmStr())=0
        Then halt;
      getmousestate(mx,my,ms);
      x := mx Div pix+1;
      y := my Div pix+1;
      If ((lx<>x)Or(ly<>y))And(mx>=0)And(my>=0)And(mx<=getmaxx)And(my<=getmaxy) Then
        Begin
          If a[lx,ly]=0 Then setfillstyle(1,black)
          Else setfillstyle(1,white);
          bar((lx-1)*pix+2,(ly-1)*pix+2,lx*pix-2,ly*pix-2);
          setfillstyle(1,red);
          bar((x-1)*pix+2,(y-1)*pix+2,x*pix-2,y*pix-2);
          setfillstyle(1,white);
          lx := x;
          ly := y;
        End;
      If ms>0 Then
        Begin
          a[x,y] := 1 xor a[x,y];
          tm := 0;
          SetWindowText(GraphWindow,TmStr());
          setfillstyle(1,white);
          If a[x,y]=1 Then bar((x-1)*pix+1,(y-1)*pix+1,x*pix-1,y*pix-1)
          Else
            Begin
              setfillstyle(1,black);
              bar((x-1)*pix+1,(y-1)*pix+1,x*pix-1,y*pix-1);
              setfillstyle(1,white);
            End;
          Repeat
            getmousestate(mx,my,ms);
          Until ms=0;
        End;
      If keypressed Then
        Begin
          ch := readkey;
          if ch=#8 then begin
            fillchar(b,sizeof(b),0);
            tm := 0; draw; a:=b;
          end else begin
          fillchar(b,sizeof(b),0);
          For i:=1 To maxx Do
            For j:=1 To maxy Do
              Begin
                c := 0;
                For dx:=-1 To 1 Do
                  For dy:=-1 To 1 Do
                    If ((dx<>0)Or(dy<>0))And(i+dx>0)And(j+dy>0)
                       And(i+dx<=maxx)And(j+dy<=maxy)And(a[i+dx,j+dy]=1)
                      Then inc(c);
                If (a[i,j]=1)And(c>1)And(c<4)Then b[i,j] := 1;
                If (a[i,j]=0)And(c=3)Then b[i,j] := 1;
              End;
          inc(tm);
          draw;
          a := b;
        end;End;
    End;
End.
