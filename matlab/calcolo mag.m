clear all

S11 = -0.0404 - 1i*0.1228;
S12 = -0.0041 - 1i*0.0078;
S21 = 0.0139 + 1i*0.0170;
S22 = 0.1970 - 1i*0.0585;

g_num = abs(S21)^2;
g_den = (1 - (abs(S11))^2)*(1 - (abs(S22))^2);

g2 = g_num/g_den;
g2 = 10*log10(g2);

k_num = 1 - (abs(S11))^2 - (abs(S22))^2 + (abs(S11*S22 - S12*S21))^2;
k_den = 2*abs(S12*S21);

k = k_num/k_den;

MAG_num = abs(S21)*(k - sqrt(k^2 - 1));
MAG_den = abs(S12);

MAG = MAG_num/MAG_den
MAG = 10*log10(MAG)

%% boxplot
clear all, close all;
Pavg1 = [0.707, 0.14, 0.107, 1.659, 0.433, 0.234, 0.1, 0.027, 0.014 ];
Pavg2 = [0.354, 0.097, 0.053, 0.831, 0.222, 0.117, 0.05, 0.013, 0.007 ];

% Combinazione dei dati
dati = [Pavg1, Pavg2];
gruppi = [ones(1, length(Pavg1)), 2*ones(1, length(Pavg2))];

% Boxplot
boxplot(dati, gruppi, 'Labels', {'ps=-13dBm', 'ps=-16dBm'});

% Titolo e asse y
title('Boxplot Pav,g per chip a 2 diverse sensitivity');
ylabel('Pav,g');
