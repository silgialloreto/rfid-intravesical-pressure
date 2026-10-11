clear all

f0 = 0.9e9;
u0 = 4*pi*10^-7;
eps0=8.854e-12;
Zair=377;
%% Proprietà sistema 
%% Vescica
bladder_conductivity = 0.38308;
epsr_bladder = 18.936;
eps_bladder = epsr_bladder*eps0 - (1i*bladder_conductivity)/(2*pi*f0);
rbody = 1e-2;
d = rbody;
rimpl = linspace(0.05e-2,0.6e-2,20);
Gain = 2.15;
eta_total = zeros(1,4);
%% Grasso
fat_conductivity = 0.051043;
epsr_fat = 5.462;
eps_fat = epsr_fat*eps0 - (1i*fat_conductivity)/(2*pi*f0);

%rbody2 = 6e-2;
rbody2=6e-2;
d2=rbody2;
rimpl2 =0.5e-2;

for i=1:length(rimpl)
%% near-field TE
num= u0*abs(eps_fat)*2*pi*f0 - 2*sqrt(u0)*imag(sqrt(eps_fat))*d2^-1;
den =u0*abs(eps_fat)*2*pi*f0 - 2*sqrt(u0)*imag(sqrt(eps_fat))*rimpl(i)^-1;

near_field_TE =num/den;

%% near-field TM
num1 = (u0^1.5)*real(sqrt(eps_fat))*(2*pi*f0)^3 + imag(eps_fat^-1)*d2^-3;
den1 = (u0^1.5)*real(sqrt(eps_fat))*(2*pi*f0)^3 + imag(eps_fat^-1)*rimpl(i)^-3;
near_field_TM = num1/den1;

%% propagation TE/TM

propagation = exp(2*sqrt(u0)*imag(sqrt(eps_fat))*2*pi*f0*(d2-rimpl(i)));

%% Reflection TE

num2 = (u0^1.5)*sqrt(eps0*epsr_fat)*(2*pi*f0)^2*rbody2^2 - 1i*u0*2*pi*f0*rbody2;
den2 = u0*eps0*epsr_fat*(2*pi*f0)^2*rbody2^2 - 1i*sqrt(u0*eps0*epsr_fat)*2*pi*f0*rbody2 - 1;

Zm_TE = num2/den2;

%Zm_TE = sqrt(u0/(eps0*epsr_fat));

T_TE = (2*Zair)/(Zair+Zm_TE);

reflection_TE = (real(abs((T_TE)^2)/Zair)/(real(1/Zm_TE)));

%% Reflection TM

num3 = (u0^1.5)*sqrt(eps0*epsr_fat)*(2*pi*f0)^2*rbody2^2 - 1i*u0*2*pi*f0*rbody2 - sqrt((u0)/(eps0*epsr_fat));
den3 = u0*eps0*epsr_fat*(2*pi*f0)^2*rbody2^2 - 1i*sqrt(u0*eps0*epsr_fat)*2*pi*f0*rbody2;

Zm_TM = num3/den3;

%Zm_TM = sqrt(u0/(eps0*epsr_fat));

T_TM = (2*Zair)/(Zair+Zm_TM);

reflection_TM = (real(abs((T_TM)^2)/Zair)/(real(1/Zm_TM)));

%% Efficienza totale (scegliere tra TE e TM)

eta_total(i) = near_field_TE*propagation*reflection_TE;

end 
figure()
plot(rimpl*100,(10*log(eta_total)),color='r',LineWidth=2)
title('Varazione Efficienza Modi TE')
ylabel('Efficienza totale [dB]')
xlabel('rimpl [cm]')