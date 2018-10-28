unit setwnd;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Windows;

type

  { TForm2 }

  TForm2 = class(TForm)
    aiLevel: TRadioGroup;
    cancelquit: TButton;
    Label1: TLabel;
    time: TEdit;
    quit: TButton;
    shoushun: TCheckBox;
    hashsize: TRadioGroup;
    procedure aiLevelClick(Sender: TObject);
    procedure cancelquitClick(Sender: TObject);
    procedure hashsizeClick(Sender: TObject);
    procedure quitClick(Sender: TObject);
    procedure shoushunChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure Init();
  end;

var
  Form2: TForm2;
  hgui,sshun,ailv,hssize:longint;

procedure InitSettings(h,a,b,c:integer);

implementation

{$R *.lfm}

procedure InitSettings(h,a,b,c:longint);
begin
  hgui:=h;hssize:=a;ailv:=b;sshun:=c;
  Form2.Init();
end;

{ TForm2 }

procedure TForm2.Init();
begin
  shoushun.Checked:=boolean(sshun);
  hashsize.ItemIndex:=hssize;
  if ailv>=5
     then begin aiLevel.ItemIndex:=5;time.Enabled:=true;end
     else begin aiLevel.ItemIndex:=ailv;time.Enabled:=false;end
end;

procedure TForm2.quitClick(Sender: TObject);
begin
  close;
  SendMessage(hgui,wm_user,0,0);
end;

procedure TForm2.shoushunChange(Sender: TObject);
begin
  sshun:=ord(shoushun.Checked);
end;

procedure TForm2.cancelquitClick(Sender: TObject);
begin
  close;
end;

procedure TForm2.hashsizeClick(Sender: TObject);
begin
  hssize:=hashsize.ItemIndex;
end;

procedure TForm2.aiLevelClick(Sender: TObject);
begin
  ailv:=aiLevel.ItemIndex;
  if ailv=5 then ailv:=strtoint(time.Text);
  if ailv>=5 then time.Enabled:=true else time.Enabled:=false;
end;

end.

