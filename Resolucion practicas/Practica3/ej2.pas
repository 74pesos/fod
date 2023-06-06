program ej2;
uses 
	crt;
const 	
	VALORCORTE=32767;
type
	asistente = record
		nro:integer;
		apellido:string;
		nombre:string;
		email:string;
		dni:string;
	end;
	archivoAsistente = FILE OF asistente;
procedure leerAsistente(var act:asistente);
begin
	write('Ingresar numero de asistente ');readln(act.nro);
	if(act.nro<>-1) then
		with act do begin
			write('Ingresar apellido del asistente ');readln(apellido);
			write('Ingresar nombre del asistente ');readln(nombre);
			write('Ingresar email del asistente ');readln(email);
			write('Ingresar dni del asistente ');readln(dni);
		end;
	clrscr;
end;
procedure armarArchivo(var arch:archivoAsistente);
var
	archivoNombre:string;
	regM:asistente;
begin
	write('Ingresar nombre del archivo '); readln(archivoNombre);
	assign(arch,archivoNombre);
	rewrite(arch);
	leerAsistente(regM);
	while(regM.nro<>-1) do begin
		write(arch,regM);
		leerAsistente(regM);
	end;
end;
procedure eliminarMenores(var arch:archivoAsistente);
var
	regM:asistente;
begin
	reset(arch);
	while(not EOF(arch)) do begin
		read(arch,regM);
		with regM do begin
			if(nro<1000) then begin
				dni := concat('@', dni);
				seek(arch,filepos(arch)-1);
				write(arch,regM);
			end;
		end;
	end;
end;
procedure listarArchivoBorradoLogico(var arch:archivoAsistente);
var
	regM:asistente;
begin
	reset(arch);
	while(not EOF(arch)) do begin
		read(arch,regM);
		if(regM.dni[1]<>'@') then begin
			with regM do begin
				writeln('El numero del asistente es: ',nro);
				writeln('El nombre y apellido del asistente es: ', nombre, ' ', apellido);
				writeln('El email del asistente es: ',email);
				writeln('El dni del asistente es: ', dni);
			end;
			writeln('**************');
			writeln();writeln();
		end;
	end;
	write('Ingresar para limpiar la pantalla'); readln();
	clrscr;
end;
procedure listarArchivo(var arch:archivoAsistente);
var
	regM:asistente;
begin
	reset(arch);
	while( not EOF(arch)) do begin
		read(arch,regM);
		with regM do begin
			writeln('El numero del asistente es: ',nro);
			writeln('El nombre y apellido del asistente es: ', nombre, ' ', apellido);
			writeln('El email del asistente es: ',email);
			writeln('El dni del asistente es: ', dni);
		end;
		writeln('**************');
		writeln();writeln();
	end;
	write('Ingresar para limpiar la pantalla');readln();
	clrscr;
end;
var
	arch:archivoAsistente;
begin
	//armarArchivo(arch);
	assign(arch,'babosa');
	//eliminarMenores(arch);
	listarArchivo(arch);
	listarArchivoBorradoLogico(arch);
end.
