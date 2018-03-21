% sac's distaz routine, but editted for matlab
% function [dist, azi, xdeg] = distaz(lat1, long1, lat2, long2)
% Rob Porritt, July 2014
function [dist, azi, xdeg] = distaz(lat1, long1, lat2, long2)

laz = 1;
ldist = 1;
lxdeg = 1;

the=lat1;
phe=long1;
ths=lat2; 
phs=long2;

rad = 6378.160;
fl = 0.00335293;
twopideg = 360.0;
c00 = 1.0;
c01 = 0.25;
c02 = -4.6875e-02;
c03 = 1.953125e-02;
c21 = -0.125;
c22 = 3.125e-02;
c23 = -1.46484375e-02;
c42 = -3.90625e-03;
c43 = 2.9296875e-03;
TODEG = 57.29577950;
TORAD = (1./TODEG);
FLT_MAX = 64000;

% 	/* - Initialize. */
ec2 = 2.*fl - fl*fl;
onemec2 = 1. - ec2;
eps = 1. + ec2/onemec2;


% 	/* - Convert event location to radians.
% 	 *   (Equations are unstable for latidudes of exactly 0 degrees.) */
 	temp = the;
 	if( temp == 0. ) 
 	    temp = 1.0e-08;
    end
    therad = TORAD*temp;
    pherad = TORAD*phe;

