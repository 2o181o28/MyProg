uses dos;
const sd:array[1..3]of longint=(100000000,70000000,50000000);
var i,c,total:longint;st:string;
    s:pathstr;f:text;filestuff:searchrec;
    unpacked:datetime;
    d:dirstr;n:namestr;e:extstr;
begin
    write('请输入一个目录或文件名:');
    read(s);
    fsplit(s,d,n,e);
    if (n='')and(e='')
      then
        begin
           writeln('浏览速度:   1-慢  2-中  3-快');
           read(c);
           writeln('此目录下的所有文件:');
           d:=d+'*.*';
    	   total:=0;
           findfirst(d,anyfile,filestuff);
           while doserror=0 do
      	     begin
               with filestuff do
                 begin
                   unpacktime(time,unpacked);
                   with unpacked do
                     begin
                       writeln(name:12,size:8,'字节(约',round(size/1024),'KB)');
		       write('修改日期:',year,'/',month,'/',day,' ');
                       writeln(hour,':',min);
	             end;
                   total:=total+size;
                   findnext(filestuff);
		   for i:=1 to sd[c] do;
                 end;
             end;
           writeln;
           writeln('总尺寸=',total,'字节(约',round(total/1024),'KB)');
	   for i:=1 to 1000000000 do;
           exit;
        end;
    s:=fsearch(n+e,d);
    if s=''
       then writeln(s,' 文件未找到。')
       else
         begin
           findfirst(s,anyfile,filestuff);
           with filestuff do
              begin
                   unpacktime(time,unpacked);
                   with unpacked do
                     begin
                       writeln('文件大小:',size:8,'字节(约',round(total/1024),'KB)');
		       write('修改日期:',year,'/',month,'/',day,' ');
                       writeln(hour,':',min);
	             end;
              end;
	   assign(f,s);st:=s;
           reset(f);
           i:=0;
	   while (not eof(f))and(i<10) do
              begin
                 inc(i);
                 readln(f,s);
                 writeln(s);
              end;
           if not eof(f)
              then writeln('……输入1展开')
              else begin close(f);for i:=1 to 1000000000 do;exit;end;
           close(f);
           read(c);
           if c=1 then
              begin
                writeln('浏览速度:   1-慢  2-中  3-快');
                read(c);
                assign(f,st);
                reset(f);
                while not eof(f) do
                   begin
                      readln(f,s);
 		      writeln(s);
                      for i:=1 to sd[c] do;
		   end;
	      end;
         end;
     for i:=1 to 1000000000 do;
end.