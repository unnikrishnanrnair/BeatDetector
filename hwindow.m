function output = hwindow(sig, winlength, bandlimits, maxfreq)

%     HWINDOW rectifies a signal, then convolves it with a half Hanning
%     window.

%     BANDLIMITS is a vector of one row in which
%     each element represents the frequency bounds of a band. The
%     final band is bounded by the last element of BANDLIMITS and
%     MAXFREQ. WINLENGTH contains the length of the Hanning window,
%     in time.

  if nargin < 2, winlength = .4; end
  if nargin < 3, bandlimits = [0 3200 6400 12800 25600 51200]; end
  if nargin < 4, maxfreq = 51200; end

  n = length(sig);
  nbands = length(bandlimits);

  hannlen = winlength*2*maxfreq;

  hann = [zeros(n,1)];

  % Create half-Hanning window.

  for a = 1:hannlen
    hann(a) = (cos(a*pi/hannlen/2)).^2;
  end

  % Take IFFT to transfrom to time domain.

  for i = 1:nbands
    wave(:,i) = real(ifft(sig(:,i)));
  end

  % Full-wave rectification in the time domain.
  % And back to frequency with FFT.

  for i = 1:nbands
    for j = 1:n
      if wave(j,i) < 0
	wave(j,i) = -wave(j,i);
      end
    end
    freq(:,i) = fft(wave(:,i));
  end

  % Convolving with half-Hanning same as multiplying in
  % frequency. Multiply half-Hanning FFT by signal FFT. Inverse
  % transform to get output in the time domain.

  for i = 1:nbands
    filtered(:,i) = freq(:,i).*fft(hann);
    output(:,i) = real(ifft(filtered(:,i)));
  end
