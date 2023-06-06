program ej3;
uses 
	Crt;
type
	registro=record
		nroEmp:integer;
		apellido:string;
		nombre:string;
		edad:integer;
		dni:string;
	end;
	tipoArchivo=FILE OF registro;
procedure menu();
begin
	writeln('-------------------INGRESE UNA OPCION-------------------');
	writeln('           a:Crea un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado.');
	writeln('	   b:Abre el archivo creado en a y puede realizar distintos recorridos:');
	writeln('	   z:finaliza el programa');
	writeln('--------------------------------------------------------');
end;
procedure leerEmpleado(var act:registro);
begin
	write('Ingresar apellido: '); readln(act.apellido);
	if(act.apellido<>'fin') then begin
		write('Ingresar nombre: '); readln(act.nombre);
		write('Ingresar nro de empleado: '); readln(act.nroEmp);
		write('Ingresar edad: '); readln(act.edad);
		write('Ingresar dni: '); readln(act.dni);
	end;
end;
procedure incisoA(var arch:tipoArchivo;var nombre:string);
var
	act:registro;
begin
	write('Ingresar nombre del archivo a crear: '); readln(nombre);
	assign(arch,nombre);
	rewrite(arch);
	leerEmpleado(act);
	while(act.apellido<>'fin') do begin
		write(arch,act);
		leerEmpleado(act);
	end;
	close(arch);
	writeln('Archivo creado, oprima una tecla para volver al menu');
	readln();
	ClrScr;
end;
procedure incisoBI(var arch:tipoArchivo;determinado:string);
var
	act:registro;
begin
	reset(arch);
	while not EOF(arch) do begin
		read(arch,act);
		if((act.nombre=determinado) or (act.apellido=determinado)) then 
			writeln('nombre: ',act.nombre,' apellido: ',act.apellido,' numero de empleado: ',act.nroEmp,' dni: ',act.dni,' edad: ',act.edad);
	end;
	close(arch);
	writeln('recorrido finalizado, oprima una tecla para volver al menu');
	readln();
	ClrScr;
end;
procedure incisoBII(var arch:tipoArchivo);
var
	act:registro;
begin
	reset(arch);
	while not EOF(arch) do begin
		read(arch,act);
		writeln('nombre: ',act.nombre,' apellido: ',act.apellido,' numero de empleado: ',act.nroEmp,' dni: ',act.dni,' edad: ',act.edad);
	end;
	close(arch);
	writeln('recorrido finalizado, oprima una tecla para volver al menu');
	readln();
	ClrScr;
end;
procedure incisoBIII(var arch:tipoArchivo);
var
	act:registro;
begin
	reset(arch);
	while not EOF(arch) do begin
		read(arch,act);
		if(act.edad>70) then 
			writeln('nombre: ',act.nombre,' apellido: ',act.apellido,' numero de empleado: ',act.nroEmp,' dni: ',act.dni,' edad: ',act.edad);
	end;
	close(arch);
	writeln('recorrido finalizado, oprima una tecla para volver al menu');
	readln();
	ClrScr;	
end;
procedure incisoB(var arch:tipoArchivo;cond:boolean);
var
	opcion:integer;
	determinado:string;
	ocasional:string;
begin
	if (not cond) then begin
		write('No se a ejecutado el archivo a, ingrese un nombre de un archivo para abrir: ');readln(ocasional);
		assign(arch,ocasional);
	end;
	writeln('Ingrese una de las opciones: ');
	repeat
		writeln('					1:Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
		writeln('					2:listar en pantalla los empleados de a uno por linea');
		writeln('					3:Listar en pantalla empleados mayores de 70 proximos a jubilarse');
		writeln('					0:Finaliza el uso de este proceso');
		readln(opcion);
		ClrScr;
		case opcion of 
			1:
				begin
					write('Ingresar un nombre o apellido para buscar: ');readln(determinado);
					incisoBI(arch,determinado);
				end;
			2: incisoBII(arch);
			3: incisoBIII(arch);
		end;
	until(opcion=0);
end;
var
	opcion:char;
	nombre:string;
	arch:tipoArchivo;
	cond:boolean;
begin
	cond:=false;
	repeat 
		menu;
		readln(opcion);
		ClrScr;
		case opcion of
			'a':
				begin
					incisoA(arch,nombre);
					cond:=true;
				end;
			'b':incisoB(arch,cond);
		end;
	until(opcion='z');
end.
