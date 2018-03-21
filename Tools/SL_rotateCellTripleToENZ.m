%% function fetchedTripleSeisOut = SL_rotateCellTripleToENZ(fetchedTripleSeisIn)
%  Uses the metadata in the input 3-component cell array to rotate into
%  East, North, Vertical coordinate frame.
%  Updates the .data and .azimuth structure variables.
%  Assumes one component is vertical and checks for other two to be
%  orthagonal
% Rob Porritt, July 2014
function [fetchedTripleSeisOut, ierr] = SL_rotateCellTripleToENZ(fetchedTripleSeisIn)

%% Init the output cell structure; in the case of error, this way we have a blank 3 component cell structure
fetchedTripleSeisOut = cell(1,3);

%% Error checking

% Require 3 component data
if length(fetchedTripleSeisIn) ~= 3
    fprintf('Error, SL_rotateCellTripleToENZ given non-three component data!\n');
    ierr = 1;
    return
end

% Check for empty fields
if ~isfield(fetchedTripleSeisIn{1},'dip')
    ierr = 5;
    fprintf('Error, SL_rotateCellTripleToENZ structure lacking dip element\n');
    return
end

% Require 1 vertical component
ivertical = 0;
nvertical = 0;
for i=1:3
    if fetchedTripleSeisIn{i}.dip ~= 0
        ivertical = i;
        nvertical = nvertical + 1;
    end
end
if nvertical ~= 1
    fprintf('Error, SL_rotateCellTripleToENZ given more than or less than 1 vertical channel!\n');
    ierr = 2;
    return
end

% Check horizontals for orthagonality
% horizontals are not the vertical:
horizontalIndices = find(1:3~=ivertical);
if mod(abs(fetchedTripleSeisIn{horizontalIndices(1)}.azimuth - fetchedTripleSeisIn{horizontalIndices(2)}.azimuth),180) ~= 90
    fprintf('Error, SL_rotateCellTripleToENZ not given orthagonal horizontals!\n');
    ierr = 3;
    return
end

% Check for common sample counts
if fetchedTripleSeisIn{horizontalIndices(1)}.sampleCount ~= fetchedTripleSeisIn{horizontalIndices(2)}.sampleCount
    fprintf('Error, SL_rotateCellTripleToENZ given different sample counts. Did you interpolate to common time arrays?\n');
    ierr = 4;
    return
end


%% Get space for rotation array to avoid growing within a loop
%tmpArrayNorth = zeros(1,fetchedTripleSeisIn{horizontalIndices(1)}.sampleCount);
%tmpArrayEast  = zeros(1,fetchedTripleSeisIn{horizontalIndices(2)}.sampleCount);

% While in the memory section, copy the output from the input as most will
% be the same
fetchedTripleSeisOut = fetchedTripleSeisIn;

% %% Get info for rotation
% %  Need rotation angle between N and {1}, {2} and angle between E and {1},
% %  {2}
% %  North azimuth = 0
% %  East azimuth = 90
% dnr = fetchedTripleSeisIn{horizontalIndices(1)}.azimuth * pi/180.0;
% 
% %% rotate through the dnr angle.
% % Original method of a for loop took O(15 seconds) on test data
% % using the vector math reduced it to O(0.001 seconds) on same data
% % for i=1:fetchedTripleSeisIn{horizontalIndices(1)}.sampleCount
% %     tmpArrayNorth(i) = fetchedTripleSeisIn{horizontalIndices(2)}.data(i) * sin(dnr) + fetchedTripleSeisIn{horizontalIndices(1)}.data(i) * cos(dnr);
% %     tmpArrayEast(i)  = fetchedTripleSeisIn{horizontalIndices(2)}.data(i) * cos(dnr) + fetchedTripleSeisIn{horizontalIndices(1)}.data(i) * sin(dnr);
% % end
% sindnr = sin(dnr);
% cosdnr = cos(dnr);
% tmpArrayNorth = -1*(fetchedTripleSeisIn{horizontalIndices(2)}.data * sindnr + fetchedTripleSeisIn{horizontalIndices(1)}.data * -cosdnr);
% tmpArrayEast  = fetchedTripleSeisIn{horizontalIndices(2)}.data * cosdnr + fetchedTripleSeisIn{horizontalIndices(1)}.data * sindnr;


deltaAngle = fetchedTripleSeisIn{horizontalIndices(1)}.azimuth - fetchedTripleSeisIn{horizontalIndices(2)}.azimuth;
coordinateFlag = mod(deltaAngle + 360,360); % should be 90 or 270 if orthangonal
if (coordinateFlag == 270)
    tmp = fetchedTripleSeisIn{horizontalIndices(1)};
    fetchedTripleSeisIn{horizontalIndices(1)} = fetchedTripleSeisIn{horizontalIndices(2)};
    fetchedTripleSeisIn{horizontalIndices(2)} = tmp;
end

der = (90-fetchedTripleSeisIn{horizontalIndices(1)}.azimuth) * pi/180.0;  % radians over which to rotate
rotationMatrix = [cos(-der) -sin(-der); sin(-der) cos(-der)];
dataToRotate=[fetchedTripleSeisIn{horizontalIndices(1)}.data; fetchedTripleSeisIn{horizontalIndices(2)}.data];

%% rotate through the dnr angle. 
rotatedData = rotationMatrix * dataToRotate;


%% Repack
fetchedTripleSeisOut{horizontalIndices(1)}.data = rotatedData(1,:);
fetchedTripleSeisOut{horizontalIndices(1)}.azimuth = 90;
fetchedTripleSeisOut{horizontalIndices(2)}.data = rotatedData(2,:);
fetchedTripleSeisOut{horizontalIndices(2)}.azimuth = 0;
ierr = 0;

end

