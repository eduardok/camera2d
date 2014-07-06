unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Poligono, Math;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    tela: TImage;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
  private
    camera,vs,ks,il,jl : Vertice;
    objetos : array of TPoligono;
    xmax,ymax,zmax : Double;
    distancia : Double;
    procedure adicionaObjeto(tipo : Integer);
    procedure Desenha;
    procedure Calcula_Base;
    function Visao_Camera(p : Vertice) : Vertice;
    function p3d_p2d(p : Vertice) : Vertice;
  end;

var
   Form1: TForm1;

const
   CUBO = 8;
   TETRAEDRO = 4;

implementation

{$R *.DFM}

{ TForm1 }

//Adiciona um novo objeto à 'cena'
procedure TForm1.adicionaObjeto(tipo: Integer);
begin
   SetLength(objetos,Length(objetos)+1);
   objetos[Length(objetos)-1] := TPoligono.Create(tipo);
   objetos[Length(objetos)-1].xmax := xmax;
   objetos[Length(objetos)-1].ymax := ymax;
   objetos[Length(objetos)-1].zmax := zmax;
end;

//Calcula a base da camera sintética
procedure TForm1.Calcula_Base;
var modulo : Double;
begin
   //Calculo Vs
   vs.x := (xmax/2)-camera.x;
   vs.y := (ymax/2)-camera.y;
   vs.z := (zmax/2)-camera.z;
   //Calculo Ks
   modulo := sqrt(power(vs.x,2)+power(vs.y,2)+power(vs.z,2));
   ks.x := vs.x/modulo;
   ks.y := vs.y/modulo;
   ks.z := vs.z/modulo;

   //define J' como 0,1,0
   jl.x := 0;
   jl.y := 1;
   jl.z := 0;

   il.x := (jl.y*ks.z)-(jl.z*ks.y);
   il.y := (jl.z*ks.x)-(jl.x*ks.z);
   il.z := (jl.x*ks.y)-(jl.y*ks.x);
   modulo := sqrt(power(il.x,2)+power(il.y,2)+power(il.z,2));
   il.x := il.x/modulo;
   il.y := il.y/modulo;
   il.z := il.z/modulo;

   jl.x := (ks.y*il.z)-(ks.z*il.y);
   jl.y := (ks.z*il.x)-(ks.x*il.z);
   jl.z := (ks.x*il.y)-(ks.y*il.x);
   modulo := sqrt(power(jl.x,2)+power(jl.y,2)+power(jl.z,2));
   jl.x := jl.x/modulo;
   jl.y := jl.y/modulo;
   jl.z := jl.z/modulo;
end;

procedure TForm1.Desenha;
   var
      a,t,des : Integer;
      v : Vertice;
      pts : array[0..7] of Vertice;
begin
Calcula_Base();
   tela.Canvas.Rectangle(0,0,tela.width,tela.height);
   des := 200; 
   for a:=0 to Length(objetos)-1 do begin
      //Ja calculo novos pontos e guardo no array pts 
      for t:=0 to objetos[a].tipo-1 do begin
         v := p3d_p2d(Visao_Camera(objetos[a].pontos[t]));
         pts[t] := v;
      end;
      //Agora parto pro desenho, usando pontos de pts
      case objetos[a].tipo of
         CUBO : begin
            tela.Canvas.Pen.Color := clRed;
            //Primeiro quadro
            tela.Canvas.MoveTo(Round(pts[0].x)+des,Round(pts[0].y)+des);
            for t:=1 to 3 do begin
               tela.Canvas.LineTo(Round(pts[t].x)+des,Round(pts[t].y)+des);
            end;
            tela.Canvas.LineTo(Round(pts[0].x)+des,Round(pts[0].y)+des);
            //Segundo quadro
            tela.Canvas.Pen.Color := clBlue;
            tela.Canvas.MoveTo(Round(pts[4].x)+des,Round(pts[4].y)+des);
            for t:=5 to 7 do begin
               tela.Canvas.LineTo(Round(pts[t].x)+des,Round(pts[t].y)+des);
            end;
            tela.Canvas.LineTo(Round(pts[4].x)+des,Round(pts[4].y)+des);
            //agora uno os 2 quadros
            tela.Canvas.Pen.Color := clSilver;
            for t:=0 to 3 do begin
               tela.Canvas.MoveTo(Round(pts[t].x)  +des,Round(pts[t].y)+des);
               tela.Canvas.LineTo(Round(pts[t+4].x)+des,Round(pts[t+4].y)+des);
            end;
         end;
         TETRAEDRO : begin
            tela.Canvas.Pen.Color := clRed;
            //Triangulo base
            tela.Canvas.MoveTo(Round(pts[1].x)+des,Round(pts[1].y)+des);
            for t:=2 to 3 do begin
               tela.Canvas.LineTo(Round(pts[t].x)+des,Round(pts[t].y)+des);
            end;
            tela.Canvas.LineTo(Round(pts[1].x)+des,Round(pts[1].y)+des);
            //Agora ligo o topo ao triangulo base
            tela.Canvas.Pen.Color := clGreen;
            for t:=1 to 3 do begin
               tela.Canvas.MoveTo(Round(pts[0].x)+des,Round(pts[0].y)+des);
               tela.Canvas.LineTo(Round(pts[t].x)+des,Round(pts[t].y)+des);
            end;
         end;
      end;
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   distancia := 200;
   camera.x := 100;
   camera.y := 250;
   camera.z := 200;
   Calcula_Base();
   xmax := tela.Width-tela.Left;
   ymax := tela.Height-tela.Top;
   zmax := tela.Height-tela.Top;
   adicionaObjeto(CUBO);
   adicionaObjeto(TETRAEDRO);
   objetos[Length(objetos)-1].desloca(110);
   Desenha();
end;

function TForm1.p3d_p2d(p : Vertice): Vertice;
   var
      tmp : Vertice;
      divisao : Double;
begin
   divisao := (p.z/distancia);
   if (not (divisao=0)) then begin
      tmp.x := (p.x/divisao);
      tmp.y := (p.y/divisao);
      end
   else begin
      tmp.x := (p.x/(divisao+1));
      tmp.y := (p.y/(divisao+1));
   end;
   tmp.z := 0; //nao usara mesmo
   Result := tmp;
end;

function TForm1.Visao_Camera(p: Vertice): Vertice;
   var ve,proj : Vertice;
begin
   proj.x := p.x-camera.x;
   proj.y := p.y-camera.y;
   proj.z := p.z-camera.z;

   ve.x := proj.x*il.x+proj.y*il.y+proj.z*il.z;
   ve.y := proj.x*jl.x+proj.y*jl.y+proj.z*jl.z;
   ve.z := proj.x*ks.x+proj.y*ks.y+proj.z*ks.z;
   Result := ve;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
   camera.x := camera.x+1;
   Desenha;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
   camera.x := camera.x-1;
   Desenha;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
   camera.y := camera.y+1;
   Desenha;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
   camera.y := camera.y-1;
   Desenha;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
   camera.z := camera.z+1;
   Desenha;
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
begin
   camera.z := camera.z-1;
   Desenha;
end;

procedure TForm1.BitBtn11Click(Sender: TObject);
begin
   distancia := distancia+1;
   Desenha;
end;

procedure TForm1.BitBtn12Click(Sender: TObject);
begin
   distancia := distancia-1;
   Desenha;
end;

end.
