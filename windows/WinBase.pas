{$APPTYPE GUI}
uses Windows;

const AppName='WinHello';

var AMessage:Msg;hWindow:HWnd;

function WindowProc(Window:HWnd;AMessage:UINT;WParam:WPARAM;
                    LParam:LPARAM):LRESULT;stdcall;export;
var dc:hdc;ps:paintstruct;
begin
  WindowProc:=0;
  case AMessage of
    wm_paint:
      begin
         dc:=BeginPaint(Window,@ps);

         EndPaint(Window,ps);
         Exit;
      end;
    wm_Destroy:
      begin
         PostQuitMessage(0);
         Exit;
      end;
  end;
  WindowProc:=DefWindowProc(Window,AMessage,WParam,LParam);
end;
function WinRegister:Boolean;
var WindowClass:WndClass;
begin
    with WindowClass do begin
        Style:=cs_hRedraw or cs_vRedraw;
        lpfnWndProc:=WndProc(@WindowProc);
        cbClsExtra:=0;
        cbWndExtra:=0;
        hInstance:=system.MainInstance;
        hIcon:=LoadIcon(0, idi_Application);
        hCursor:=LoadCursor(0, idc_Arrow);
        hbrBackground:=GetStockObject(WHITE_BRUSH);
        lpszMenuName:=nil;
        lpszClassName:=AppName;
  end;
  exit(RegisterClass(WindowClass)<>0);
end;

function WinCreate:HWnd;
var hWindow:HWnd;
begin
  hWindow:=CreateWindow(AppName,'Hello world program',
              ws_OverlappedWindow,cw_UseDefault,cw_UseDefault,
              cw_UseDefault,cw_UseDefault,0,0,system.MainInstance,nil);
  if hWindow<>0 then begin
    ShowWindow(hWindow,CmdShow);
    ShowWindow(hWindow,SW_SHOW);
    UpdateWindow(hWindow);
  end;
  exit(hWindow);
end;

begin
  if not WinRegister then begin
    MessageBox(0,'Register failed',nil,mb_Ok);
    Exit;
  end;
  hWindow := WinCreate;
  if longint(hWindow) = 0 then begin
    MessageBox(0,'WinCreate failed',nil,mb_Ok);
    Exit;
  end;
  while GetMessage(@AMessage,0,0,0) do begin
    TranslateMessage(AMessage);
    DispatchMessage(AMessage);
  end;
  Halt(AMessage.wParam);
end.