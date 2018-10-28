uses mmath,graph;
var x,y:integer;
    c:tcomplex;e:extended;
begin
    initgraph(x,y,'');
    setOxy();
    setScale(getmaxy/4,getmaxy/4);
    for x:=getmaxx>>1-getmaxy>>1 to getmaxx>>1+getmaxy>>1 do
        for y:=0 to getmaxy do begin
            c:=pix2x(x)+c_i*pix2y(y);
            e:=arg(power(c,5)-2*power(c,2)+1);
            setrgbpalette(17,round(e/pi*127+127),round(e/pi*127+127),round(e/pi*127+127));
            setpix(c.x,c.y,17);
        end;
    while 1=1 do;
end.
