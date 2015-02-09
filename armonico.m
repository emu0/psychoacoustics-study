function [x]=armonico(Amplitud, frecuencia, duracion)

%Definimos nuestras variables
%Frecuencia de muestreo y periodo. Con un frecuencia 
%de muestreo de 44Khz nos aseguramos de cumplir con el 
%teorema de Nyquist con cualquier onda de frecuencia 
%audible por el ser humano.
fm=44000;
Tm=1/fm;

%frecuencia angular
w=2*pi*frecuencia;
%Numero de muestras
N=duracion/Tm;
[n]=1:1:N;

%Los datos de la señal armonica sera
[x]=Amplitud*cos(w*Tm*n);
