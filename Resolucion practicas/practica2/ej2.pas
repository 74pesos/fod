program ej2;
const
	VALORCORTE=-50;
type
	alumno=record
		codigo:integer;
		nombre:string;
		cursadas:integer;
		finales:integer;
	end;
	materia=record
		codigo:integer;
		aprobado:boolean;
	end;
	alumnosArchivo=FILE OF alumno;
	materiasArchivo=FILE OF materia;
procedure leer(var mA:materiasarchivo;var act:materia);
begin
	if(not EOF(mA)) then 
		read(mA,act)
	else
		act.codigo:=VALORCORTE;
end;
procedure incisoA(var aM:alumnosArchivo;var aD:materiasArchivo);
var
	totalF,totalC:integer;
	actM:alumno;
	actD:materia;
	aux:integer;
begin
	reset(aM);
	reset(aD);
	leer(aD,actD);
	read(aM,actM);
	while(actD.codigo<>VALORCORTE) do begin
		aux:=actD.codigo;totalC:=0;totalF:=0;
		while(aux=actD.codigo) do begin
			if(actD.aprobado) then totalF:=totalF+1
			else
				totalC:=totalC+1;
			leer(aD,actD);
		end;
		while(actM.codigo<>aux) do read(am,actM);
		actM.cursadas:=actM.cursadas+totalC;
		actM.finales:=actM.finales+totalF;
		seek(aM,filepos(aM)-1);
		write(aM,actM);
		if(not eof(am)) then read(am,actM);
	end;
	close(aM);
	close(aD);
end;
procedure incisoB(var aM:alumnosArchivo);
var
	nombreTxt:string;
	aT:text;
	act:alumno;
begin
	readln(nombreTxt);
	assign(aT,nombreTxt);
	reset(aM);
	rewrite(aT);
	while(not EOF(aM)) do begin
		read(aM,act);
		if((act.cursadas>4) and(act.finales<4)) then 
			with act do 
				writeln(aT,codigo,' ',nombre,'',cursadas,' ',finales);
	end;
	close(aM);
	close(aT);
end;
procedure crearArchivos();
	procedure leerAlumno(var act:alumno);
	begin
		with act do begin
			write('Ingresar codigo:');readln(codigo);
			write('Ingresar nombre:');readln(nombre);
			write('Ingresar cursadas:');readln(cursadas);
			write('Ingresar finales:');readln(finales);
		end;
	end;
	procedure leerMateria(var act:materia);
	var
		status:char;
	begin
		with act do begin
			write('Ingresar codigo:');readln(codigo);
			write('Ingresar estado del final (y/n):');readln(status);
			if(status='y') then aprobado:=true
			else aprobado:=false;
		end;
	end;
var
	aM:alumnosArchivo;
	aD:materiasArchivo;
	aMNombre,aDNombre:string;
	cond:char;
	actA:alumno;
	actM:materia;
begin
	write('Ingresar nombre del maestro: ');readln(aMNombre);
	write('Ingresar nombre del detalle: ');readln(aDNombre);
	assign(aM,AMNombre);
	assign(aD,aDNombre);
	rewrite(aM);
	rewrite(aD);
	writeln('Armando el maestro');
	repeat
		leerAlumno(actA);
		write(aM,actA);
		write('Leer otro? '); readln(cond);
	until(cond='N');
	cond:='Z';
	writeln('Armando el detalle');
	repeat
		leerMateria(actM);
		write(aD,actM);
		write('Leer otro?'); readln(cond);
	until(cond='N');
	close(aM);
	close(aD);
end;
procedure menu;
begin
	writeln('LA OPCION a ACTUALIZA EL MAESTRO INCREMENTANDO, SI SE APROBO EL FINAL O LA CURSADA, AUMENTANDO EN UNO ESTE VALOR');
	writeln('LA OPCION b LISTA EN UN ARCHIVO DE TEXTO LOS ALUMNOS CON MAS DE CUATRO MATERIAS CON CURSADAS APROBADAS PERO SIN FINAL (LISTA TODOS LOS CAMPOS)');
	writeln('LA OPCION Z FINALIZA LA EJECUCION DEL PROGRAMA');
end;
var
	aM:alumnosArchivo;
	aD:materiasArchivo;
	opcionLectura,opcion:char;
	maestroNombre,detalleNombre:string;
begin
	writeln('Creamos archivos? ingresar y para realizar la creacion u otra tecla para no hacerlo');
	readln(opcionLectura);
	if(opcionLectura='y') then crearArchivos;
	write('Ingresar nombre del maestro: ');readln(maestroNombre);
	write('Ingresar nombre del detalle: ');readln(detalleNombre);
	assign(aM,maestroNombre);
	assign(aD,detalleNombre);
	repeat
		menu;
		readln(opcion);
		case opcion of
			'a':incisoA(aM,aD);
			'b':incisoB(aM);
			'Z':
		end;
	until(opcion='Z');
end.
