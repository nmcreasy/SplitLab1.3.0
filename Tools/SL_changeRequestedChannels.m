function SL_changeRequestedChannels(source, eventdata) 
% Call back function to change the channels desired in irisFetch

    global config
    str = get(source,'String');
    val = get(source, 'Value');
    
    switch str{val}
        case 'BHE,BHN,BHZ'
            config.ChannelSet = 'BHE,BHN,BHZ';
        case 'BH1,BH2,BHZ'
            config.ChannelSet = 'BH1,BH2,BHZ';
        case 'HHE,HHN,HHZ'
            config.ChannelSet = 'HHE,HHN,HHZ';
        case 'HH1,HH2,HHZ'
            config.ChannelSet = 'HH1,HH2,HHZ';
        case 'LHE,LHN,LHZ'
            config.ChannelSet = 'LHE,LHN,LHZ';
        case 'LH1,LH2,LHZ'
            config.ChannelSet = 'LH1,LH2,LHZ';
    end
    %fprintf('Channel set: %s\n',config.ChannelSet);
end
