function SL_changeRequestedSampleRate( source, eventdata )
%% Callback function to set sampling rate of waveforms collected via irisFetch.Traces
%  Arguably, this would be better as free input, but that allows for
%  greater chance of weird user error highly over or under sampling the
%  data

   global config

    str = get(source, 'String');
    val = get(source, 'Value');
    
    switch str{val};
        case '1'
            config.requestedSampleRate  = 1;
        case '10'
            config.requestedSampleRate  = 10;
        case '20'
            config.requestedSampleRate  = 20;
        case '40'
            config.requestedSampleRate  = 40;
        case '100'
            config.requestedSampleRate  = 100;
    end


end

