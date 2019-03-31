function output = timecomb(sig, acc, minbpm, maxbpm, bandlimits, maxfreq)

%     BANDLIMITS is a vector of one row in
%     which each element represents the frequency bounds of a
%     band.

%     The final band is bounded by the last element of
%     BANDLIMITS and MAXFREQ. The beat resolution is defined in
%     ACC, and the range of beats to test is  defined by MINBPM and
%     MAXBPM.


  if nargin < 2, acc = 1; end
  if nargin < 3, minbpm = 50; end
  if nargin < 4, maxbpm = 120; end
  if nargin < 5, bandlimits = [0 3200 6400 12800 25600 51200]; end
  if nargin < 6, maxfreq = 51200; end


  n=length(sig);

  nbands=length(bandlimits);

  % Set the number of pulses in the comb filter

  npulses = 3;

  % Get signal in frequency domain

  for i = 1:nbands
    dft(:,i)=fft(sig(:,i));
  end

  % Initialize max energy to zero

  maxe = 0;

  for bpm = minbpm:acc:maxbpm

    % Initialize energy and filter to zero(s)

    e = 0;
    fil=zeros(n,1);

    % Calculate the difference between peaks in the filter for a
    % certain tempo

    nstep = floor(120/bpm*maxfreq);

    % Print the progress

    percent_done  = 100*(bpm-minbpm)/(maxbpm-minbpm)

    % Set every nstep samples of the filter to one

    for a = 0:npulses-1
      fil(a*nstep+1) = 1;
    end

    % Get the filter in the frequency domain

    dftfil = fft(fil);

    % Calculate the energy after convolution

    for i = 1:nbands
      x = (abs(dftfil.*dft(:,i))).^2;
      e = e + sum(x);
    end

    % If greater than all previous energies, set current bpm to the
    % bpm of the signal

    if e > maxe
      sbpm = bpm;
      maxe = e;
    end
  end

  output = sbpm;
