program ej5;
uses
	crt;
type
	celulares=record
		codigo:integer;
		nombre:string;
		descripcion:string;
		marca:string;
		precio:real;
		stockMinimo:integer;
		stock:integer;
	end;
	archivoCelulares=FILE OF celulares;
procedure menu;
begin
	writeln('---------Ingrese una opcion---------');
	writeln('a: Crea un archivo de registros no ordenados de celulares y cargarlo con datos ingresados desde un archivo "celulares.txt"');
	writeln('b: Listar en pantalla los datos de los celulares con stock menor al minimo');
	writeln('c: Listar en pantalla los celulares del archivo cuya descripcion tenga una cadena de caracteres proporcionada por el usuario');
	writeln('d: Exportar el archivo creado en el inciso a) a un archivo de texto denominado "celulares.txt"');
	writeln('z: Finalizar el programa');
	writeln('------------------------------------');
end;
procedure incisoA(var arch:archivoCelulares;var nombre:string);
var
	act:celulares;
	archText:text;
begin
	writeln('Ingresar nombre para el archivo de celulares: ');
	readln(nombre);
	assign(archText,'celulares.txt');
	assign(arch,nombre);
	reset(archText);
	rewrite(arch);
	while not eof(archText) do begin
		with act do begin
			readln(archText, codigo, precio, marca);
			readln(archText, stock, stockMinimo, descripcion);
			readln(archText, nombre);
		end;
		write(arch,act);
	end;
	close(arch);
	close(archText);
	writeln('Archivo creado, oprima ingrese una tecla para volver al menu');
	readln();
	clrScr;
end;
procedure imprimirCelular(act:celulares);
begin
	writeln('codigo: ',act.codigo,' precio: ',act.precio:1:2,' marca: ',act.marca);
	writeln('stock disponible: ',act.stock,' stock minimo: ',act.stockMinimo, 'descripcion: ',act.descripcion);
	writeln('nombre: ',act.nombre);
end;
procedure incisoB(var arch:archivoCelulares);
var
	act:celulares;
begin
	reset(arch);
	while(not EOF(arch)) do begin
		read(arch,act);
		if(act.stock<act.stockMinimo) then imprimirCelular(act);
	end;
	close(arch);
	writeln('Finalizo el recorrido, ingrese una tecla para volver al menu');
	readln();
	clrScr;
end;
procedure incisoC(var arch:archivoCelulares;coincidencia:string);
var
	act:celulares;
begin
	coincidencia:= ' '+coincidencia;{revisar esto}
	reset(arch);
	while(not EOF(arch)) do begin
		read(arch,act);
		if(act.descripcion=coincidencia) then imprimirCelular(act);
	end;
	close(arch);
end;
procedure incisoD(var arch:archivoCelulares);
var
	act:celulares;
	archText:text;
begin
	assign(archText,'celulares.txt');
	rewrite(archText);
	reset(arch);
	while(not EOF(arch)) do begin
		read(arch,act);
		writeln(archText,act.codigo,' ', act.precio:1:2,' ', act.marca);
		writeln(archText,act.stock,' ',act.stockMinimo,' ',act.descripcion);
		writeln(archText,act.nombre);
	end;
	close(arch);
	close(archText);
	writeln('Termino el recorrido, ingrese una tecla para volver al menu');
	readln();
	clrScr;
end;
procedure ocasional(var arch:archivoCelulares;var nombre:string;var cond:boolean);
begin
	write('No se ejecuto la opcion a, ingrese un nombre de archivo para trabajar: ');readln(nombre);
	assign(arch,nombre);
	cond:=true;
	writeln('A partir de ahora se trabajara con el archivo : ',nombre);
	writeln('Ingrese una tecla para volver al menu');
	readln();
	clrScr;;
end;
var
	opcion:char;
	cond:boolean;
	arch:archivoCelulares;
	coincidencia,nombre:string;
begin
	repeat 
		menu;
		readln(opcion);
		clrScr;
		case opcion of 
			'a':
				begin
					cond:=true;
					incisoA(arch,nombre);
				end;
			'b':
				begin
					if(not cond) then ocasional(arch,nombre,cond);
					incisoB(arch);
				end;
			'c':
				begin
					if(not cond) then ocasional(arch,nombre,cond);
					write('Ingrese una coincidencia para buscar: ');readln(coincidencia);
					incisoC(arch,coincidencia);
				end;
			'd':
				begin
					if(not cond) then ocasional(arch,nombre,cond);
					incisoD(arch);
				end;
			'z':
			else writeln('La opcion no fue valida');
		end;
	until(opcion='z');
end.
