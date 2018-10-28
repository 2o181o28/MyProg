uses graph,mmath,sysutils;
type are=array [1..120] of extended;
    ares=array [0..4] of extended;
const n=118;
    two:ares=(-5.2139774311,2.4077602515,0.0018089756,0,0);
    four:ares=(-0.9210280093,
        2.1180930697,0.0021790134,
        0.0000937584,-0.0000007061);

var s:string;
    ar:array [1..120] of longint;
    xx,yy:are;
    maxx,maxy,i,x,y:integer;
    t,a,b,bx,by:extended;

function dot(var a,b:are):extended;
var i:longint;
begin
    dot:=0;
    for i:=1 to n do dot:=dot+a[i]*b[i];
end;

function eval(const p:ares;x:extended):extended;
var i:longint;
begin
    eval:=0;
    for i:=4 downto 0 do
        eval:=eval*x+p[i];
end;
begin
    readln(s);
    initgraph(x,y,'');
    assign(input,s);reset(input);
    maxx:=getmaxx;maxy:=getmaxy;
    setoxy(0,maxy);
    setscale(maxx/120,maxy/300);
    setcolor(lightblue);moveto(x2pix(0),y2pix(eval(two,0)));
    while not eof do begin
        inc(i);
        read(ar[i]);
        setpix(i,ar[i]);
        lineto(x2pix(i),y2pix(eval(two,i)));
    end;
    setcolor(yellow);moveto(x2pix(0),y2pix(eval(four,0)));
    for i:=1 to n do lineto(x2pix(i),y2pix(eval(four,i)));
    setcolor(white);
    for i:=1 to n do bx:=bx+i;bx:=bx/n;
    for i:=1 to n do by:=by+ar[i];by:=by/n;
    for i:=1 to n do b:=b+(i-bx)*(ar[i]-by);
    for i:=1 to n do t:=t+sqr(i-bx);
    b:=b/t;
    a:=by-bx*b;
    outtextxy(0,0,'y='+floattostr(b)+'x'+floattostr(a));
    line(0,y2pix(a),x2pix(120),y2pix(120*b+a));
    for i:=1 to n do begin yy[i]:=ar[i]-by;xx[i]:=i-bx;end;
    outtextxy(0,20,floattostr( dot(xx,yy)/sqrt(dot(xx,xx)*dot(yy,yy)) ));
    while 1=1 do;
    close(input);
end.