% 	/* - Must convert from geographic to geocentric coordinates in order
% 	 *   to use the spherical trig equations.  This requires a latitude
% 	 *   correction given by: 1-EC2=1-2*FL+FL*FL */
 	if ( the == 90 || the == -90 ) %{/* special attention at the poles */
 	    thg = the*TORAD ;		%/* ... to avoid division by zero. */
    else 
        thg = atan( onemec2 * tan(therad) );
    end
    
 	d = sin( pherad );
 	e = -cos( pherad );
 	f = -cos( thg );
 	c = sin( thg );
 	a = f*e;
 	b = -f*d;
 	g = -c*e;
 	h = c*d;

%     	    /* -- Convert to radians. */
	    temp = ths;
	    if( temp == 0. )
		  temp = 1.0e-08;
        end
        thsrad = TORAD*temp;
	    phsrad = TORAD*phs;

% 	    /* -- Calculate some trig constants. */
	    if ( ths == 90 || ths == -90 )
		  thg = ths * TORAD ;
        else
		  thg = atan( onemec2*tan( thsrad ) );
        end
        d1 = sin( phsrad );
	    e1 = -cos( phsrad );
	    f1 = -cos( thg );
	    c1 = sin( thg );
	    a1 = f1*e1;
	    b1 = -f1*d1;
	    g1 = -c1*e1;
	    h1 = c1*d1;
	    sc = a*a1 + b*b1 + c*c1;

% 	    /* - Spherical trig relationships used to compute angles. */

	    if( lxdeg )
		  sd = 0.5*sqrt( (powi(a - a1,2) + powi(b - b1,2) + powi(c - c1,2))*(powi(a + a1,2) + powi(b + b1,2) + powi(c + c1,2)) );
		  xdeg = atan2( sd, sc )*TODEG;
		  if( xdeg < 0. )
		    xdeg = xdeg + twopideg;
          end
        end

	    if( laz )
		  ss = powi(a1 - d,2) + powi(b1 - e,2) + powi(c1,2) - 2.;
		  sc = powi(a1 - g,2) + powi(b1 - h,2) + powi(c1 - f,2) - 2.;
		  azi = atan2( ss, sc )*TODEG;
		  if( azi < 0. )
		    azi = azi + twopideg;
          end
        end
        
% 	    /* - Now compute the distance between the two points using Rudoe's
% 	     *   formula given in GEODESY, section 2.15(b).
% 	     *   (There is some numerical problem with the following formulae.
% 	     *   If the station is in the southern hemisphere and the event in
% 	     *   in the northern, these equations give the longer, not the
% 	     *   shorter distance between the two locations.  Since the
% 	     *   equations are fairly messy, the simplist solution is to reverse
% 	     *   the meanings of the two locations for this case.) */
	    if( ldist )
		  if( thsrad > 0. )
		    t1 = thsrad;
		    p1 = phsrad;
		    t2 = therad;
		    p2 = pherad;

% 		    /* special attention at the poles to avoid atan2 troubles 
% 		       and division by zero. */
            if ( the == 90.0 ) 
			  costhk = 0.0 ;
			  sinthk = 1.0 ;
			  tanthk = 64000 ;
           
            elseif ( the == -90.0 ) 
			  costhk = 0.0 ;
			  sinthk = -1.0 ;
			  tanthk = -64000 ;
         
            else 
			  costhk = cos( t2 );
			  sinthk = sin( t2 );
		      tanthk = sinthk/costhk;
            end

% 		    /* special attention at the poles continued. */
		    if ( ths == 90.0 ) 
                        costhi = 0.0 ;
                        sinthi = 1.0 ;
                        tanthi = FLT_MAX ;
                    
            elseif ( ths == -90.0 ) 
                        costhi = 0.0 ;
                        sinthi = -1.0 ;
                        tanthi = -FLT_MAX ;
		    
            else 
			  costhi = cos( t1 );
			  sinthi = sin( t1 );
			  tanthi = sinthi/costhi;
            end
        
        else
		    t1 = therad;
		    p1 = pherad;
		    t2 = thsrad;
		    p2 = phsrad;

% 		    /* more special attention at the poles */
                    if ( ths == 90.0 ) 
                        costhk = 0.0 ;
                        sinthk = 1.0 ;
                        tanthk = FLT_MAX ;
                    
                    elseif ( ths == -90.0 ) 
                        costhk = 0.0 ;
                        sinthk = -1.0 ;
                        tanthk = -FLT_MAX ;
                    
		            else 
                        costhk = cos( t2 );
                        sinthk = sin( t2 );
                        tanthk = sinthk/costhk;
                    end 

% 		    /* more special attention at the poles continued */
                    if ( the == 90.0 )
                        costhi = 0.0 ;
                        sinthi = 1.0 ;
                        tanthi = FLT_MAX ;
                    
                    elseif ( the == -90.0 ) 
                        costhi = 0.0 ;
                        sinthi = -1.0 ;
                        tanthi = -FLT_MAX ;
                    
		            else 
                        costhi = cos( t1 );
                        sinthi = sin( t1 );
                        tanthi = sinthi/costhi;
                    end

          end
       
		  el = ec2/onemec2;
		  e1 = 1. + el;
		  al = tanthi/(e1*tanthk) + ec2*sqrt( (e1 + powi(tanthi,2))/(e1 + powi(tanthk,2)) );
		  dl = p1 - p2;
		  a12top = sin( dl );
		  a12bot = (al - cos( dl ))*sinthk;

% 		/* Rewrote these three lines with help from trig identities.  maf 990415 */
		  a12 = atan2( a12top, a12bot );
		  cosa12 = cos( a12 );
		  sina12 = sin( a12 );

% 		/*cosa12 = sqrt ( a12bot*a12bot / ( a12bot*a12bot + a12top*a12top ) ) ;
%		  sina12 = sqrt ( a12top*a12top / ( a12bot*a12bot + a12top*a12top ) ) ; */

		e1 = el*(powi(costhk*cosa12,2) + powi(sinthk,2));
		e2 = e1*e1;
		e3 = e1*e2;
		c0 = c00 + c01*e1 + c02*e2 + c03*e3;
		c2 = c21*e1 + c22*e2 + c23*e3;
		c4 = c42*e2 + c43*e3;
		v1 = rad/sqrt( 1. - ec2*powi(sinthk,2) );
		v2 = rad/sqrt( 1. - ec2*powi(sinthi,2) );
		z1 = v1*(1. - ec2)*sinthk;
		z2 = v2*(1. - ec2)*sinthi;
		x2 = v2*costhi*cos( dl );
		y2 = v2*costhi*sin( dl );
		e1p1 = e1 + 1.;
		sqrte1p1 = sqrt( e1p1 );
		u1bot = sqrte1p1*cosa12;
		u1 = atan2( tanthk, u1bot );
		u2top = v1*sinthk + e1p1*(z2 - z1);
		u2bot = sqrte1p1*(x2*cosa12 - y2*sinthk*sina12);
		u2 = atan2( u2top, u2bot );
		b0 = v1*sqrt( 1. + el*powi(costhk*cosa12,2) )/e1p1;
		du = u2 - u1;
		pdist = b0*(c2*(sin( 2.*u2 ) - sin( 2.*u1 )) + c4*(sin( 4* u2 ) - sin( 4*u1 )));
		dist = abs( b0*c0*du + pdist );
% 	    } /* end if ( ldist ) */
        end

    
    
    
    
