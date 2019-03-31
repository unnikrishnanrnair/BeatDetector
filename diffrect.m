function output=diffrect(sig,nbands)

%     DIFFRECT differentiates a signal, then half-wave rectifies the
%     result.

%     The number of frequency bands is passed in
%     through NBANDS.


if nargin <2, nbands=6; end

n = length(sig);

output=zeros(n,nbands);

for i = 1:nbands
   for j = 5:n

     % Find the difference from one smaple to the next

     d = sig(j,i) - sig(j-1,i);
     if d > 0

       % Retain only if difference is positive (Half-Wave rectify)

       output(j,i)=d;
     end
   end
end
