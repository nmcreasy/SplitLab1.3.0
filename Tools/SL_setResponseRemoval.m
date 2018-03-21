function SL_setResponseRemoval( source, eventdata )
%% Callback function to set sampling rate of waveforms collected via irisFetch.Traces
%  Arguably, this would be better as free input, but that allows for
%  greater chance of weird user error highly over or under sampling the
%  data

   global config

    str = get(source, 'String');
    val = get(source, 'Value');
    
    switch str{val};
        case 'No Removal'
            config.requestedResponseRemoval  = 'No Removal';
        case 'Scalar Only'
            config.requestedResponseRemoval  = 'Scalar Only';
        case 'Pole-Zero to Displacement'
            config.requestedResponseRemoval  = 'Pole-Zero to Displacement';
        case 'Pole-Zero to Velocity'
            config.requestedResponseRemoval  = 'Pole-Zero to Velocity';
        case 'Pole-Zero to Acceleration'
            config.requestedResponseRemoval = 'Pole-Zero to Acceleration';
    end


end

