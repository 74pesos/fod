program ej2;
var
	archivo:FILE OF INTEGER;
	act:integer;
	nombre:string;
	menores:integer;
	leidos,promedio:integer;
begin
	menores:=0;promedio:=0;leidos:=0;
	write('Ingresar nombre del archivo: ');readln(nombre);
	assign(archivo,nombre);
	reset(archivo);
	while not EOF(archivo) do begin
		read(archivo,act);
		writeln(act);
		if(act<1500) then menores:=menores+1;
		promedio:=promedio+act;
		leidos:=leidos+1;
	end;
	writeln('La cantidad de numeros menores a 1500 fue de: ',menores);
	writeln('el promedio de los numeros ingresados fue de: ',promedio/leidos:1:2);
	close(archivo);
end.
