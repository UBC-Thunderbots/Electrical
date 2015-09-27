% Load the data from data.txt
% load('filename, 'v1', 'v2', ...);


% FFT part, uncomment this once data is loaded.
% (if you really know your stuff, you can try this yourself).

%fft_sig = fft(y, n);
%fft_mag = abs(fft_sig);
%fft_mag = fftshift(fft_mag);
%subplot(2, 1, 2);
%plot(x, fft_mag);

% Load the filter, and apply it to the the signal.
% Make sure to use fftshift(signal)!!!


% Take the Inverse Fourier Transform of the original
% signal, not the magnitude spectrum. If you get an output
% shaped like a 'U', you forgot the phase component!
% Make sure to take the absolute value of the Inverse Fourier
% Transform.


% Apply a first order fit to the data.


