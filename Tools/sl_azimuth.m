% function azimuths = sl_azimuth(alats, alons, blats, blons)
% Function to compute the azimuth for a matrix of lat/lon pairs
% Based on the matlab mapping toolbox and sac distaz routine
% I've put the a/b and s on the variables to designate that these are
% designed for vectors.
% Rob Porritty, July 2014
function azimuths = sl_azimuth( alats, alons, blats, blons )

% Check that sizes must match
if (length(alats) ~= length(alons) && length(alats) ~= length(blats) && length(alats) ~= length(blons)) 
    fprintf('Error, size of arrays in azimuth must match!\n');
    return
end

% Init the output
azimuths=zeros(1,length(alats));

% compute the azimuths. Note we're throwing out the distance in this usage
for i=1:length(alats)
    [kmdist, azimuths(i), xdeg] = distaz(alats(i),alons(i),blats(i),blons(i));
end
return





