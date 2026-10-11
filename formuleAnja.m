%% Costani fisiche
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
rbody = linspace(0.5e-2,2e-2,20);
d = rbody;
rimpl = 0.5e-2;
Gain = 2.15;
eta_total = zeros(1,20);
%% Grasso
fat_conductivity = 0.051043;
epsr_fat = 5.462;
eps_fat = epsr_fat*eps0 - (1i*fat_conductivity)/(2*pi*f0);

%rbody2 = 6e-2;
rbody2=linspace(4e-2,8e-2,20);
d2=rbody2;
rimpl2 =0.5e-2;

%% Caso solo Grasso
for i=1:length(d2)
%% near-field TE
num= u0*abs(eps_fat)*2*pi*f0 - 2*sqrt(u0)*imag(sqrt(eps_fat))*d2(i)^-1;
den =u0*abs(eps_fat)*2*pi*f0 - 2*sqrt(u0)*imag(sqrt(eps_fat))*rimpl^-1;

near_field_TE =num/den;

%% near-field TM
num1 = (u0^1.5)*real(sqrt(eps_fat))*(2*pi*f0)^3 + imag(eps_fat^-1)*d2(i)^-3;
den1 = (u0^1.5)*real(sqrt(eps_fat))*(2*pi*f0)^3 + imag(eps_fat^-1)*rimpl^-3;
near_field_TM = num1/den1;

%% propagation TE/TM

propagation = exp(2*sqrt(u0)*imag(sqrt(eps_fat))*2*pi*f0*(d2(i)-rimpl));

%% Reflection TE

num2 = (u0^1.5)*sqrt(eps0*epsr_fat)*(2*pi*f0)^2*rbody2(i)^2 - 1i*u0*2*pi*f0*rbody2(i);
den2 = u0*eps0*epsr_fat*(2*pi*f0)^2*rbody2(i)^2 - 1i*sqrt(u0*eps0*epsr_fat)*2*pi*f0*rbody2(i) - 1;

Zm_TE = num2/den2;

%Zm_TE = sqrt(u0/(eps0*epsr_fat));

T_TE = (2*Zair)/(Zair+Zm_TE);

reflection_TE = (real(abs((T_TE)^2)/Zair)/(real(1/Zm_TE)));

%% Reflection TM

num3 = (u0^1.5)*sqrt(eps0*epsr_fat)*(2*pi*f0)^2*rbody2(i)^2 - 1i*u0*2*pi*f0*rbody2(i) - sqrt((u0)/(eps0*epsr_fat));
den3 = u0*eps0*epsr_fat*(2*pi*f0)^2*rbody2(i)^2 - 1i*sqrt(u0*eps0*epsr_fat)*2*pi*f0*rbody2(i);

Zm_TM = num3/den3;

%Zm_TM = sqrt(u0/(eps0*epsr_fat));

T_TM = (2*Zair)/(Zair+Zm_TM);

reflection_TM = (real(abs((T_TM)^2)/Zair))/(real(1/Zm_TM));

%% Efficienza totale (scegliere tra TE e TM)

eta_total(i) = near_field_TE*propagation*reflection_TE;

end 
figure()
plot(rbody2*100,(10*log(eta_total)),color='r',LineWidth=2)
title('VARIAZIONE EFFICIENZA MODI TM')
ylabel('Efficienza Totale [dB]')
xlabel('rbody [cm]')
%% Caso Vescica+Grasso

%eta_bladder_fat = zeros(1,20);

%for i=1:length(d)
%% near-field TE
%num= u0*abs(eps_bladder)*2*pi*f0 - 2*sqrt(u0)*imag(sqrt(eps_bladder))*d(i)^-1;
%den =u0*abs(eps_bladder)*2*pi*f0 - 2*sqrt(u0)*imag(sqrt(eps_bladder))*rimpl^-1;

%near_field_TE_2 =num/den;

%% near-field TM
%num1 = (u0^1.5)*real(sqrt(eps_bladder))*(2*pi*f0)^3 + imag(eps_bladder^-1)*d(i)^-3;
%den1 = (u0^1.5)*real(sqrt(eps_bladder))*(2*pi*f0)^3 + imag(eps_bladder^-1)*rimpl^-3;
%near_field_TM_2 = num1/den1;

%% propagation TE/TM

%propagation = exp(2*sqrt(u0)*imag(sqrt(eps_bladder))*2*pi*f0*(d(i)-rimpl));

%% Riflessione Vescica/grasso SOLO TE

%Zm_fat = Zm_TE;

%num5 = (u0^1.5)*sqrt(eps0*epsr_bladder)*(2*pi*f0)^2*rbody(i)^2 - 1i*u0*2*pi*f0*rbody(i);
%den5 = u0*eps0*epsr_bladder*(2*pi*f0)^2*rbody(i)^2 - 1i*sqrt(u0*eps0*epsr_bladder)*2*pi*f0*rbody(i) - 1;

%Zm_bladder = num5/den5;



%T_bladder_fat = (2*Zm_fat)/(Zm_fat+Zm_bladder);

%reflection_bladder_fat = (real(abs((T_bladder_fat)^2)/Zm_fat))/(real(1/Zm_bladder));

%eta_bladder_fat(i) = near_field_TE_2*propagation*reflection_bladder_fat;
%end

%figure()
%plot(rbody*100,(10*log(eta_bladder_fat)),color='r',LineWidth=2)
%title('VARIAZIONE EFFICIENZA MODI TE')
%ylabel('Efficienza Totale [dB]')
%xlabel('rbody [cm]')
