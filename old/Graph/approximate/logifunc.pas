uses graph,mmath,winmouse,windows,sysutils;
var x,y,mx,my,i:integer;
    k,n:extended;
    msx,msy,mst:longint;
begin
    InitGraph(x,y,'');
    mx:=GetMaxX();
    my:=GetMaxY();
    SetOxy(round(mx/3),round(my/2.3*1.6));
    SetScale(mx/6,my/2.3);
    SetColor(green);
    for x:=1 to mx do begin
        k:=pix2x(x);
        n:=0.1;
        for i:=1 to 1000 do begin
            n:=k*n*(1-n);
            if i>100 then
                SetPix(k,n);
        end;
    end;
    repeat
        GetMouseState(msx,msy,mst);
        sleep(100);
        SetWindowText(GraphWindow,PChar(FloatToStr(pix2x(msx))));
    until false;
end.
