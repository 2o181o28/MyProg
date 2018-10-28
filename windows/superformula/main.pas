unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    graph: TImage;
    formula: TImage;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    TrackBar5: TTrackBar;
    TrackBar6: TTrackBar;
    TrackBar7: TTrackBar;
    procedure draw;
    procedure FormCreate(Sender: TObject);
    procedure SetTrackBar(var x:TTrackbar;s:string);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure TrackBar5Change(Sender: TObject);
    procedure TrackBar6Change(Sender: TObject);
    procedure TrackBar7Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.SetTrackBar(var x:TTrackBar;s:string);
var f:extended;p:integer;
begin
    try
      f:=strtofloat(s);
    except
      on EConvertError do exit;
    end;
    p:=round(f*10);
    if (p<x.min) or (p>x.max) then exit;
    x.Position:=p;
end;

procedure TForm1.draw;
var r,t,a,b,m1,m2,n1,n2,n3:extended;
    x,y,i:integer;
begin
    a:=Trackbar1.Position/10;b:=Trackbar2.Position/10;
    m1:=Trackbar3.Position/10;m2:=Trackbar4.Position/10;
    n1:=Trackbar5.Position/10;n2:=Trackbar6.Position/10;
    n3:=Trackbar7.Position/10;
    if abs(a*b*n1)<=1e-8 then exit;
    with graph.Canvas do begin
      FillRect(0,0,400,400);
      for i:=-314 to 314 do begin
        t:=i/100;
        if (abs(cos(m1*t/4) / a)<1e-8) or (abs(sin(m2*t/4) / b)<1e-8)
           then continue;
        r:=power(
            power( abs(cos(m1*t/4) / a), n2) +
            power( abs(sin(m2*t/4) / b), n3),
            -1/n1);
        try
           x:=round(r*cos(t)*50+200);
           y:=round(r*sin(t)*50+200);
        except
          on EInvalidOp do continue;
        end;
        pixels[x,y]:=ClBlack;
      end;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  draw;
  formula.Picture.LoadFromFile('pics\formula.png');
end;

procedure TForm1.Edit1Change(Sender: TObject);begin SetTrackBar(Trackbar1,Edit1.text)end;
procedure TForm1.Edit2Change(Sender: TObject);begin SetTrackBar(Trackbar2,Edit2.text)end;
procedure TForm1.Edit3Change(Sender: TObject);begin SetTrackBar(Trackbar3,Edit3.text)end;
procedure TForm1.Edit4Change(Sender: TObject);begin SetTrackBar(Trackbar4,Edit4.text)end;
procedure TForm1.Edit5Change(Sender: TObject);begin SetTrackBar(Trackbar5,Edit5.text)end;
procedure TForm1.Edit6Change(Sender: TObject);begin SetTrackBar(Trackbar6,Edit6.text)end;
procedure TForm1.Edit7Change(Sender: TObject);begin SetTrackBar(Trackbar7,Edit7.text)end;

procedure TForm1.TrackBar1Change(Sender: TObject);begin Edit1.text:=floattostr(Trackbar1.Position/10);draw; end;
procedure TForm1.TrackBar2Change(Sender: TObject);begin Edit2.text:=floattostr(Trackbar2.Position/10);draw; end;
procedure TForm1.TrackBar3Change(Sender: TObject);begin Edit3.text:=floattostr(Trackbar3.Position/10);draw; end;
procedure TForm1.TrackBar4Change(Sender: TObject);begin Edit4.text:=floattostr(Trackbar4.Position/10);draw; end;
procedure TForm1.TrackBar5Change(Sender: TObject);begin Edit5.text:=floattostr(Trackbar5.Position/10);draw; end;
procedure TForm1.TrackBar6Change(Sender: TObject);begin Edit6.text:=floattostr(Trackbar6.Position/10);draw; end;
procedure TForm1.TrackBar7Change(Sender: TObject);begin Edit7.text:=floattostr(Trackbar7.Position/10);draw; end;

end.

