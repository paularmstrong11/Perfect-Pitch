% This Matlab script implements a perfect pitch algorithm.

% Initialize Variables
fs = 44100; % Sample rate (Hz)
nfft = 8192; % Number of fft points

% Read audio file
[wave, Fs] = audioread('audiofile.wav');

% Compute pitch
pitch = zerocross(wave, fs, nfft);

% Calculate the frequencies of the notes
frequencies = pitch2freq(pitch);

% Find the closest notes using pitch shifting algorithms
closestNotes = pitchShift(frequencies, fs, nfft);

% Convert notes to string format
noteStrings = fs2str(closestNotes);

% Display notes
disp(noteStrings);

%%%%%%% FUNCTION DEFINITIONS %%%%%%%

% zerocross function
function pitch = zerocross(wave,fs,nfft)
    % Compute zero crossings
    zc = find(diff(wave));
    % Compute time between crossings
    zcDiff = diff(zc);
    % Calculate pitch
    pitch = fs / mean(zcDiff);
    % Calculate Fast Fourier Transform
    Y = fft(wave,nfft);
    % Compute pitch from FFT
    [~,idx] = max(abs(Y));
    pitchFFT = fs*(idx-1)/nfft;
    % Average pitch from zero crossings and FFT
    pitch = 0.5*(pitch + pitchFFT);
end

% pitch2freq function
function frequencies = pitch2freq(pitch)
    % Convert pitch (in Hz) to frequencies
    frequencies = 2.^((pitch-9)/12).*440;
end

% pitchShift function
function closestNotes = pitchShift(frequencies, fs, nfft)
    % Initialize variables
    noteStrings = {'A','A#','B','C','C#','D','D#','E','F','F#','G','G#'};
    % Create note frequencies
    A4 = 440;
    notes = A4*2.^((0:1/12:11)-9/12);
    % Calculate pitch shift
    [~,idx] = min(abs(frequencies-notes));
    closestNotes = notes(idx);
    % Adjust pitch
    frequencies = frequencies./closestNotes;
    % Create filter
    freqRange = 1:1000;
    multiplier = (freqRange.^2)./((freqRange.^2)+(frequencies.^2));
    filter = repmat(multiplier,1,nfft/1000);
    % Filter the audio
    wave = ifft(filter.*fft(wave,nfft)');
end

% fs2str function
function noteStrings = fs2str(closestNotes)
    % Initialize variables
    noteStrings = {'A','A#','B','C','C#','D','D#','E','F','F#','G','G#'};
    % Convert frequencies to strings
    noteStrings = noteStrings(round(12*(log2(closestNotes/440)+9/12))+1);
end