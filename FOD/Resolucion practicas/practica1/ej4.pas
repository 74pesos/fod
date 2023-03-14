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
	writeln('	   c:Agrega uno o mas empleados al final del archivo con sus datos ingresados por teclado');
	writeln('	   d:Modifica la edad de uno o mas empleados del archivo');
	writeln('	   e:Exporta el archivo a un archivo .txt llamado todos_empleados');
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
		write('No se a ejecutado el inciso a, ingrese un nombre de un archivo para abrir: ');readln(ocasional);
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
procedure agregarEmpleado(var arch:tipoArchivo;act:registro);
var
	aux:registro;
	cond:boolean;
begin
	cond:=false;
	reset(arch);
	while ((not EOF(arch)) and (not cond)) do begin
		read(arch,aux);
		if(act.nroEmp=aux.nroEmp) then cond:=true;
	end;
	if(not cond) then write(arch,act)
	else writeln('el empleado que ingreso ya esta en el archivo');
	close(arch);
end;
procedure incisoC(var arch:tipoArchivo;cond:boolean);
var
	act:registro;
	opcion:char;
	ocasional:string;
begin
	if (not cond) then begin
		write('No se a ejecutado el inciso a, ingrese un nombre de un archivo para abrir: ');readln(ocasional);
		assign(arch,ocasional);
	end;
	repeat 
		leerEmpleado(act);
		agregarEmpleado(arch,act);
		write('Ingresar otro? ingrese N para terminar');readln(opcion);
	until((opcion='n') or (opcion='N'));
	writeln('Oprima alguna tecla para volver al menu');
	readln();
	ClrScr;
end;
procedure modificarEmpleado(var arch:tipoArchivo;nro,edad:integer);
var
	act:registro;
begin
	reset(arch); 
	read(arch,act);
	while((not EOF(arch)) and (act.nroEmp<>nro)) do 
		read(arch,act);
	if(not EOF(arch)) then begin
		act.edad:=edad;
		seek(arch,filepos(arch)-1);
		write(arch,act);
	end
	else writeln('El numero de empleado no esta en la lista');
end;
procedure incisoD(var arch:tipoArchivo;cond:boolean);
var
	opcion:char;
	ocasional:string;
	nro,edad:integer;
begin
	if (not cond) then begin
		write('No se a ejecutado el inciso a, ingrese un nombre de un archivo para abrir: ');readln(ocasional);
		assign(arch,ocasional);
	end;
	repeat
		write('Ingresar el codigo del empleado a modificar: ');readln(nro);
		write('Ingresar edad nueva: ');readln(edad);
		modificarEmpleado(arch,nro,edad);
		write('Quiere modificar otro empleado? ingrese N para volver al menu'); read(opcion);
	until((opcion='N') or (opcion='n'));
end;
function IntToStr(x:integer):string;
var
	provX,dig:integer;
	caracter:char;
	letras:integer;
	i:integer;
begin
	letras:=0;provX:=x;i:=0;
	while(provX<>0) do begin
		provX:=provX div 10;
		letras:=letras+1;
	end;
	writeln('El valor: ',x, 'usara: ',letras, ' letras');
	setLength(IntToStr,letras);
	while(x<>0) do begin
		dig:=x mod 10;
		caracter:=chr(48+dig);
		IntToStr[letras-i]:=caracter;
		i:=i+1;
		x:=x div 10;
	end;
end;
procedure incisoE(var arch:tipoArchivo;cond:boolean);
var
	act:registro;
	archTxt:text;
	cadena:string;
	ocasional:string;
begin
	if (not cond) then begin
		write('No se a ejecutado el inciso a, ingrese un nombre de un archivo para abrir: ');readln(ocasional);
		assign(arch,ocasional);
	end;
	assign(archTxt,'todos_empleados.txt');
	rewrite(archTxt);
	reset(arch);
	while(not EOF(arch)) do begin
		read(arch,act);
		cadena:=Concat('Empleado: ',act.nombre,' ',act.apellido,' numero de ID: ',IntToStr(act.nroEmp),' edad: ',IntToStr(act.edad),' con DNI: ',act.dni);
		write(archTxt,cadena); write(archTxt,chr(10));
	end;
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
			'c':incisoC(arch,cond);
			'd':incisoD(arch,cond);
			'e':incisoE(arch,cond);
		end;
	until(opcion='z');
end.
