%% Se importan los valores de las velocidades de viento en los vectores v40,
%v50, v60, mes_del_dato con herramienta de importanción de datos de matlab
load datos_importados

%% Problema 1
%Promedios de velocidades
v40_promedio=mean(v40);
v50_promedio=mean(v50);
v60_promedio=mean(v60);

%Valores de altura
h=[40;50;60];

%Ley logaritmica
X=log(h);
Y=[v40_promedio; v50_promedio; v60_promedio];
B=polyfit(X,Y,1);

%Calculo en H=117m
v117_promedio=B(1)*log(117)+B(2);
%Gráfica de regresión utilizada
Xnuevo=[X;log(117)]; Ynuevo=[Y; v117_promedio];
figure(1), hold on, plot(Xnuevo,Ynuevo,'*',linspace(min(Xnuevo),max(Xnuevo),1000),linspace(min(Ynuevo),max(Ynuevo),1000)), title('Regresión logaritmica de velocidades promedio'), xlabel('ln(h)'), ylabel('v(h)'), hold off ;

%Aplicación de la ley logaritmica para cada paso de tiempo de 1 hora
v117=zeros(8992,1);
for t=1:8992
    Y=[v40(t);v50(t);v60(t)];
    B=polyfit(X,Y,1);
    v117(t)=B(1)*log(117)+B(2);
end

figure(2), hold on, plot(1:8992,v117), xlabel('Hora del año'), ylabel('velocidad del viento [m/s]'), hold off
figure(3), hold on, histogram(v117,20), xlabel('velocidad del viento [m/s]'), ylabel('frecuencia'), hold off

numero_de_valores_negativos=length(v117(v117<0));
%% Problema 2
%Perfiles diarios
v40_diario=zeros(24,1); v50_diario=zeros(24,1); v60_diario=zeros(24,1); v117_diario=zeros(24,1);
for h=1:24
    v40_diario(h)=mean(v40(h:24:end));
    v50_diario(h)=mean(v50(h:24:end));
    v60_diario(h)=mean(v60(h:24:end));
    v117_diario(h)=mean(v117(h:24:end));
end

%Gráficas
figure(4), hold on, plot(1:24, v40_diario,1:24, v50_diario,1:24, v60_diario,1:24, v117_diario), title('Perfil diario de velocidad de viento'), xlabel('hora'), ylabel('velocidad [m/s]'), legend('40m','50m','60m','117m'), hold off

%Obtención del valor minimo de velocidad para cada altura con su indice que
%indica la hora en que sucede
[v40_minimo, indice40]=min(v40_diario);
[v50_minimo, indice50]=min(v50_diario);
[v60_minimo, indice60]=min(v60_diario);
[v117_minimo, indice117]=min(v117_diario);
%"Interpretación: se observa que el minimo ocurre entre las 7 y 8 de la mañana a diferentes alturas"

%% Problema 3
%Constantes
densidad=1.1; cp=0.5; vcutin=3; vd=10; A=pi*(50)^2;
Pnom=(0.5)*densidad*A*cp*(vd-vcutin)^3;

%Constantes para factor de perdidas
f_disp=0.03; f_rend=0.06; f_estela=0.06; f_elec=0.02;
%Compu de factor de perdidas
f_perd=1-(1-f_disp)*(1-f_estela)*(1-f_rend)*(1-f_elec);

%Se calcula P(t) para cada dato
P40=potencia(v40);
P50=potencia(v50);
P60=potencia(v60);
P117=potencia(v117);

%Potencia promedio
P40_promedio=mean(P40);
P50_promedio=mean(P50);
P60_promedio=mean(P60);
P117_promedio=mean(P117);

%Potencia util considerando perdidas en Watts
P40_util=P40_promedio*(1-f_perd);
P50_util=P50_promedio*(1-f_perd);
P60_util=P60_promedio*(1-f_perd);
P117_util=P117_promedio*(1-f_perd);

%Computo de energía promedio en MW
P40_util_MW=P40_util*10^-6;
P50_util_MW=P50_util*10^-6;
P60_util_MW=P60_util*10^-6;
P117_util_MW=P117_util*10^-6;

%Energía anual generada en MWh
E40=P40_util_MW*365*24;
E50=P50_util_MW*365*24;
E60=P60_util_MW*365*24;
E117=P117_util_MW*365*24;

%Factor de planta
fp40=P40_util/Pnom;
fp50=P50_util/Pnom;
fp60=P60_util/Pnom;
fp117=P117_util/Pnom;

%% Problema 4
%Calculo de perfiles estacionales de las cuatro velocidades de viento y de
%la producción neta de potencia
%Se importa la columna del número del mes de cada renglon de dato del excel
%haciendo un uso extensivo de la función buscar y remplazar para limpiar
%los datos

%mes=["Enero", "Febrero", "Marzo", "Abril","Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];

v40_mensual=zeros(12,1); v50_mensual=zeros(12,1); v60_mensual=zeros(12,1); v117_mensual=zeros(12,1);
for c=1:12
    v40_mensual(c)=mean(v40(mes_del_dato==c));
    v50_mensual(c)=mean(v50(mes_del_dato==c));
    v60_mensual(c)=mean(v60(mes_del_dato==c));
    v117_mensual(c)=mean(v117(mes_del_dato==c));
end
%Gráfica para perfil de velocidad mensual promedio
figure(5), hold on, plot(1:12, v40_mensual, 1:12, v50_mensual, 1:12, v60_mensual, 1:12, v117_mensual), title('Perfil estacional de velocidad de viento'), xlabel('Mes'), ylabel('velocidad [m/s]'), legend('40m','50m','60m','117m'), hold off;

p40_mensual=zeros(12,1); p50_mensual=zeros(12,1); p60_mensual=zeros(12,1); p117_mensual=zeros(12,1);
for c=1:12
    p40_mensual(c)=mean(potencia(v40(mes_del_dato==c)));
    p50_mensual(c)=mean(potencia(v50(mes_del_dato==c)));
    p60_mensual(c)=mean(potencia(v60(mes_del_dato==c)));
    p117_mensual(c)=mean(potencia(v117(mes_del_dato==c)));
end
%Gráfica para perfil de potencia mensual promedio
figure(6), hold on, plot(1:12, p40_mensual, 1:12, p50_mensual, 1:12, p60_mensual, 1:12, p117_mensual), title('Perfil estacional de potencia promedio de viento'), xlabel('Mes'), ylabel('Potencia [W]'), legend('40m','50m','60m','117m'), hold off;

%Se define la función de potencia que tiene como valor de retorno un vector
%de P que representa la potencia respectiva a cada valor del vector de
%entrada v
function P=potencia(v)
    densidad=1.1; cp=0.5; vcutin=3; vd=10; A=pi*(50)^2; Pnom=(0.5)*densidad*A*cp*(vd-vcutin)^3;
    P=zeros(length(v),1);
    for t=1:length(v)
        if(v(t)<vcutin)
            P(t)=0;
        elseif((vcutin<=v(t))&&(v(t)<=vd))
            P(t)=(0.5)*densidad*A*cp*(v(t)-vcutin)^3;
        else
            P(t)=Pnom;
        end
    end
end




