% Study about Critical bands
% Author Emilio Jos� Mart�nez P�rez (Github user emu0)

%Script apartado 1
clear all;

%Variables del tono puro centrado en una frecuencia central
frecuencia=4000;
amplitud=0.8;
duracion=1;
%Variables del ruido. Ancho de banda y relaci�n SNR
Bw=1000;
snr=49;

%Tomamos la frecuencia central de una banda critica
[x]=armonico(amplitud, frecuencia, duracion);
% x=awgn(x, snr);
Fs=44000;
Ts=1/Fs;
N=length(x);
T=N/Fs;
Bw2=floor(Bw/2);
%Calculamos las frecuencias laterales
fu=frecuencia+Bw2;
fi=floor((frecuencia^2)/fu);

%Realizamos la DFT del vector
[xDFT]=fft(x);
%Algunas operaciones que hay que ealizarle al vecto
[xDFT]=xDFT(1:floor(N/2)+1);
[xDFT]=(2/N)*abs(xDFT);
%A�adimos el ruido en la banda indicada
xDFT((fi:frecuencia-1)/T)=awgn(xDFT((fi:frecuencia-1)/T), snr);
xDFT((frecuencia+2:fu)/T)=awgn(xDFT((frecuencia+2:fu)/T), snr);

%Vector de frcuencias
[fDFT]=(0:1:(length(xDFT)-1))*Fs/N;
%Vector de tiempo
[t]=(0:2*Ts:1)*N/Fs;

%Pasamos de nuevo al dominio del tiempo la se�al con ruido
xN=real(ifft(xDFT*Fs/2));

% Se puede ver la se�al con ruido tanto en el tiempo como en la frecuencia
figure(1);
plot(t, xN);
figure(2);
plot(fDFT, xDFT);

%Se pueden escuchar mabas se�ales con ruido y sin ruido
sound(xN, Fs/(2*N/Fs));
sound(x, Fs);