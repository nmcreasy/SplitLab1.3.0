%BSAC   Be SAC 
%    BSAC(xarray,yarray) take an array of x-values and y-values
%    and format the arrays in a way that is compatible with
%    the SAC-like routines such as wsac, lh, or ch. 
%
%    Examples:
%
%    To create a square root function in matlab in the arrays
%    xarray and yarray, and then convert the array information
%    into SAC compatible format and ultimately write to a
%    SAC formatted binary file:
%
%    xarray=linspace(0,30,1000);
%    yarray=sqrt(xarray);     
%    root1 = bsac(xarray,yarray);
%    sl_wsac('root1.sac',root1); 
%
%    by Michael Thorne (4/2004)   mthorne@asu.edu
%
%    See also:  RSAC, LH, CH, WSAC 

function [output] = sl_bsac(xinput,yinput);


output(:,1) = xinput';
output(:,2) = yinput';

h(303) = 77;
h(304) = 73;
h(305) = 75;
h(306) = 69;
output(303:306,3) = h(303:306)';

%set real header variables
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
h(1:70) = -12345;
output(1:70,3) = h(1:70)';

%set required header variables
%head = xinput(2) - xinput(1);
head = mean(diff(xinput));%Changed by AW, is more acurate
output=sl_ch(output,'DELTA',head);
head = xinput(1);
output=sl_ch(output,'B',head);
head = xinput(length(xinput));
output=sl_ch(output,'E',head);
output=sl_ch(output,'DEPMIN',min(yinput));
output=sl_ch(output,'DEPMAX',max(yinput));
output=sl_ch(output,'DEPMEN',mean(yinput));

%set logical and integer header variables:
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
h(71:110) = -12345;
output(71:110,3) = h(71:110)';

%set required header variables
output=sl_ch(output,'NPTS',length(xinput));
head = 1;
output=sl_ch(output,'IFTYPE',head);
output=sl_ch(output,'LEVEN',head);
output=sl_ch(output,'LCALDA',head);
output=sl_ch(output,'LOVROK',head);
head = 6;
output=sl_ch(output,'NVHDR',head);
head = 0;
output=sl_ch(output,'LPSPOL',head);

%set character header variables:
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
h8 = [45 49 50 51 52 53 32 32];
h16 = [45 49 50 51 52 53 32 32 32 32 32 32 32 32 32 32];
output(111:118,3)=h8';
output(119:134,3)=h16';
output(135:142,3)=h8';
output(143:150,3)=h8';
output(151:158,3)=h8';
output(159:166,3)=h8';
output(167:174,3)=h8';
output(175:182,3)=h8';
output(183:190,3)=h8';
output(191:198,3)=h8';
output(199:206,3)=h8';
output(207:214,3)=h8';
output(215:222,3)=h8';
output(223:230,3)=h8';
output(231:238,3)=h8';
output(239:246,3)=h8';
output(247:254,3)=h8';
output(255:262,3)=h8';
output(263:270,3)=h8';
output(271:278,3)=h8';
output(279:286,3)=h8';
output(287:294,3)=h8';
output(295:302,3)=h8';

output=sl_ch(output,'KCMPNM','Q');
output=sl_ch(output,'KSTNM','matlab');

