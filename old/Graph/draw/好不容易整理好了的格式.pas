Program GraphicsTest;

Uses
    Graph, Windows, WinCRT, WinMouse;

Var
    GraphDriver, GraphMode     : Integer;
    MouseX, MouseY, MouseState : LongInt;


BEGIN
     InitGraph(GraphDriver, GraphMode, '');
     SetWindowText(GraphWindow, 'Haha!');

     Repeat
           GetMouseState(MouseX, MouseY, MouseState);
     Until (KeyPressed()) Or (MouseState > 0);

     WriteLn('OK');
     ReadLn();
END.
