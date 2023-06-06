program ej6;
uses crt;
const 
	VALORCORTE = 32767;
type
	prenda = record
		codigo:integer;
		descripcion:string;
		colores:string;
		tipo:string;
		stock:integer;
		precio:real;
	end;
	arcPrendas = FILE OF prenda;
	arcBajas = FILE OF integer;
procedure bajaPorArchivo(var aP:arcPrendas;var aB:arcBajas);
var
	codAct:integer;
	regM:prenda;
	
begin
	reset(aB);
	reset(aP);
	leer(aB,codAct);
	while(codAct<>VALORCORTE) do begin
		while((regM.codigo<>codAct)) do 
			leerPrenda(aP,regM);
		if(regM.codigo=codAct) then begin
			regM.stock:=regM.stock*-1;
			seek(aP,filepos(aP)-1);
			write(aP,regM);
		end;
	end;
	close(aB);
	close(aP);
end;
procedure compactarArchivo(var a:arcPrendas);
var
	regM:prenda;
	arcAux:arcPrendas;
begin
	reset(a);
	assign(arcAux,'nombre');
	rewrite(arcAux);
	leerPrenda(a,regM);
	while(regM.codigo<>VALORCORTE) do begin
		if(regM.stock>=0) then 
			write(arcAux,regM);
		leerPrenda(a,regM);
	end;
	close(a);
	close(arcAux);
end;
