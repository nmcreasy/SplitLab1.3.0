function SL_changeServiceDataCenter( source, eventdata )
% Call back function to change the data center for irisFetch.m

    global config

    str = get(source, 'String');
    val = get(source, 'Value');
    
    switch str{val};
        case 'http://service.iris.edu'
            config.serviceDataCenter = 'http://service.iris.edu';
        case 'http://service.ncedc.org'
            config.serviceDataCenter = 'http://service.ncedc.org';
        case 'http://service.scedc.caltech.edu'
            config.serviceDataCenter = 'http://service.scedc.caltech.edu';
    end
    %fprintf('Using data center %s\n',config.serviceDataCenter);

end



            


