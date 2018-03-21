function [hndl, marker] = stereoplot(bazi, inc, azim, len, varargin)
%[hndl, marker] = stereoplot(bazi, inc, azim, len)
% plot a stereomap of values, at backazimuth bazi, with inclination inc.
% The direction and length (i.e. delay time) of the marker is determined 
% by azim and len, respectively.
% The optional argument Null is a vector of indices to the values with Null
% charatesistics. these values are plotted as circles at the correspondig 
% backazimuth and inclination. 
%
% Example:
%  Imagine a station with 10 measurements. 
%  The third, fifth and nineth value are Null measurements:
%  [hndl, marker] = stereoplot(bazi, inc, azim, len, [3 5 9])

if license('checkout', 'MAP_Toolbox')


m = max(inc);
m = round(m/10)*10; %make gridline every 10deg
lim = [-inf m+5];
a = axesm ('stereo', 'Frame', 'on', 'Grid', 'on', 'Origin',[90 0],...
    'MlineLocation', 90, 'PlineLocation', 5, 'fLatLimit',lim, 'fLineWidth',1);


if nargin ==5
    Null=varargin{:};
    
else
    Null=[];
end


% Nulls
if ~isempty(Null)
   marker = plotm(90-inc(Null), bazi(Null) ,'ro', 'MarkerSize',4);%,'MarkerFaceColor','r');
else
    marker=[];
end
 
 
NNull = setdiff(1:length(inc), Null);%non-Nulls

bazi = bazi(:);
inc  = inc(:);
len  = len(:);
azim = azim(:);

bazi = [bazi(NNull)  bazi(NNull)]';
inc  = [inc(NNull)   inc(NNull)]';
len  = [-len(NNull)  len(NNull)]';
azim = (bazi-[azim(NNull) azim(NNull)]');


%scale marker to output size
len=len*2; %one second == 4degrees (2 deg in both directions)

% Marker
hold on
 [latout, lonout] = reckon( 90-inc, bazi, len, azim, 'degrees');
 hndl = plotm(latout, lonout, 'Linewidth', 1);
hold off



axis tight

axis off
L = min(abs(axis));
str =strvcat([num2str(m/2)  char(186)], [num2str(m)  char(186)]);
% t   = textm(90-[m/2; m], [45; 45], str, 'FontName','FixedWidth' );
text(0 , -L, 'N','FontName','FixedWidth','HorizontalAlignment','Center','VerticalAlignment','Base');
text(L, 0,   'E','FontName','FixedWidth','HorizontalAlignment','Left','verticalAlignment','middle');

view([0 -90])

else
    
    % manually adding a rough stereo net of all splits
%    axes(axSeis(2))
    % location defined by the back-azimuth and the inclination
    % Plot a vector in the measured directions (phi) with length determined
    % by dt
    % We want a little line with its center at the baz/inc coordinate
    % We can break up the phi/dt vector into i,j coordinates and plot as
    % deviation
    % Also plot polar axes at constant inclination for guide
    
    % Plot background info
     hold on
     axis([-15 15 -15 15]);  % Hope this covers the possible inclination space!
     plot(5*cos(0:0.1:2*pi),5*sin(0:0.1:2*pi),'k-')
     plot(10*cos(0:0.1:2*pi),10*sin(0:0.1:2*pi),'k-')
     plot(20*cos(0:0.1:2*pi),20*sin(0:0.1:2*pi),'k-')
    
    % Plot crosses at the location of nulls
    if nargin ==5
        Null=varargin{:};
    
    else
        Null=[];
    end
    if ~isempty(Null)
        for i=1:length(Null)
            xO = inc(Null(i))*cos((90-bazi(Null(i)))*(pi/180));
            yO = inc(Null(i))*sin((90-bazi(Null(i)))*(pi/180));
            plot(xO,yO,'rp')
        end
    end
    
    % Prepare to plot the split results
    NNull = setdiff(1:length(inc), Null);%non-Nulls
    for i=1:length(NNull)
        xO = inc(NNull(i)) * cos((90-bazi(NNull(i)))*(pi/180));
        yO = inc(NNull(i)) * sin((90-bazi(NNull(i)))*(pi/180));
    
        xone = xO - 2*len(NNull(i)) * cos( (90-azim(NNull(i))) * (pi/180))/2.0;
        xtwo = xO + 2*len(NNull(i)) * cos( (90-azim(NNull(i))) * (pi/180))/2.0;
        yone = yO - 2*len(NNull(i)) * sin( (90-azim(NNull(i))) * (pi/180))/2.0;
        ytwo = yO + 2*len(NNull(i)) * sin( (90-azim(NNull(i))) * (pi/180))/2.0;
        
        plot([xone,xtwo], [yone,ytwo],'b');
    end
        
    hndl = gcf();
    marker = gcf();
    
    % Location of measurement in inclination-backazimuth space
%     x0 = thiseq.tmpInclination * cos((90-bazi)*(pi/180));
%     y0 = thiseq.tmpInclination * sin((90-bazi)*(pi/180));
%     
%     % RC coordinates
%     x1RC = x0-(2*dtRC(2) * cos((90-phiRC(2))*pi/180))/2;
%     y1RC = y0-(2*dtRC(2) * sin((90-phiRC(2))*pi/180))/2;
%     x2RC = x0+(2*dtRC(2) * cos((90-phiRC(2))*pi/180))/2;
%     y2RC = y0+(2*dtRC(2) * sin((90-phiRC(2))*pi/180))/2;
%     
%     % SC coordinates
%     x1SC = x0-(2*dtSC(2) * cos((90-phiSC(2))*pi/180))/2;
%     y1SC = y0-(2*dtSC(2) * sin((90-phiSC(2))*pi/180))/2;
%     x2SC = x0+(2*dtSC(2) * cos((90-phiSC(2))*pi/180))/2;
%     y2SC = y0+(2*dtSC(2) * sin((90-phiSC(2))*pi/180))/2;
%     
%     % EV coordinates
%     x1EV = x0-(2*dtEV(2) * cos((90-phiEV(2))*pi/180))/2;
%     y1EV = y0-(2*dtEV(2) * sin((90-phiEV(2))*pi/180))/2;
%     x2EV = x0+(2*dtEV(2) * cos((90-phiEV(2))*pi/180))/2;
%     y2EV = y0+(2*dtEV(2) * sin((90-phiEV(2))*pi/180))/2;
%     
%     hold on
%     % Plot background info
%     axis([-10 10 -10 10]);  % Hope this covers the possible inclination space!
%     plot(5*cos(0:0.1:2*pi),5*sin(0:0.1:2*pi),'k-')
%     plot(10*cos(0:0.1:2*pi),10*sin(0:0.1:2*pi),'k-')
%     plot(20*cos(0:0.1:2*pi),20*sin(0:0.1:2*pi),'k-')
%     % Plot location
%     plot(x0,y0,'k*');
%     
%     % Plot splits
%     plot([x1RC, x2RC], [y1RC, y2RC],'g');
%     plot([x1SC, x2SC], [y1SC, y2SC],'r');
%     plot([x1EV, x2EV], [y1EV, y2EV],'b');
%     
%     
%     L = axis;
%     text(0, L(4),['  Inc = \bf' num2str(thiseq.tmpInclination,'%4.1f') char(186)], ...
%         'Fontname','Fixedwidth', 'VerticalAlignment','top','HorizontalAlignment','center')
%     
    
end



