function SL_Earthview(lat, long, mag, depth, month)
% display worldmap with eathquake location of the current splitlab project
% SL_Earthview(lat, long, mag, depth, month)
% the inputs lat and long mark selected eathquake(s). mag and depth are
% displayed as the window title. The numeric input value month (1-12) corresponds
% to seasonal MODIS worldmap provided by the NASA "Blue Marble Project" is
% displayed. This is an integral view of the visible spectrum of satelite
% images. choose month=0 for a seasonal-free repwesentation

% A. Wuestefeld;
% Unversity Montpellier
% Jan 2006

%% location

global eq config
fig=gcf;

earth = findobj('type','figure', 'tag','EarthView','NumberTitle','off');
if isempty(earth)
    ax             = axesm('eqdazim','origin',[config.slat,config.slong]);
    pos=get(0,'ScreenSize');
    width= 360*1.5; height=180*1.5;
    xpos = pos(1) + pos(3) - width*1.05;
    ypos = 70 ;
    pos=[xpos ypos width height];
    
    earth = figure( 'tag','EarthView','NumberTitle','off',...
        'name',sprintf('World Viewer  Mw: %3.1f   Depth: %4.1fkm', mag, depth),...
        'MenuBar','None','Position', pos);
    ax=axes('Units', 'normalized','Position',[.0 .0 1 1],'Ydir','reverse');
    im = sprintf('MODISworld_%02.0f.jpg',month);
    image(-180:.1801:180,-90:.1801:90,imread(im),'Parent',ax ,'Tag','ModisMap');
    
    hold on
    coast = load('SL_coasts.mat');
    PB    = load('SL_plates.mat');
    %plot(coast.long, -coast.lat,'-','Color',[1 1 1]*.1)
    plot(coast.ncst(:,1),-coast.ncst(:,2),'-','Color',[1 1 1]*.1)
    plot(PB.PBlong,  -PB.PBlat ,'-','Color',[0.6 .12 .12])%plate boundaries
    
    %Plot raypaths on map
    % calculate the taupPath for each earthquake to station
    
%     for i = 1:length(eq)
%         
%         %tt_path = taupPath(config.earthmodel,eq(i).depth,'SKS','sta',[config.slat,config.slong],'evt',[eq(i).lat,eq(i).long]);
%         %plot(tt_path(1).path.longitude,tt_path(1).path.latitude,'k-','LineWidth',0.25)
%         %plot([eq(i).long,config.slong],-[eq(i).lat,config.slat],'k-','LineWidth',0.25);
%         [lattrac,longtrac] = track2(eq(i).lat,eq(i).long,config.slat,config.slong);
%         plot(longtrac,-lattrac,'k.','MarkerSize',2)
% 
%         hold on
%     end
    
    plot([eq(:).long], -[eq(:).lat],'Marker','.','MarkerSize',16,'LineStyle','None','Color',[1 .5 0]);%[1 1 1]*0.5
    
    plot(config.slong, -config.slat,'k^','Markersize',8,'MarkerFaceColor','r');
    hold on
    
    
    text(config.slong, -config.slat-2, config.stnname,'VerticalAlignment', 'bottom',...
        'HorizontalAlignment','center' ,'Color', 'y', 'FontName','FixedWidth','Fontweight','demi')
else
    figure(earth)
    set(earth,'name',['World Viewer  Magnitude: ' num2str(mag,'%.1f') '    Depth: ' num2str(depth) 'km'])
    delete(findobj('Tag','EQMarkerEarth'))
    delete(findobj('Tag','SplittedMarker'))
    delete(findobj('Tag','EQRaypath'))
    
    zoom(earth,'out')
end



%% Update plot
ax = findobj('Parent',earth, 'Type','Axes');
im = sprintf('MODISworld_%02.0f.jpg',month);
set(findobj('parent',ax,'Type','Image','Tag','ModisMap'), 'Cdata',imread(im))

%% looking for earthquakes already splitted, plot in green
ind=[];
for i=1:length(eq)
    if ~isempty(eq(i).results)
        ind=[ind i];
    end
end

hold on
plot([eq(ind).long], -[eq(ind).lat],'Marker','.','MarkerSize',16,'Color','g','LineStyle','None','Tag','SplittedMarker','Parent',ax);

%%  Hypocenter
zoom(earth,'reset')

if length(long) ==1
    [lattrac,longtrac] = track2(lat,long,config.slat,config.slong);
    plot(longtrac,-lattrac,'k.','Tag','EQRaypath','MarkerSize',2)
    %tt_path = taupPath(config.earthmodel,depth,'SKS','sta',[config.slat,config.slong],'evt',[lat,long]);
    %plot(tt_path(1).path.longitude,-tt_path(1).path.latitude,'r.-'
end
%hold on

%tt_path = taupPath(config.earthmodel,eq(i).depth,'SKS','sta',[config.slat,config.slong],'evt',[eq(i).lat,eq(i).long]);
%plot(tt_path(1).path.longitude,tt_path(1).path.latitude,'k-','LineWidth',0.25)
%plot([eq(i).long,config.slong],-[eq(i).lat,config.slat],'k-','LineWidth',0.25);

plot(long, -lat, 'rp','MarkerFaceColor','y','Tag','EQMarkerEarth','Markersize',14,'Parent',ax);

hold off
    
axis off
zoom(earth,'reset')
zoom(earth,'on')


%% give focus to previous figure
figure(fig)

%% This program is part of SplitLab
% � 2006 Andreas W�stefeld, Universit� de Montpellier, France
%
% DISCLAIMER:
%
% 1) TERMS OF USE
% SplitLab is provided "as is" and without any warranty. The author cannot be
% held responsible for anything that happens to you or your equipment. Use it
% at your own risk.
%
% 2) LICENSE:
% SplitLab is free software; you can redistribute it and/or modifyit under the
% terms of the GNU General Public License as published by the Free Software
% Foundation; either version 2 of the License, or(at your option) any later
% version.
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
% more details.