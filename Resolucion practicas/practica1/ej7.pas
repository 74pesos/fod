program ej7;
uses
	crt;
type
	novelas=record
		codigo:integer;
		nombre:string;
		genero:string;
		precio:real;
	end;
	archivoNovelas=FILE OF novelas;
procedure menu;
begin
	writeln('----------Seleccione una opcion----------');
	writeln('a: Crea un archivo binario a partir de la informacion almacenada en el archivo de texto "novelas.txt');
	writeln('b: Abrir el archivo binario y modificar o agregar novelas');
	writeln('z:	Finalizar ejecucion');
	writeln('-----------------------------------------');
end;
procedure incisoA(var arch:archivoNovelas;var nombre:string);
var
	act:novelas;
	archText:text;
begin
	write('Ingresar un nombre para el archivo binario: ');readln(nombre);
	assign(archText,'novelas.txt');
	assign(arch,nombre);
	reset(archText);
	rewrite(arch);
	while(not EOF(archText)) do begin
		with act do begin
			readln(archText,codigo,precio,genero);
			readln(archText,nombre);
		end;
		write(arch,act);
	end;
	close(archText);
	close(arch);
	writeln('Se creo el archivo, ingrese una tecla para volver al menu');
	readln();
	ClrScr;
end;
procedure leerNovela(var act:novelas);
begin
	with act do begin
		write('Ingresar codigo de la novela: ');readln(codigo);
		write('Ingresar nombre de la novela: ');readln(nombre);
		write('Ingresar genero de la novela: ');readln(genero);
		write('Ingresar precio de la novela: ');readln(precio);
	end;
end;
procedure incisoBA(var arch:archivoNovelas);
var
	act:novelas;
begin
	leerNovela(act);
	reset(arch);
	seek(arch,FileSize(arch));
	write(arch,act);
	close(arch);
end;
procedure incisoBB(var arch:archivoNovelas;modificar:integer);
var
	act:novelas;
	cond:boolean;
begin
	reset(arch);cond:=false;
	while((not EOF(arch)) and (not cond)) do begin
		read(arch,act);
		if(act.codigo=modificar) then begin
			cond:=true;
			with act do begin
				write('Modifique el nombre: ');readln(nombre);
				write('Modifique el genero: ');readln(genero);
				write('Modifique el precio: ');readln(precio);
			end;
			seek(arch,FilePos(arch)-1);
			write(arch,act);
		end;
	end;
	close(arch);
end;
procedure incisoB(var arch:archivoNovelas);
var
	opcion:char;
	modificar:integer;
begin
	repeat
		writeln('---------menu---------');
		writeln('a:Agregar una novela al final del archivo');
		writeln('b:Modificar una novela existente, la busqueda se realiza por codigo de novela');
		writeln('z:volver al menu');
		writeln('----------------------');
		readln(opcion);
		ClrScr;
		case opcion of
			'a':
				begin
					incisoBA(arch);
					writeln('Se ingreso el elemento oprima una tecla para volver al menu');
					readln();
					ClrScr;
				end;
			'b':
				begin 
					write('Ingresar un codigo de novela para modificar');readln(modificar);
					incisoBB(arch,modificar);
					writeln('Se modifico el archivo oprima una tecla para volver al menu');
					readln();
					clrScr;
				end;
			'z':
			else writeln('La opcion no fue valida');
		end;
	until(opcion='z');
end;
procedure imprimirArchivo(var arch:archivoNovelas);
var
	act:novelas;
begin
	reset(arch);
	while(not EOF(arch)) do begin
		read(arch,act);
		with(act) do writeln('codigo: ',codigo,' nombre: ',nombre,' genero: ',genero,' precio: ',precio:1:2);
	end;
	close(arch);
	write('Se termino de recorrer el archivo, oprima una tecla para volver al menu ');readln();
end;
var
	cond:boolean;
	opcion:char;
	arch:archivoNovelas;
	nombreLogico:string;
begin
	repeat
		menu;
		readln(opcion);
		ClrScr;
		case opcion of 
			'a':
				begin
					cond:=true;
					incisoA(arch,nombreLogico);
				end;
			'b': 
				begin
					if(not cond) then begin
						write('Ingrese un nombre de archivo para trabajar: '); readln(nombreLogico);
						assign(arch,nombreLogico);
						cond:=true;
					end;
					incisoB(arch);
				end;
			'c':
				begin
					if(not cond) then begin
						write('ingresar un nombre de archivo binario para trabajar: ');readln(nombreLogico);
						assign(arch,nombreLogico);
						cond:=true;
					end;
					imprimirArchivo(arch);
				end;
			'z': 
			else writeln('No es valido');
		end;
	until(opcion='z');
end.
