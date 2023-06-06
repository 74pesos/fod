program ej1;
var
	archivo:FILE of integer;
	act:integer;
	name:string;
begin
	write('Ingresar nombre del archivo: ');readln(name);
	assign(archivo,name);
	rewrite(archivo);
	write('ingresar numero: ');readln(act);
	while(act<>30000) do begin
		write(archivo,act);
		write('ingresar numero: ');readln(act);
	end;
	close(archivo);
end.
