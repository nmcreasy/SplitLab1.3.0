function [ m1low, m1est, m1high] = SplitIntFunction( T,Q ,samprate)
%Calculates splitting intesity based on Chevrot, 2000
%   Uses the window chosen for Q and T
%   Simply the maximum amplitude of the transverse divided by the maximum
%   amplitude of the time derivative of the radial 


%% Written by Neala Creasy
% 1/sampling rate
xx=samprate;


% finds time derivative of the Radial component
for put = 1:length(T)-1
    rd(put)= (Q(put+1)-Q(put))/xx;
end

% Equation from Chevrot, 2000
T(end) = [];
Pop= dot(T,rd);
NPop =norm(rd)^2;
 

%Splitting Intensity
SplitIntensity=-2*Pop/NPop;
m1est=SplitIntensity;



S_expec = -0.5*SplitIntensity.*rd;



%figure
%plot(rd)
%hold on
%plot(T,'r')

%N=length(rd);

%root mean squared error
rdelta = 0;
for p=1:length(T)
    rdelta = rdelta+(T(p)+0.5*SplitIntensity*rd(p))^2;
end
ndf = getndf1(T,length(T),length(T));

variance=(1/(ndf-1))*rdelta;


%f=finv(0.95,1,ndf-1);
tin=tinv(0.95,ndf-1);



ssee=0;
for t=1:length(rd)
    ssee=ssee+(rd(t)-mean(rd))^2;
    
end

sm2=variance/ssee;
m1high=SplitIntensity+tin*sqrt(sm2);
m1low=SplitIntensity-tin*sqrt(sm2);




% another techniqu in finding the splitting intensity
% aup = 0;
% alow = 0;
% 
% 
% for pu = 1:length(T)-1
%     
%    aup = aup + T(pu)*rd(pu);
%    alow = alow + rd(pu)*rd(pu);
%     
% end
% 
% SplitIntensity=-2*aup/alow;


end

