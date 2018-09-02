Program Huffman;

type
   numbersA = array[1..256] of integer;
   bynumbersA = array[0..255] of integer;
   CharList = array[1..256] of string;
   codes = array[1..256] of string;

var 
   Name1, Name2, Name3, obms, work: string; 
   f1, f2: file of byte; 
   bynumbers: bynumbersA; 
   numbers: numbersA;
   symbols, dynsym: CharList;
   f3: text; 
   CurrCh, Mask, CurrBy, zero, one: byte;
   i, j, k, ka, obmi: integer;
   code: codes;
   fl:boolean;
   

begin
   zero:=0;
   one:=1;
   writeln('¬ведите название рассматриваемого файла');
   readln(Name1);
   writeln('¬ведите желаемое название нового файла');
   readln(Name2); 
   Name3:=Concat('—ловарь ',Name2);
   assignfile(f1,Name1);
   assignfile(f2,Name2);
   for i:=0 to 255 do 
      bynumbers[i]:=0;
   reset(f1);
   CurrCh:=1;
   k:=0;
   while not eof(f1) do 
   begin
      read(f1, CurrCh);
      Inc(bynumbers[CurrCh]);
      if (bynumbers[CurrCh]=1) then
      begin
         Inc(k);
         symbols[k]:=char(CurrCh);
         dynsym[k]:=symbols[k];
         numbers[k]:=1;
      end
      else begin 
         fl:=false;
         j:=1;
         while (j<=k) and (not fl) do 
         begin
            if (char(CurrCh)=symbols[j]) then
            begin
               Inc(numbers[j]);
               fl:=true;
            end;
            Inc(j);
         end;
      end;
   end;
   closefile(f1);
   
   ka:=k;
   if (ka=1) then code[1]:='0';   
   while (ka>1) do begin    
      for i:=1 to ka do                
         for j:=1 to (ka-1) do
            if (numbers[j]>numbers[j+1]) then
            begin
                obms:=dynsym[j]; obmi:=numbers[j];
                dynsym[j]:=dynsym[j+1]; numbers[j]:=numbers[j+1];
                dynsym[j+1]:=obms; numbers[j+1]:=obmi;
            end;  
      work:=dynsym[1];
      for i:=1 to length(work) do 
      begin
         j:=1;
         fl:=false;
         while (not fl) and (j<=k) do 
         begin
            if (work[i]=symbols[j]) then 
            begin
               code[j]:=code[j]+one;
               fl:=true;     
            end;   
         Inc(j);
         end;
      end;
      
      work:=dynsym[2];
      for i:=1 to length(work) do 
      begin
         j:=1;
         fl:=false;
         while (not fl) and (j<=k) do 
         begin
            if (work[i]=symbols[j]) then 
            begin
               code[j]:=code[j]+zero;
               fl:=true;     
            end;   
         Inc(j);
         end;
      end;
      numbers[1]:=numbers[1]+numbers[2];
      dynsym[1]:=dynsym[1]+dynsym[2];
      if (ka>2) then
         for i:=2 to (ka-1) do
         begin
            dynsym[i]:=dynsym[i+1];
            numbers[i]:=numbers[i+1];
         end;
      Dec(ka);
   end;  
   
   assignfile(f3,Name3);
   rewrite(f3);
   for i:=1 to k do
      writeln(f3,symbols[i],' - ',code[i]);
   closefile(f3);
   
   
   reset(f1);
   rewrite(f2);
   Mask:=$80;
   CurrBy:=0;
   while not eof(f1) do
   begin
      read(f1,CurrCh);
      fl:=false;
      i:=1;
      while (i<=k) and (not fl) do
      begin
        if (symbols[i]=char(CurrCh)) then 
        begin
           fl:=true;
           for j:=1 to length(code[i]) do
              begin
                 if (code[i][j]='1') then
                    CurrBy:=CurrBy or Mask;
                 Mask:=Mask shr 1;
                 if Mask=0 then
                 begin
                    write(f2,CurrBy);
                    Mask:=$80;
                    CurrBy:=0;
                 end;
              end;
        end;
        Inc(i);
      end;
   end;
   if Mask<>$80 then
      write(f2,CurrBy);
   closefile(f2);
   closefile(f1);
   
end.