[sig,fs]=audioread('dsp60.wav');
filterbank(sig);
hwindow(ans);
diffrect(ans);
timecomb(ans);
ans
