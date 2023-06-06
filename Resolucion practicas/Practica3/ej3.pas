program ej3;
uses crt;
const
	VALORCORTE = 32767;
type
	novela = record
		codigo:integer;
		genero:string;
		nombre:string;
		duracion:real;
		director:string;
		precio:real;
	end;
	archivoNovelas = FILE OF novela;
procedure leerNovela(var act:novela);
begin	
	write('Ingresar codigo de novela ');readln(act.codigo);
	if(act.codigo<>-1) then begin
		with act do begin
			write('Ingresar genero ');readln(genero);
			write('ingresar nombre ');readln(nombre);
			write('ingresar duracion ');readln(duracion);
			write('ingresar director ');readln(director);
			write('ingresar precio ');readln(precio);
		end;
	end;
end;
procedure leerArc(var arch:archivoNovelas;var regM:novela);
begin
	if(not EOF(arch)) then
		read(arch,regM)
	else
		regM.codigo:=VALORCORTE;
end;
procedure crearArchivo(var arch:archivoNovelas);
var
	regM:novela;
begin
	rewrite(arch);
	regM.codigo:=0;
	write(arch,regM);
	leerNovela(regM);
	while(regM.codigo<>-1) do begin
		write(arch,regM);
		leerNovela(regM);
	end;
	close(arch);
end;
procedure altaNovela(var arch:archivoNovelas;var act:novela);
var
	aux:integer;
	regM:novela;
begin
	reset(arch);
	read(arch,regM);
	if(regM.codigo<>0) then begin
		aux:=regM.codigo;
		seek(arch,aux*-1);
		read(arch,regM);
		aux:=regM.codigo;
		seek(arch,filepos(arch)-1);
		write(arch,act);
		seek(arch,0);
		read(arch,regM);
		regM.codigo:=aux;
		seek(arch,filePos(arch)-1);
		write(arch,regM);
	end
	else begin
		seek(arch,filesize(arch));
		write(arch,act);
	end;
	close(arch);
end;
procedure modificarDatos(var arch:archivoNovelas;codMod:integer);
var
	regM:novela;
begin	
	reset(arch);
	leerArc(arch,regM);
	while((regM.codigo<>VALORCORTE) and (regM.codigo<>codMod)) do 
		leerArc(arch,regM);
	if(regM.codigo<>VALORCORTE) then
		with regM do begin
			write('ingresar modificacion de genero '); readln(genero);
			write('Ingresar modificacion de nombre '); readln(nombre);
			write('ingresar modificacion de la duracion '); readln(duracion);
			write('ingresar modificacion del director '); readln(director);
			write('ingresar modificacion del precio '); readln(precio);
		end;
	seek(arch,filepos(arch)-1); 
	write(arch,regM);
	close(arch);
end;
procedure eliminarNovela(var arch:archivoNovelas; codBor:integer);
var
	regM:novela;
	aux:integer;
	indice:novela;
begin
	reset(arch);
	leerArc(arch,regM);
	aux := regM.codigo;
	while((regM.codigo<>VALORCORTE) and (regM.codigo<>codBor)) do 
		leerArc(arch,regM);
	if(regM.codigo<>VALORCORTE) then begin
		indice.codigo:= aux;
		seek(arch,filepos(arch)-1);
		aux:= filepos(arch)*-1;
		write(arch,indice);
		seek(arch,0);
		read(arch,regM);
		regM.codigo:=aux;
		seek(arch,filepos(arch)-1);
		write(arch,regM);
	end;
	close(arch);
end;
procedure listarTxt(var arch:archivoNovelas);
var
	txt:text;
	regM:novela;
begin
	assign(txt,'novelas.txt');
	rewrite(txt);
	reset(arch);
	leerArc(arch,regM);
	while(regM.codigo<>VALORCORTE) do begin
		with regM do begin
			writeln(txt,'codigo: ',codigo,' nombre: ',nombre);
			writeln(txt,'duracion: ',duracion, ' genero: ',genero);
			writeln(txt,'precio: ',precio, ' director: ',director);
			leerArc(arch,regM);
		end;
	end;
	close(txt);
	close(arch);
end;
procedure menu();
begin
	writeln('##################################################');
	writeln('MENU DE MANEJO DE ARCHIVO BRATAN ');
	writeln();
	writeln('a: CREAR ARCHIVO Y CARGARLO A PARTIR DE DATOS INGRESADOS POR TECLADO ');
	writeln('b: ABRIR UN ARCHIVO EXISTENTE Y REALIZAR MANTENIMIENTO');
	writeln('c: LISTAR EN UN ARCHIVO DE TEXTO TODAS LAS NOVELAS, INCLUYENDO LAS BORRADAS');
	writeln();
	writeln('##################################################');
end;
procedure menuB();
begin
	writeln('##################################################');
	writeln('OPCIONES DE MODIFICACION');
	writeln('1: DAR DE ALTA UNA NOVELA LEYENDO LA INFORMACION DESDE TECLADO ');
	writeln('2: MODIFICAR LOS DATOS DE UNA NOVELA LEYENDO LA INFORMACION DESDE TECLADO ');
	writeln('3: ELIMINAR UNA NOVELA CUYO CODIGO ES INGRESADO POR TECLADO ');
	writeln('##################################################');
end;
var
	arch:archivoNovelas;
	nombreArchivo:string;
	cond:char;
	condB:integer;
	regArc:novela;
	codigoMod:integer;
begin
	repeat
		menu;
		readln(cond);
		case cond of 
			'a':
				begin
					write('Ingresar nombre del archivo a crear: ');readln(nombreArchivo);
					assign(arch,nombreArchivo);
					crearArchivo(arch);
					write('Archivo creado');
					write('ingrese una tecla para volver al menu ');readln();
					clrscr;
				end;
			'b':
				begin
					write('Ingresar nombre del archivo a modificar: ');readln(nombreArchivo);
					assign(arch,nombreArchivo);
					menuB;
					readln(condB);
					case condB of 
						1:
							begin
								leerNovela(regArc);
								altaNovela(arch,regArc);
								writeln('se ingreso el elemento');
								write('Ingresar una tecla para volver al menu');readln();
								clrscr;
							end;
						2:
							begin
								write('Ingresar codigo de novela a modificar: ');readln(codigoMod);
								modificarDatos(arch,codigoMod);
								writeln('Se modifico el archivo');
								write('Ingresar una tecla para volver al menu');readln();
								clrscr;
							end;
						3:
							begin
								write('Ingresar codigo de novela a eliminar: ');readln(codigoMod);
								eliminarNovela(arch,codigoMod);
								writeln('Se elimino la novela');
								write('Ingresar una tecla para volver al menu');readln();
								clrscr;
							end;
					end;
				end;
			'c':
				listarTxt(arch);
			'z':
		end;
	until(cond = 'z');
end.
