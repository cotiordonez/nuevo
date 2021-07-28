% clf
% close all
% clear
% clc
addpath(genpath(pwd))
cd(fileparts(which(mfilename)))
% 
%%
% Ask for folder containing Airgun files
% airgun_path = uigetdir(pwd,'Select Location of Airgun WAV files');
airgun_path = '../../SoundTraps/recortados/Disparos-1s';
addpath(genpath(airgun_path));
airgun_files = getAllFiles(airgun_path);

% Ask for folder containing Noise files
% noise_path = uigetdir(pwd,'Select Location of Noise WAV files');
noise_path = '../../SoundTraps/recortados/Ruido';
addpath(genpath(noise_path));
noise_files = getAllFiles(noise_path);

% Ask for output folder 
% outpath = uigetdir(pwd,'Select Location of analysis output');

ai = audioinfo(airgun_files{1}); 
Fs = ai.SampleRate; % Sample Rate
nbits = ai.BitsPerSample; % Bit rate

% Filtro pasa banda
% fc1 = 90000/(Fs/2); % Frecuencia de corte inferior en Hz % 50 k para incluir BBPs
% fc2 = 160000/(Fs/2); % Frecuencia de corte superior en Hz
% [N,Wn] = buttord(fc1,fc2,0.1,60);
% [b,a] = butter(N,[fc1 fc2]);  

load('HpFilter');
%% Create filter banks
% Create octave bands filter bank
[Nfc1, Hd1] = design_filter(1, 6, 1000, Fs);

% Create third-octave bands filter bank
[Nfc3, Hd3] = design_filter(3, 8, 1000, Fs);
%% Calculate parameters
[depth, SEL_Airgun, zeroPeak_Airgun, SL_Airgun] = calculate_params(airgun_files, Hd, Hd1, Nfc1, Hd3, Nfc3, 'airguns');
[depth, SEL_Noise, zeroPeak_Noise, ~] = calculate_params(noise_files, Hd, 'noise');