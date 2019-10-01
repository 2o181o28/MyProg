unit burnship;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Graph: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Draw;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  i,j,c,fd,heng,shu,max:longint;a,b,x,y,tx:extended;

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.Draw;
var cl:TColor;
begin
   for i:=-320 to 320 do
     for j:=-240 to 240 do
       begin
         a:=(i<<2+heng)/fd;b:=(j<<2+shu)/fd;
         x:=0;y:=0;c:=0;
         repeat
            x:=abs(x);y:=abs(y);
            tx:=x;
            x:=x*x-y*y+a;
            y:=2*tx*y+b;
            inc(c);
            if x*x+y*y>4 then break;
         until c>max;
         if c>max
            then cl:=0
            else cl:=(c<<8 div max)<<16+128;
         Graph.Canvas.Pixels[i+320,j+240]:=cl;
       end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
   case key of
      27:halt;               //Esc
      38:dec(shu,100);       //up
      40:inc(shu,100);       //down
      37:dec(heng,100);      //left
      39:inc(heng,100);      //right
      32:if max<10000 then max:=max*5;      //space
      8:if max>10 then max:=max div 5;      //bksp
   end;
   draw;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
   case key of
      #61:begin               //+
            fd:=round(fd*1.5);
            shu:=round(shu*1.5);
            heng:=round(heng*1.5);
          end;
      #45:begin               //-
            fd:=round(fd/1.5);
            shu:=round(shu/1.5);
            heng:=round(heng/1.5);
          end;
   end;
   draw;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   fd:=600;max:=30;
   heng:=-200;shu:=-100;
   draw;
end;

end.

