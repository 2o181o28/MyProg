{$APPTYPE GUI}
uses Windows;

const AppName:pchar='WinMandel';

var AMessage:Msg;hWindow:HWnd;
    maxt:longint;fd,heng,shu:extended;

function TransparentBlt(dc:hdc;a,b,c,d:longint;dc1:hdc;e,f,g,h:longint;x:uint):boolean;stdcall;external'msimg32.dll';

procedure DrawMandel(wnd:HWnd);
var c,i,j,color,k,maxx,maxy:longint;
    a,b,x,y,tx,m:extended;
    handle:hbitmap;dc,bdc:hdc;
    rec:rect;ps:paintstruct;
begin
   dc:=BeginPaint(wnd,@ps);
   GetClientRect(wnd,@rec);
   maxx:=rec.right;maxy:=rec.bottom;
   bdc:=0;handle:=0;
   while bdc=0 do bdc:=CreateCompatibleDC(dc);
   while handle=0 do handle:=CreateCompatibleBitmap(dc,maxx,maxy);
   SelectObject(bdc,handle);
   m:=sqrt(maxx*maxy);if m<1e-10 then m:=1e-10;
   for i:=-(maxx>>1) to maxx>>1 do
     for j:=-(maxy>>1) to maxy>>1 do
       begin
         a:=(i+m*heng)/(m*fd);b:=(j+m*shu)/(m*fd);
         x:=0;y:=0;c:=0;
         repeat
            tx:=x;
            x:=x*x-y*y+a;
            y:=2*tx*y+b;
            inc(c);
            if x*x+y*y>4 then break;
         until c>maxt;
         if c>maxt then color:=0 else begin
            k:=round(sqrt(c*maxt)*256) div maxt;
            color:=RGB(k,k,128);
         end;
         //color:=c<<8 div (maxt+1);
         SetPixel(bdc,i+maxx>>1,j+maxy>>1,color);
       end;
   TransparentBlt(dc,0,0,maxx,maxy,bdc,0,0,maxx,maxy,transparent);
   DeleteObject(handle);
   EndPaint(wnd,@ps);
end;

function WindowProc(Window:HWnd;AMessage:UINT;WParam:WPARAM;
                    LParam:LPARAM):LRESULT;stdcall;export;

procedure Update();
var rec:rect;
begin
    GetClientRect(Window,@rec);
    InvalidateRect(Window,@rec,true);
    UpdateWindow(Window);
end;

begin
  WindowProc:=0;
  case AMessage of
    wm_create:
      begin
         maxt:=81;fd:=1/4;
         heng:=-1/6;shu:=0;
         exit;
      end;
    wm_paint:begin DrawMandel(Window);exit;end;
    wm_KeyDown:
      begin
         case WParam of
            27:PostQuitMessage(0);
            8:if maxt>10 then begin maxt:=maxt div 3;Update();end;
            32:if maxt<1e8 then begin maxt:=maxt*3;Update();end;
            229:case LParam of
                    851969:  //+
                        begin
                            fd:=fd*1.5;heng:=heng*1.5;shu:=shu*1.5;
                            Update();
                        end;
                    786433:  //-
                        begin
                            fd:=fd/1.5;heng:=heng/1.5;shu:=shu/1.5;
                            Update();
                        end;
                end;
            38:begin shu:=shu-1/8;Update();end; //up
            40:begin shu:=shu+1/8;Update();end; //down
            37:begin heng:=heng-1/8;Update();end;//left
            39:begin heng:=heng+1/8;Update();end;//right
         end;
         exit;
      end;
    wm_Destroy:
      begin
         PostQuitMessage(0);
         exit;
      end;
  end;
  WindowProc:=DefWindowProc(Window,AMessage,WParam,LParam);
end;

procedure WinCreate;
var WindowClass:WndClass;hWindow:HWnd;
begin
  with WindowClass do begin
    Style:=cs_hRedraw or cs_vRedraw;
    lpfnWndProc:=WndProc(@WindowProc);
    cbClsExtra:=0;
    cbWndExtra:=0;
    hInstance:=system.MainInstance;
    hIcon:=LoadIcon(0,idi_Application);
    hCursor:=LoadCursor(0,idc_Arrow);
    hbrBackground:=CreateSolidBrush(RGB(0,0,128));
    lpszMenuName:=nil;
    lpszClassName:=AppName;
  end;
  RegisterClass(@WindowClass);
  hWindow:=CreateWindow(AppName,'MandelBrot Set',
              ws_OverlappedWindow,cw_UseDefault,cw_UseDefault,
              640+16,480+39,0,0,system.MainInstance,nil);
  if hWindow<>0 then begin
    ShowWindow(hWindow,CmdShow);
    ShowWindow(hWindow,SW_SHOW);
    UpdateWindow(hWindow);
  end else halt(1);
end;

begin
  WinCreate;
  while GetMessage(@AMessage,0,0,0) do begin
    TranslateMessage(@AMessage);
    DispatchMessage(@AMessage);
  end;
  halt(AMessage.wParam);
end.