{hua tu}
uses crt;
var c:char;i:longint;
begin
    clrscr;
    textbackground(15);
    textcolor(0);
    clrscr;
    gotoxy(1,3);
    writeln('  qing an shu zi suo ding');
    writeln('  5:qing kong guang biao suo zai ge');
    writeln('  hui che:tui chu');
    writeln('  qi yu cao zuo an zhao shu zi jian de fang xiang');
    writeln('  an ren yi jian kai shi');
    repeat until keypressed;
    c:=readkey;
    clrscr;
    gotoxy(2,2);
    while 1=1 do
      begin
        repeat until keypressed;
        c:=readkey;
        if c='2'{xia}
          then
            begin
              gotoxy(wherex,wherey+1);
              write('*');
              gotoxy(wherex-1,wherey)
            end else
        if (c='8'){shang}and(wherey<>1)
          then
            begin
              gotoxy(wherex,wherey-1);
              write('*');
              gotoxy(wherex-1,wherey)
            end else
        if (c='6'){you}and(wherex<>79)
          then
            begin
              gotoxy(wherex+1,wherey);
              write('*');
              gotoxy(wherex-1,wherey)
            end else
        if (c='4'){zuo}and(wherex<>1)
          then
            begin
              gotoxy(wherex-1,wherey);
              write('*');
              gotoxy(wherex-1,wherey)
            end else
        if (c='7'){zuo shang}and(wherex<>1)and(wherey<>1)
          then
            begin
              gotoxy(wherex-1,wherey-1);
              write('*');
              gotoxy(wherex-1,wherey)
            end else
        if (c='9'){you shang}and(wherex<>79)and(wherey<>1)
          then
            begin
              gotoxy(wherex+1,wherey-1);
              write('*');
              gotoxy(wherex-1,wherey)
            end else
        if (c='1'){zuo xia}and(wherex<>1)
          then
            begin
              gotoxy(wherex-1,wherey+1);
              write('*');
              gotoxy(wherex-1,wherey)
            end else
        if (c='3'){you xia}and(wherex<>79)
          then
            begin
              gotoxy(wherex+1,wherey+1);
              write('*');
              gotoxy(wherex-1,wherey)
            end else
        if c='5'{kong ge}
          then
            begin
              write(' ');
              gotoxy(wherex-1,wherey)
            end else
        if c=#13{hui che}
          then exit;
      end;
end.
