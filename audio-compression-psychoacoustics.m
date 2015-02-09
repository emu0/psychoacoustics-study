% Study about audio compression based in Psychoacoustics model
% Author Emilio José Martínez Pérez (Github user emu0)

%Script apartado 2

clear all;

%Estas son las variables a modificar por el usuario.
p=0.5;
t= 0;

%Leemos el archivo wav
[xwav, Fs]=wavread('bush.wav');
%Está en stereo lo pasamos a mono
xwav=xwav(:,2);

%Matriz de frecuencias centrales y sus máximos
frec=[[20, 50, 100];[100, 150, 200];[200, 250, 300];[300, 350, 400];[400, 450, 510];[510, 570,630];[630, 700,770];[770, 840,920];[920, 1000,1080];[1080, 1170, 1270];[1270, 1370, 1480];[1480, 1600, 1720];[1720, 1850, 2000];[2000, 2150, 2320];[2320, 2500, 2700];[2700, 2900, 3150];[3150, 3400, 3700];[3700, 4000, 4400];[4400, 4800, 5300];[5300, 5800, 6400];[6400, 7000, 7700];[7700, 8500, 9500];[9500, 10500, 12000];[12000, 13500, 15500]];
Ts=1/Fs;
%numero de elementos en la lectura del wav
N=length(xwav);
%Hacemos su dft y partimos en las bandas críticas
[xDFT]=fft(xwav);

%La variable xDFTrec será la señal reconstruida tras eliminar las
%frecuencias que no interesan
[xDFTrec]=0;
%Partimos el espectro en bandas criticas
for i=1:length(frec)
    xDFTcopy=xDFT(floor((frec(i,1)*N/Fs)):floor((frec(i,3)*N/Fs)));
    %xDFTaux será un vector auxiliar al que se le ira eliminando las
    %frecuencias cercanas al máximo encontrado, pero nunca el maximo.
    %a xDFTcopy se le eliminarán los valores máximos encontrados y sus
    %frecuencias cercanas para poder encontrar otro máximo en otra pasada del bucle.
    xDFTaux=xDFTcopy;
    %r será el total de porcentaje del vector que no es un valor nulo
    r=1;
    %t2 es el total de elementos a eleminir aldederor del máximo
    if (t==0)
        t2=1;
    else
        t2=floor(t*length(xDFTcopy));
    end
    %Si aún no se ha llegado a p deseado se siguen eliminando elementos.
    while r>p
        %buscamos el máximo
        m=find(xDFTcopy==max(xDFTcopy));
   
        %Y eliminamos la información
        
        %si el máximo está situado en un valor bajo hay que actuar de forma
        %diferente
        if(m<=t2)
            xDFTcopy(1:m+t2)=0;
            xDFTaux(1:m-1)=0;
            xDFTaux(m+1:m+t2)=0;
        elseif(length(xDFTcopy)-m<=t2)
            xDFTcopy(m-t2:length(xDFTcopy))=0;
            xDFTaux(m-t2:m-1)=0;
            xDFTaux(m+1:length(xDFTcopy))=0;
        else
            xDFTcopy(m-t2:m+t2)=0;
            xDFTaux(m-t2:m-1)=0;
            xDFTaux(m+1:m+t2)=0;
        end
        %modificamos el valor de elementos que quedan respecto al total
        if (t==0)
            r=r-(3/length(xDFTcopy));
        else
            r=r-(2*t);
        end
    end

    %La señal recuperada xDFTrec será la suma de todas las señales
    %auxiliares a las que le hemos quitado la información
    xDFTrec=[xDFTrec;xDFTaux];    
end

%Dado que la última banda crítica llega hasta los 15500Hz es conveniente rellenar hasta los 24000Hz
%que es la mitad de la frecuencia de muestreo.
%Se rellena el vector de frecuecias hasta llegar a la mitad del especto.
%Este relleno puede ser perfectamente ruido, puesto que en el original esta
%banda del espectro es muy pequeña y parece totalmente estocástica.
xDFTrec=[xDFTrec; awgn(zeros(((Fs/2)-15500)*N/Fs, 1), 8)];
n=length(xDFTrec);

%Se pasa al dominio del tiempo el espectro modificado
xN=real(ifft(xDFTrec));
%Se calcula la nueva frecuencia de muestreo
FsxN=n*Fs/N;
TsxN=1/FsxN;

%Vector de frecuencias
fDFT=(0:1:(length(xDFT)-1))*Fs/N;
%Vector de tiempo
[t]=(0:2*TsxN:1)*N/Fs;

%Se puede mostrar en grafica, escuchar y grabar el archivo
figure(1);
plot(xN);
figure(2);
plot(xwav);
figure(3);
plot(fDFT, xDFT);
figure(4);
plot(fDFT(1:length(xDFTrec)), xDFTrec);
sound(xN, FsxN);
sound(xwav, Fs);
wavwrite(xN, FsxN, 'nombrewav.wav');