% DISTAZ distaz(double lat1, double long1, double lat2, double long2)
% {
% 	int laz=1, ldist=1, lxdeg=1;
% //	int idx, ns=1;
% 	double a, a1, a12, a12bot, a12top, al, b, b0, b1, c, c0, c1, c2, 
% 	 c4, cosa12, costhi, costhk, d, d1, dl, du, e, e1, e1p1, e2, e3, 
% 	 ec2, el, eps, f, f1, g, g1, h, h1, onemec2, p1, p2, pdist, pherad, 
% 	 phsrad, sc, sd, sina12, sinthi, sinthk, sqrte1p1, ss, t1, t2, 
% 	 tanthi, tanthk, temp, therad, thg, thsrad, u1, u1bot, u2, u2bot, 
% 	 u2top, v1, v2, x2, y2, z1, z2;
% 	
% 	double the=lat1, phe=long1, ths=lat2, phs=long2;
% 	double xdeg, azi, distance;
% 
% 	DISTAZ out;
% 
% 	static double rad = 6378.160;  /* Earth Radius */
% 	static double fl = 0.00335293; /* Earth Flattening */
% 	static double twopideg = 360.; /* Two Pi in Degrees */
% 	static double c00 = 1.;
% 	static double c01 = 0.25;
% 	static double c02 = -4.6875e-02;
% 	static double c03 = 1.953125e-02;
% 	static double c21 = -0.125;
% 	static double c22 = 3.125e-02;
% 	static double c23 = -1.46484375e-02;
% 	static double c42 = -3.90625e-03;
% 	static double c43 = 2.9296875e-03;
% //	static double degtokm = 111.3199;  /* Conversion from degrees to km */
% 
% 
% //	double *const Az = &az[0] - 1;
% //	double *const Dist = &dist[0] - 1;
% //	double *const Phs = &phs - 1;
% //	double *const Ths = &ths - 1;
% //	double *const Xdeg = &xdeg[0] - 1;
% 
% 
% 	/* - Initialize. */
% 	ec2 = 2.*fl - fl*fl;
% 	onemec2 = 1. - ec2;
% 	eps = 1. + ec2/onemec2;
% 
% 
% 	/* - Convert event location to radians.
% 	 *   (Equations are unstable for latidudes of exactly 0 degrees.) */
% 	temp = the;
% 	if( temp == 0. ) {
% 	    temp = 1.0e-08;
% 	}
%         therad = TORAD*temp;
%         pherad = TORAD*phe;
%        
% 
% 	/* - Must convert from geographic to geocentric coordinates in order
% 	 *   to use the spherical trig equations.  This requires a latitude
% 	 *   correction given by: 1-EC2=1-2*FL+FL*FL */
% 	if ( the == 90 || the == -90 ) {/* special attention at the poles */
% 	    thg = the*TORAD ;		/* ... to avoid division by zero. */
%         } else {
%             thg = atan( onemec2 * tan(therad) );
%         }
% 	d = sin( pherad );
% 	e = -cos( pherad );
% 	f = -cos( thg );
% 	c = sin( thg );
% 	a = f*e;
% 	b = -f*d;
% 	g = -c*e;
% 	h = c*d;
% 
% 	    /* -- Convert to radians. */
% 	    temp = ths;
% 	    if( temp == 0. )
% 		temp = 1.0e-08;
% 	    thsrad = TORAD*temp;
% 	    phsrad = TORAD*phs;
% 
% 	    /* -- Calculate some trig constants. */
% 	    if ( ths == 90 || ths == -90 )
% 		thg = ths * TORAD ;
% 	    else
% 		thg = atan( onemec2*tan( thsrad ) );
% 	    d1 = sin( phsrad );
% 	    e1 = -cos( phsrad );
% 	    f1 = -cos( thg );
% 	    c1 = sin( thg );
% 	    a1 = f1*e1;
% 	    b1 = -f1*d1;
% 	    g1 = -c1*e1;
% 	    h1 = c1*d1;
% 	    sc = a*a1 + b*b1 + c*c1;
% 
% 	    /* - Spherical trig relationships used to compute angles. */
% 
% 	    if( lxdeg ){
% 		sd = 0.5*sqrt( (powi(a - a1,2) + powi(b - b1,2) + powi(c - 
% 		 c1,2))*(powi(a + a1,2) + powi(b + b1,2) + powi(c + c1,2)) );
% 		xdeg = atan2( sd, sc )*TODEG;
% 		if( xdeg < 0. ) {
% 		    xdeg = xdeg + twopideg;
% 		}
% 	    }
% 
% 	    if( laz ){
% 		ss = powi(a1 - d,2) + powi(b1 - e,2) + powi(c1,2) - 2.;
% 		sc = powi(a1 - g,2) + powi(b1 - h,2) + powi(c1 - f,2) - 2.;
% 		azi = atan2( ss, sc )*TODEG;
% 		if( azi < 0. ) {
% 		    azi = azi + twopideg;
% 		}
% 	    }
% 	    /* - Now compute the distance between the two points using Rudoe's
% 	     *   formula given in GEODESY, section 2.15(b).
% 	     *   (There is some numerical problem with the following formulae.
% 	     *   If the station is in the southern hemisphere and the event in
% 	     *   in the northern, these equations give the longer, not the
% 	     *   shorter distance between the two locations.  Since the
% 	     *   equations are fairly messy, the simplist solution is to reverse
% 	     *   the meanings of the two locations for this case.) */
% 	    if( ldist ){
% 		if( thsrad > 0. ){
% 		    t1 = thsrad;
% 		    p1 = phsrad;
% 		    t2 = therad;
% 		    p2 = pherad;
% 
% 		    /* special attention at the poles to avoid atan2 troubles 
% 		       and division by zero. */
%                     if ( the == 90.0 ) {
% 			costhk = 0.0 ;
% 			sinthk = 1.0 ;
% 			tanthk = FLT_MAX ;
% 		    }
%                     else if ( the == -90.0 ) {
% 			costhk = 0.0 ;
% 			sinthk = -1.0 ;
% 			tanthk = -FLT_MAX ;
% 		    }
%                     else {
% 			costhk = cos( t2 );
% 			sinthk = sin( t2 );
% 			tanthk = sinthk/costhk;
%                     }
% 
% 		    /* special attention at the poles continued. */
% 		    if ( ths == 90.0 ) {
%                         costhi = 0.0 ;
%                         sinthi = 1.0 ;
%                         tanthi = FLT_MAX ;
%                     }
% 		    else if ( ths == -90.0 ) {
%                         costhi = 0.0 ;
%                         sinthi = -1.0 ;
%                         tanthi = -FLT_MAX ;
% 		    }
% 		    else {
% 			costhi = cos( t1 );
% 			sinthi = sin( t1 );
% 			tanthi = sinthi/costhi;
% 		    } 
% 		}
% 		else{
% 		    t1 = therad;
% 		    p1 = pherad;
% 		    t2 = thsrad;
% 		    p2 = phsrad;
% 
% 		    /* more special attention at the poles */
%                     if ( ths == 90.0 ) {
%                         costhk = 0.0 ;
%                         sinthk = 1.0 ;
%                         tanthk = FLT_MAX ;
%                     }
%                     else if ( ths == -90.0 ) {
%                         costhk = 0.0 ;
%                         sinthk = -1.0 ;
%                         tanthk = -FLT_MAX ;
%                     }
% 		    else {
%                         costhk = cos( t2 );
%                         sinthk = sin( t2 );
%                         tanthk = sinthk/costhk;
%                     } 
% 
% 		    /* more special attention at the poles continued */
%                     if ( the == 90.0 ) {
%                         costhi = 0.0 ;
%                         sinthi = 1.0 ;
%                         tanthi = FLT_MAX ;
%                     }
%                     else if ( the == -90.0 ) {
%                         costhi = 0.0 ;
%                         sinthi = -1.0 ;
%                         tanthi = -FLT_MAX ;
%                     }
% 		    else {
%                         costhi = cos( t1 );
%                         sinthi = sin( t1 );
%                         tanthi = sinthi/costhi;
%                     }
% 
% 		}
% 
% 		el = ec2/onemec2;
% 		e1 = 1. + el;
% 		al = tanthi/(e1*tanthk) + ec2*sqrt( (e1 + powi(tanthi,2))/
% 		 (e1 + powi(tanthk,2)) );
% 		dl = p1 - p2;
% 		a12top = sin( dl );
% 		a12bot = (al - cos( dl ))*sinthk;
% 
% 		/* Rewrote these three lines with help from trig identities.  maf 990415 */
% 		a12 = atan2( a12top, a12bot );
% 		cosa12 = cos( a12 );
% 		sina12 = sin( a12 );
% 
% 		/*cosa12 = sqrt ( a12bot*a12bot / ( a12bot*a12bot + a12top*a12top ) ) ;
% 		sina12 = sqrt ( a12top*a12top / ( a12bot*a12bot + a12top*a12top ) ) ; */
% 
% 		e1 = el*(powi(costhk*cosa12,2) + powi(sinthk,2));
% 		e2 = e1*e1;
% 		e3 = e1*e2;
% 		c0 = c00 + c01*e1 + c02*e2 + c03*e3;
% 		c2 = c21*e1 + c22*e2 + c23*e3;
% 		c4 = c42*e2 + c43*e3;
% 		v1 = rad/sqrt( 1. - ec2*powi(sinthk,2) );
% 		v2 = rad/sqrt( 1. - ec2*powi(sinthi,2) );
% 		z1 = v1*(1. - ec2)*sinthk;
% 		z2 = v2*(1. - ec2)*sinthi;
% 		x2 = v2*costhi*cos( dl );
% 		y2 = v2*costhi*sin( dl );
% 		e1p1 = e1 + 1.;
% 		sqrte1p1 = sqrt( e1p1 );
% 		u1bot = sqrte1p1*cosa12;
% 		u1 = atan2( tanthk, u1bot );
% 		u2top = v1*sinthk + e1p1*(z2 - z1);
% 		u2bot = sqrte1p1*(x2*cosa12 - y2*sinthk*sina12);
% 		u2 = atan2( u2top, u2bot );
% 		b0 = v1*sqrt( 1. + el*powi(costhk*cosa12,2) )/e1p1;
% 		du = u2 - u1;
% 		pdist = b0*(c2*(sin( 2.*u2 ) - sin( 2.*u1 )) + c4*(sin( 4.*
% 		 u2 ) - sin( 4.*u1 )));
% 		distance = fabs( b0*c0*du + pdist );
% 	    } /* end if ( ldist ) */
% 
% 	out.distance = distance;
% 	out.azimuth = azi;
% 	out.degrees = xdeg;
% 
% 	return out;
% }
