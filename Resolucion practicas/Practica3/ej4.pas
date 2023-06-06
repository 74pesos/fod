program ej4;
type
	regFlor = record
		nombre:string;
		codigo:integer;
	end;
	archFlores = FILE OF regFlor;
procedure agregarFlor(var a: archFlores; nombre: string; codigo: integer);
var
	aux:integer;
	regM:regFlor;
	indice:regFlor;
begin
	reset(a);
	read(a,indice);
	regM.nombre:=nombre;regM.codigo:=codigo;
	if(indice.codigo<>0) then begin
		seek(a,indice.codigo*-1);
		read(a,indice);
		seek(a,filepos(a)-1);
		write(a,regM);
		seek(a,0);
		write(a,indice);
	end
	else begin
		seek(a,filesize(a));
		write(a,regM);
	end;
	close(a);
end;
procedure listar(var a:archFlores);
var
	regM:regFlor;
begin
	reset(a);
	seek(a,filepos(a)+1);
	leer(a,regM);
	while(regM.codigo<>VALORCORTE) do begin
		if(regM.codigo>=0) then 
			writeln('nombre: ',regM.nombre,' codigo: ',regM.codigo);
		leer(a,regM);
	end;	
	close(a);
end;
procedure eliminar(var a:archFlores;flor:regFlor);
var
	regM:regFlor;
	indice:regFlor;
begin
	reset(a);
	read(a,indice);
	leer(a,regM);
	while((regM.codigo<>VALORCORTE) and (regM.codigo<>flor.codigo)) do
		leer(a,regM);
	if(regM.codigo = flor.codigo) then begin
		seek(a,filepos(a)-1);
		write(a,indice);
		indice.codigo:=filepos(a)*-1;
		seek(a,0);
		write(a,indice);
	end;
	close(a);
end;
	
