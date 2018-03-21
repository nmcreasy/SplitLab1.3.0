function temp = powi(b, x)
% Helper routine for distaz
if (b == 0) 
    temp = 0;
    return
end
if (x == 0)
    temp = 1;
    return
end

if (x > 0) 
    temp = b;
    for i=x-1:-1:1
        temp = temp * b;
    end
    return
end

if (x < 0)
    temp = 1.0 / b;
    for i=x+1:1:-1
        temp = temp / b;
    end
    return
end
temp = b;
return
end



% double powi(double b, long x) {
%         double temp=0.0;
%         long i;
% 
%         if ( b == 0.0 ) {
%                 return( (double) 0.0 );
%         }
%         if ( x == 0L ) {
%                 return( (double) 1.0 );
%         }
% 
%     if ( x > 0L ) {
%                 temp = b;
%         for ( i = x-1; i > 0L; i-- ) {
%                 temp *= b;
%         }
%         return temp;
%         }
% 
%     if ( x < 0L ) {
%         temp = 1.0 / b;
%         for ( i = x+1; i < 0L; i++ ) {
%                 temp *= (1.0/b);
%         }
%         return temp;
%         }
%         return temp;
% }
% ///END
