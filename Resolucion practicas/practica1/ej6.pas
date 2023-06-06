program ej6;
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
	writeln('e: Agrega uno o mas celulares al final del archivo con datos ingresados desde teclado');
	writeln('f: Modifica el stock de un celular dado');
	writeln('g: exportar el contenido del archivo binario a un archivo de texto denominado "sinStock.txt" con los celulares con stock 0');
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
procedure leerCelular(var act:celulares);
begin
	with act do begin
		write('Ingrese el codigo del celular: ');readln(codigo);
		write('Ingrese el nombre del celular: ');readln(nombre);
		write('Ingrese la descripcion del celular: ');readln(descripcion);
		write('Ingrese la marca del celular: ');readln(marca);
		write('Ingrese el precio del celular: ');readln(precio);
		write('Ingrese el stock minimo del celular: ');readln(stockMinimo);
		write('Ingrese el stock actual del celular: ');readln(stock);
	end;
end;
procedure insertar(var arch:archivoCelulares;act:celulares);
begin
	reset(arch);
	Seek(arch,FileSize(arch));
	write(arch,act);
	close(arch);
end;	
procedure incisoE(var arch:archivoCelulares);
var
	act:celulares;
	cond:char;
begin
	repeat
		leerCelular(act);
		insertar(arch,act);
		write('Ingrese cualquier caracter para seguir o N para terminar: ');readln(cond);
	until(cond='N');
	ClrScr;
end;
procedure incisoF(var arch:archivoCelulares;dado:string);
var
	act:celulares;
	encontro:boolean;
	nuevoStock:integer;
begin
	reset(arch);
	encontro:=false;
	while((not EOF(arch) and (not encontro))) do begin
		read(arch,act);
		if(act.nombre=dado) then begin
			encontro:=true;
			write('Ingrese el nuevo stock: ');readln(nuevoStock);
			act.stock:=nuevoStock;
			seek(arch,FilePos(arch)-1); 
			write(arch,act);
		end;
	end;
	close(arch);
	ClrScr;
end;
procedure incisoG(var arch:archivoCelulares);
var
	act:celulares;
	archText:text;
begin
	assign(archText,'SinStock.txt');
	rewrite(archText);
	reset(arch);
	while(not EOF(arch)) do begin
		read(arch,act);
		if(act.stock=0) then begin
			writeln(archText,act.codigo,' ', act.precio:1:2,' ', act.marca);
			writeln(archText,act.stock,' ',act.stockMinimo,' ',act.descripcion);
			writeln(archText,act.nombre);
		end;
	end;
	close(arch);
	close(archText);
	writeln('Se creo la lista "SinStock.txt oprima una tecla para volver al menu"');
	readln();
	ClrScr;
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
	cambio,coincidencia,nombre:string;
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
			'e':
				begin
					if(not cond) then ocasional(arch,nombre,cond);
					incisoE(arch);
				end;
			'f':
				begin
					if(not cond) then ocasional(arch,nombre,cond);
					write('Ingrese el nombre del celular para modificar el stock: ');readln(cambio);
					incisoF(arch,cambio);
				end;
			'g':
				begin
					if(not cond) then ocasional(arch,nombre,cond);
					incisoG(arch);
				end;
			'z':
			else writeln('La opcion no fue valida');
		end;
	until(opcion='z');
end.
