unit Poligono;
 interface
 uses
   Classes,Graphics,ExtCtrls,Math;
 type
   Vertice = Record
      x,y,z : Double;
   end;

  { Classe base }
  TPoligono = class
   private
     { Métodos definidos nesta classe }
   published
     { Método construtor }
     constructor Create(tipo_obj : Integer);
   public
     tipo   : Integer;
     pontos : Array of Vertice;
     xmax,ymax,zmax : Double;
     procedure Desloca(val : Integer);
   end;

 const
     CUBO = 8;
     TETRAEDRO = 4;

 implementation

 constructor TPoligono.Create(tipo_obj : Integer);
 begin
   SetLength(pontos,tipo_obj);
   
   case tipo_obj of
      CUBO : begin
       pontos[0].x := (xmax/2)-50;
       pontos[0].y := (ymax/2)-50;
       pontos[0].z := (zmax/2)-50;
       pontos[1].x := (xmax/2)+50;
       pontos[1].y := (ymax/2)-50;
       pontos[1].z := (zmax/2)-50;
       pontos[2].x := (xmax/2)+50;
       pontos[2].y := (ymax/2)+50;
       pontos[2].z := (zmax/2)-50;
       pontos[3].x := (xmax/2)-50;
       pontos[3].y := (ymax/2)+50;
       pontos[3].z := (zmax/2)-50;
       //---------
       pontos[4].x := (xmax/2)-50;
       pontos[4].y := (ymax/2)-50;
       pontos[4].z := (zmax/2)+50;
       pontos[5].x := (xmax/2)+50;
       pontos[5].y := (ymax/2)-50;
       pontos[5].z := (zmax/2)+50;
       pontos[6].x := (xmax/2)+50;
       pontos[6].y := (ymax/2)+50;
       pontos[6].z := (zmax/2)+50;
       pontos[7].x := (xmax/2)-50;
       pontos[7].y := (ymax/2)+50;
       pontos[7].z := (zmax/2)+50;
      end;
      TETRAEDRO : begin
       pontos[0].x := (xmax/2);
       pontos[0].y := (ymax/2)-50;
       pontos[0].z := (zmax/2);
       pontos[1].x := (xmax/2)+50;
       pontos[1].y := (ymax/2)+50;
       pontos[1].z := (zmax/2)+50;
       pontos[2].x := (xmax/2);
       pontos[2].y := (ymax/2)+50;
       pontos[2].z := (zmax/2)-50;
       pontos[3].x := (xmax/2)-50;
       pontos[3].y := (ymax/2)+50;
       pontos[3].z := (zmax/2)+50;
      end;
   end;
   tipo := tipo_obj;
 end;

procedure TPoligono.Desloca(val: Integer);
   var i : Integer;
begin
   for i:=0 to (tipo-1) do begin
       pontos[i].x := pontos[i].x+val;
   end;
end;

end.
