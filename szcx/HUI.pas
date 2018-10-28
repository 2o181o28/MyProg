function hui(x:longint):boolean;
var i:longint;s:string;
begin
     str(x,s);
     hui:=true;
     for i:=1 to length(s)div 2 do
        if s[i]<>s[length(s)+1-i]
          then exit(false);
end;