{$M 8192,0,0}
uses DOS;
var cmd:string[79];
begin
     repeat
       write('Enter DOS command:');
       readln(cmd);
       if cmd<>'exit'then
       begin
         swapvectors;
         exec(getenv('COMSPEC'),'/c'+cmd);
         swapvectors;
       end;
     until cmd='exit'
end.
