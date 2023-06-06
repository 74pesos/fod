program ej1;
const
	valor=-40;
type
	empleado=record
		codigo:integer;
		nombre:string;
		monto:real;
	end;
	archivoEmpleado=FILE OF empleado;
procedure imprimirEmpleado(e:empleado);
begin
	with e do begin
		writeln('Los datos del empleado son: ');
		writeln('	codigo: ',codigo);
		writeln('	nombre: ',nombre);
		writeln('	monto: ',monto:1:2);
	end;
end;
procedure mostrarDatos(var arch:archivoEmpleado);
var
	e:empleado;
begin
	reset(arch);
	while(not EOF(arch)) do begin
		read(arch,e);
		imprimirEmpleado(e);
	end;
	close(arch);
end;
procedure leer (var e: empleado);
begin
	with e do begin 
		write ('INGRESE CODIGO EMPLEADO: '); readln (codigo);
		if (codigo <> -1) then begin
			write ('INGRESE NOMBRE DEL EMPLEADO: '); readln (nombre);
			write ('INGRESE MONTO DE LA COMISION: '); readln (monto);
		end;
		writeln ('');
	end;
end;
procedure crear (var arc_log:archivoEmpleado);
var
	e:empleado;
begin
	rewrite (arc_log);
	leer (e);
	while (e.codigo <> -1) do begin
		write (arc_log,e);
		leer (e);
	end;
	close (arc_log);
end;
procedure compactar(var archD,archM:archivoEmpleado);
var
		nombreD,nombreM:string;
		actM,actD:empleado;
begin
	write('Ingresar el nombre del archivo detalle: ');readln(nombreD);
	write('Ingresar nombre del archivo maestro: ');readln(nombreM);
	assign(archD,nombreD);
	assign(archM,nombreM);
	crear(archD);
	reset(archD);
	rewrite(archM);
	if(not EOF(archD)) then read(archD,actD)
	else actD.codigo:=valor;
	while(actD.codigo<>valor) do begin
		actM.codigo:=actD.codigo;
		actM.monto:=0;
		actM.nombre:=actD.nombre;
		while(actM.codigo=actD.codigo) do begin
			actM.monto:=actM.monto+actD.monto;
			if(not EOF(archD)) then read(archD,actD)
			else actD.codigo:=valor;
		end;
		write(archM,actM);
	end;
	close(archM);close(archD);
end;
var
	archD,archM:archivoEmpleado;
begin
	compactar(archD,archM);
	mostrarDatos(archM);
end.
