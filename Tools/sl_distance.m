% Function to compute the distance in degrees for a matrix of lat/lon pairs
% Based on the matlab mapping toolbox and sac distaz routine
% function distances = distance(alats, alons, blats, blons)
% Rob Porritt, July 2014
function distances = sl_distance(alats, alons, blats, blons)

% Check that sizes must match
if (length(alats) ~= length(alons) && length(alats) ~= length(blats) && length(alats) ~= length(blons)) 
    fprintf('Error, size of arrays in distance must match!\n');
    return
end

% Init the output
distances=zeros(1,length(alats));

% compute the azimuths. Note we're throwing out the distance in this usage
for i=1:length(alats)
    [kmdist, azi, distances(i)] = distaz(alats(i),alons(i),blats(i),blons(i));
end
return
