uses windows,crt;
var th:handle;id:dword;
    f:text;
procedure play();
var c:char;cnt:longint=-1;
    amsg:msg;
begin
   while not eof() do begin
      read(f,c);inc(cnt);
      if c>'.' then beep((ord(c)-48)*100+1000,100);
      if PeekMessage(@amsg,0,0,0,PM_REMOVE)then
        if amsg.message=WM_USER then
          repeat until PeekMessage(@amsg,0,0,0,PM_REMOVE) and (amsg.message=WM_USER);
      if cnt mod 100=0 then writeln('Current digits : ',cnt);
   end;
end;
begin
   assign(f,'d:\pi.txt');
   reset(f);
   writeln('Press ''P'' to pause && continue');
   th:=CreateThread(nil,0,lpthread_start_routine(@play),nil,0,id);
   repeat
     if keypressed() then begin readkey;PostThreadMessage(id,WM_USER,0,0);end;
   until false;
   close(input);
end.
