program ej3;
const
	VALORCORTE=32767;
	N=5;
type
	productoM=record
		cod:integer;
		nombre:string;
		descripcion:string;
		stockDisp:integer;
		stockMin:integer;
		precio:real;
	end;
	productoD=record
		cod:integer;
		cantVendida:integer;
	end;
	maestro = FILE OF productoM;
	detalle = FILE OF productoD;
	arc_detalle = array[1..N] of detalle;
	reg_detalle = array[1..N] of productoD;
	nombresVector = array[1..N] of string;
procedure leer(var aD:detalle;var dato:productoD);
begin
	if (not EOF(aD)) then read(aD,dato)
	else dato.cod:=VALORCORTE;
end;
procedure minimo(var registro: reg_detalle;var min:productoD; var deta:arc_detalle);
var
	i,indiceMin:integer;
begin
	indiceMin:=0;
	min.cod:=VALORCORTE;
	for i:= 1 to N do
		if(registro[i].cod <> VALORCORTE) then
			if(registro[i].cod < min.cod) then begin
				min := registro[i];
				indiceMin := i;
			end;
	if(indiceMin <> 0) then 
		leer(deta[indiceMin], registro[indiceMin]);
end;
procedure actualizar(var aM:maestro; var deta:arc_detalle);
var
	i,codAct,cantVent:integer;
	min:productoD;
	regD:reg_detalle;
	regM:productoM;
begin
	for i := 1 to N do begin
		reset(deta[i]);
		leer(deta[i],regD[i]);
	end;
	reset(aM);
	minimo(regD,min,deta);
	while(min.cod <> VALORCORTE) do begin
		codAct := min.cod;
		cantVent:=0;
		while(min.cod = codAct) do begin
			cantVent := cantVent + min.cantVendida;
			minimo(regD, min, deta);
		end;
		read(aM, regM);
		while(regM.cod <> codAct) do begin
			read(aM,regM);
		end;
		seek(aM,filepos(aM)-1);
		writeln('CANTIDAD DISMINUIDA: ',cantVent);
		regM.stockDisp := regM.stockDisp - cantVent;
		write(aM,regM);
	end;
	for i := 1 to N do close(deta[i]);
	close(aM);
end;
procedure listarTxt(var aM:maestro);
var
	aT:text;
	act:productoM;
begin
	assign(aT,'listado2.txt');
	rewrite(aT);
	reset(aM);
	while(not EOF(aM)) do begin
		read(aM,act);
		with act do begin
			if(stockDisp < stockMin) then begin
				writeln(aT, cod, ' ', stockDisp, ' ', stockMin, ' ', precio:1:2, ' ', nombre);
				writeln(aT, descripcion);
			end;
		end;
	end;
	close(aT);
	close(aM);
end;
procedure crearMaestro();
var
	nombreMaestro:string;
	regM:productoM;
	aM:maestro;
begin
	write('Ingresar nombre del maestro'); readln(nombreMaestro);
	assign(aM,nombreMaestro);
	rewrite(aM);
	with regM do begin
		write('Ingresar codigo del producto: ');readln(cod);
		while(cod<>-1) do begin
			writeln('Ingresar nombre del producto: ');
			readln(nombre);
			writeln('Ingresar descripcion del producto: ');
			readln(descripcion);
			writeln('Ingresar stock disponible del producto: ');
			readln(stockDisp);
			writeln('Ingresar stock minimo del producto: ');
			readln(stockMin);
			writeln('Ingresar precio del producto: ');
			readln(precio);
			write(aM,regM);
			writeln('Ingresar codigo del producto: ');
			readln(cod);
		end;
	end;
	close(aM);
end;
procedure pasarTxt(var aM:maestro);
var
	aT:text;
	act:productoM;
begin
	assign(aT,'completo3.txt');
	rewrite(aT);
	reset(aM);
	while(not EOF(aM)) do begin
		read(aM,act);
		with act do begin
				writeln(aT, cod, ' ', stockDisp, ' ', stockMin, ' ', precio:1:2, ' ', nombre);
				writeln(aT, descripcion);
		end;
	end;
	close(aT);
	close(aM);
end;
procedure crearDetalles();
var
	i:integer;
	nombreDeta:string;
	deta:arc_detalle;
	productoact:productoD;
	regD:productoD;
begin
	for i:=1 to N do begin
		readln(nombreDeta);
		assign(deta[i],nombreDeta);
		rewrite(deta[i]);
	end;
	for i:= 1 to N do begin
		with productoAct do begin
			writeln('Ingresar codigo');
			readln(cod);
			while(cod<>-1) do begin
				writeln('Ingresar ventas');
				readln(cantVendida);
				write(deta[i],productoAct);
				writeln('Ingresar codigo');
				readln(cod);
			end;
			writeln('Impresion del detalle: ');
			reset(deta[i]);
			while(not EOF(deta[i])) do begin
				read(deta[i],regD);
				writeln('codigo: ',regD.cod,' cant vendida: ',regD.cantVendida);
			end;
		end;
	end;
	for i:= 1 to N do close(deta[i]);
end;
var
	aM:maestro;
	deta:arc_detalle;
	i:integer;
	nombreDetalle,nombreMaestro:string;
begin
	//crearMaestro;
	//crearDetalles;
	for i:=1 to N do begin
		readln(nombreDetalle);
		assign(deta[i],nombreDetalle);
	end;
	readln(nombreMaestro);
	assign(aM,nombreMaestro);
	actualizar(aM,deta);
	pasarTxt(aM);
	listarTxt(aM);
end.
