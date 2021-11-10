%{
 ********************************************************************
 * [FILE NAME]: Communication_project.m
 *
 * [AUTHOR]: Toka Zakaria Mohamed Ramadan
 *
 * [DATE CREATED]: Dec 12, 2020
 *
 * [Description]:code to dsign AM modulator and a super-heterodyne receiver
 *******************************************************************
%}
%clear all varaibles in workspace
clear all;
%clear the command window
clc;
%some variables to be used as constants
k=1000;
%----------------------------------------------------------------
%                     Part: (i) The signals                     %
%----------------------------------------------------------------

% read the audio files to get the moduating signals (message signals)
[signal1,Fs1] = audioread('Short_SkyNewsArabia.wav');
[signal2,Fs2] = audioread('Short_BBCArabic2.wav');
[signal3,Fs3] = audioread('Short_FM9090.wav');
[signal4,Fs4] = audioread('Short_QuranPalestine.wav');

%{
add two channels for all messages
to implement a monophonic receiver
get the transpose of the signal to be able to
multiple by the carrier (cos(Wct))
%}
message1 = ( signal1(:,1)+ signal1(:,2) )';
message2 = ( signal2(:,1)+ signal2(:,2) )';
message3 = ( signal3(:,1)+ signal3(:,2) )';
message4 = ( signal4(:,1)+ signal4(:,2) )';

%get the length of the four messages
msg1_length = length(message1);
msg2_length = length(message2);
msg3_length = length(message3);
msg4_length = length(message4);

%mak an array of the lengthes of the messages
messages_lengthes = [msg1_length msg2_length msg3_length msg4_length];

%get the maximum length of the messages
maximum = msg1_length;
for i = 2:4
    if messages_lengthes(i) > maximum
        maximum = messages_lengthes(i);
    end
end
%pad the short signals with zeros
msg1 = [message1  zeros(1,maximum - msg1_length)];
msg2 = [message2  zeros(1,maximum - msg2_length)];
msg3 = [message3  zeros(1,maximum - msg3_length)];
msg4 = [message4  zeros(1,maximum - msg4_length)];

%calculation of BandWidth of each signal
msg1_BW = obw(msg1, Fs1);
msg2_BW = obw(msg2, Fs2);
msg3_BW = obw(msg3, Fs3);
msg4_BW = obw(msg4, Fs4);

%----------------------------------------------------------------
%              Fourier Transform for original signals           %
%----------------------------------------------------------------
Y1_old = fft(msg1,Fs1);
Y2_old = fft(msg2,Fs2);
Y3_old = fft(msg3,Fs3);
Y4_old = fft(msg4,Fs4);
%----------------------------------------------------------------
%            Messages Spectrum before interpolation             %
%----------------------------------------------------------------
% original Msg(1) spectrum
figure(1);
plot( ((-Fs1/2): (Fs1/2-1)) ,fftshift(abs(Y1_old)));
title('FD of (Short SkyNewsArabia) Message before interpolation');
ylabel('Amplitude of original message');
xlabel('Frequency');
%------------------------------------------------------------------
% original Msg(2) spectrum
figure(2);
plot( ((-Fs2/2): (Fs2/2-1)) ,fftshift(abs(Y2_old)));
title('FD of (Short BBCArabic2) Message before interpolation');
ylabel('Amplitude of original message');
xlabel('Frequency');
%------------------------------------------------------------------
% original Msg(3) spectrum
figure(3);
plot( ((-Fs3/2): (Fs3/2-1)) ,fftshift(abs(Y3_old)));
title('FD of (Short FM9090) Message before interpolation');
ylabel('Amplitude of original message');
xlabel('Frequency');
%------------------------------------------------------------------
% original Msg(4) spectrum
figure(4);
plot( ((-Fs4/2): (Fs4/2-1)) ,fftshift(abs(Y4_old)));
title('FD of (Short FM9090) Message before interpolation');
ylabel('Amplitude of original message');
xlabel('Frequency');
%------------------------------------------------------------------

%----------------------------------------------------------------
%                         Interpolations                        %
%---------------------------------------------------------------- 
%signals after interpolations
sig1= interp(msg1,20);
sig2= interp(msg2,20);
sig3= interp(msg3,20);
sig4= interp(msg4,20);

%get the new length of th signals
new_length = length(sig1);
%new sampled frequency
Fs= Fs1*20;
%get the index of the time sampling
index = 1 : new_length;
%time sampling
Ts= 1/Fs;

N= new_length;
h = (-N/2): (N/2-1);
x_axis=  h * (Fs/N);
%----------------------------------------------------------------
%                         Modulation                            %
%---------------------------------------------------------------- 

%modulated signals (with carriers)
mod1 = sig1 .* cos(2*pi*100*k*index*Ts);
mod2 = sig2 .* cos(2*pi*150*k*index*Ts);
mod3 = sig3 .* cos(2*pi*200*k*index*Ts);
mod4 = sig4 .* cos(2*pi*250*k*index*Ts);

%----------------------------------------------------------------
%              Fourier Transform for original signals           %
%----------------------------------------------------------------
Y1=fft(sig1,N);
Y2=fft(sig2,N);
Y3=fft(sig3,N);
Y4=fft(sig4,N);
%----------------------------------------------------------------
%              Fourier Transform for modulated signals          %
%----------------------------------------------------------------
m1=fft(mod1,N);
m2=fft(mod2,N);
m3=fft(mod3,N);
m4=fft(mod4,N);

%----------------------------------------------------------------
%  Messages Spectrum for "original and modulated" after interp  %
%----------------------------------------------------------------
figure(5);
subplot(1,2,1);
%original signal 1
plot(x_axis,fftshift(abs(Y1)));
title('FD of (Short SkyNewsArabia) Message after Interpolation');
ylabel('Amplitude of original signal');
xlabel('Frequency');

%modulated signal 1
subplot(1,2,2);
plot(x_axis,fftshift(abs(m1)));
title('FD of (Short SkyNewsArabia) Message after Interpolation');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');
%---------------------------------------------------------------------
figure(6);
subplot(1,2,1);
plot(x_axis,fftshift(abs(Y2)));
title('FD of (Short BBCArabic2) Message after Interpolation');
ylabel('Amplitude of original signal');
xlabel('Frequency');

subplot(1,2,2);
plot(x_axis,fftshift(abs(m2)));
title('FD of (Short BBCArabic2) Message after Interpolation');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');
%-------------------------------------------------------------------
figure(7);
subplot(1,2,1);
plot(x_axis,fftshift(abs(Y3)));
title('FD of (Short FM9090) Message after Interpolation');
ylabel('Amplitude of original signal');
xlabel('Frequency');

subplot(1,2,2);
plot(x_axis,fftshift(abs(m3)));
title('FD of (Short FM9090) Message after Interpolation');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');
%------------------------------------------------------------
figure(8);
subplot(1,2,1);
plot(x_axis,fftshift(abs(Y4)));
title('FD of (Short QuranPalestine) Message after Interpolation');
ylabel('Amplitude of original signal');
xlabel('Frequency');

subplot(1,2,2);
plot(x_axis,fftshift(abs(m4)));
title('FD of (Short QuranPalestine) Message after Interpolation');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');
%----------------------------------------------------------------
%----------------------------------------------------------------
%              Add signals to be ready to be sent               %
%----------------------------------------------------------------
All_Modsignals = mod1 +mod2 + mod3 +mod4 ;
m_all=fft(All_Modsignals,N);

%figure of all transmitting messages in FD
figure(9);
plot(x_axis,fftshift(abs(m_all)));
title('Frequency Domain of All Messages after Modulations');
ylabel('Amplitude of modulated signals');
xlabel('Frequency');


%------------------------------------------------------------
%----------------------------------------------------------------
%                       Detecting message (1)                   %
%----------------------------------------------------------------
%RF stage:
%first bandPassFilter to get the message
msg1_stp1 = ((100000)- msg1_BW-50);
msg1_pass1 = ((100000)- msg1_BW);
msg1_pass2 = ((100000)+ msg1_BW);
msg1_stp2 = ((100000)+ msg1_BW+50);

msg1_BandPassDesign = fdesign.bandpass(msg1_stp1,msg1_pass1,msg1_pass2,msg1_stp2,60,1,60,Fs);

msg1_BandPassFilter = design(msg1_BandPassDesign, 'ellip');

msg1_RF_BPF = filter( msg1_BandPassFilter, All_Modsignals);

FD_msg1_RF_BPF= fft(msg1_RF_BPF);

%to show detecting mssages after RF stage
figure(10);
%subplot(2,2,1);
plot(x_axis,fftshift(abs(FD_msg1_RF_BPF)));
title('FD of (Short SkyNewsArabia) Message in (RF stage)');
ylabel('Amplitude of modulated signal in RF stage');
xlabel('Frequency');

%mixer stage:
%transmit the signal to IF stage
msg1_shift_IF = msg1_RF_BPF .* cos(2*pi*125*k*index*Ts);

FD_msg1_shift_IF = fft(msg1_shift_IF);

figure(11);
%subplot(2,2,2);
plot(x_axis,fftshift(abs(FD_msg1_shift_IF)));
title('FD of(Short SkyNewsArabia) Message after (mixer stage) IF freq');
ylabel('Amplitude of modulated signal in IF frequency');
xlabel('Frequency');


%band pass filter to detect signal in IF frequency
msg1_IFstp1 = ((25*k)- msg1_BW-50);
msg1_IFpass1 = ((25*k)- msg1_BW);
msg1_IFpass2 = ((25*k)+ msg1_BW);
msg1_IFstp2 = ((25*k)+msg1_BW+50);

msg1_IFBandPassDesign = fdesign.bandpass(msg1_IFstp1 ,msg1_IFpass1,msg1_IFpass2 ,msg1_IFstp2,60,1,60,Fs);

msg1_IFBandPassFilter = design(msg1_IFBandPassDesign, 'ellip');

msg1_after_IFBPF = filter( msg1_IFBandPassFilter, msg1_shift_IF);

FD_msg1_after_IFBPF = fft(msg1_after_IFBPF);

figure(12);
%subplot(2,2,3);
plot(x_axis,fftshift(abs(FD_msg1_after_IFBPF)));
title('FD of(Short SkyNewsArabia) Message after BPF around IF');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');

%return the message to the baseband
msg1_toBaseBand = msg1_after_IFBPF  .* cos(2*pi*25*k*index*Ts);

FD_msg1_toBaseBand = fft(msg1_toBaseBand);

figure(13);
%subplot(2,2,4);
plot(x_axis,fftshift(abs(FD_msg1_toBaseBand)));
title('FD of(Short SkyNewsArabia) Message after BaseBand');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');

%lowpassfilter design to detect the final original signal
msg1_LowPassDesign = fdesign.lowpass((msg1_BW/Fs),((msg1_BW+50)/Fs),1,60);

msg1_LowPassFilter = design(msg1_LowPassDesign, 'ellip');

msg1_recovery = filter(msg1_LowPassFilter, msg1_toBaseBand);

FD_msg1_recovery = fft(msg1_recovery);

figure(14);
%subplot(1,2,1);
plot(x_axis,fftshift(abs(FD_msg1_recovery)));
title('FD of final (Short SkyNewsArabia) Message');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');

%downsampling the signal to get the original signal
msg1_original_recovry = downsample(msg1_recovery, 20);
FD_msg1_final = fft(msg1_original_recovry);

msg1_y = fftshift(abs(FD_msg1_final));
length_of_msg1_y = length( (msg1_y)' );

figure(15);
%subplot(1,2,2);
plot( ((-length_of_msg1_y/2): (length_of_msg1_y/2-1)) ,msg1_y);
title('FD of original final (Short SkyNewsArabia) Message');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');
%----------------------------------------------------------------
%                       Detecting message (2)                   %
%----------------------------------------------------------------
%RF stage:
%first bandPassFilter to get the message
msg2_stp1 = ((150000)- msg2_BW-50);
msg2_pass1 = ((150000)- msg2_BW);
msg2_pass2 = ((150000)+ msg2_BW);
msg2_stp2 = ((150000)+ msg2_BW+50);

msg2_BandPassDesign = fdesign.bandpass(msg2_stp1,msg2_pass1,msg2_pass2,msg2_stp2,60,1,60,Fs);

msg2_BandPassFilter = design(msg2_BandPassDesign, 'ellip');

msg2_RF_BPF = filter( msg2_BandPassFilter, All_Modsignals);

FD_msg2_RF_BPF= fft(msg2_RF_BPF);

%to show detecting mssages after RF stage
figure(16);
%subplot(2,2,1);
plot(x_axis,fftshift(abs(FD_msg2_RF_BPF)));
title('FD of (Short BBCArabic2) Message in (RF stage)');
ylabel('Amplitude of modulated signal in RF stage');
xlabel('Frequency');

%mixer stage:
%transmit the signal to IF stage
msg2_shift_IF = msg2_RF_BPF .* cos(2*pi*175*k*index*Ts);

FD_msg2_shift_IF = fft(msg2_shift_IF);

figure(17);
%subplot(2,2,2);
plot(x_axis,fftshift(abs(FD_msg2_shift_IF)));
title('FD of(Short BBCArabic2) Message after (mixer stage) IF freq');
ylabel('Amplitude of modulated signal in IF frequency');
xlabel('Frequency');


%band pass filter to detect signal in IF frequency
msg2_IFstp1 = ((25*k)- msg2_BW-50);
msg2_IFpass1 = ((25*k)- msg2_BW);
msg2_IFpass2 = ((25*k)+ msg2_BW);
msg2_IFstp2 = ((25*k)+msg2_BW+50);

msg2_IFBandPassDesign = fdesign.bandpass(msg2_IFstp1 ,msg2_IFpass1,msg2_IFpass2 ,msg2_IFstp2,60,1,60,Fs);

msg2_IFBandPassFilter = design(msg2_IFBandPassDesign, 'ellip');

msg2_after_IFBPF = filter( msg2_IFBandPassFilter, msg2_shift_IF);

FD_msg2_after_IFBPF = fft(msg2_after_IFBPF);

figure(18);
%subplot(2,2,3);
plot(x_axis,fftshift(abs(FD_msg2_after_IFBPF)));
title('FD of(Short BBCArabic2) Message after BPF around IF');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');

%return the message to the baseband
msg2_toBaseBand = msg2_after_IFBPF  .* cos(2*pi*25*k*index*Ts);

FD_msg2_toBaseBand = fft(msg2_toBaseBand);

figure(19);
%subplot(2,2,4);
plot(x_axis,fftshift(abs(FD_msg2_toBaseBand)));
title('FD of(Short BBCArabic2) Message after BaseBand');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');

%lowpassfilter design to detect the final original signal
msg2_LowPassDesign = fdesign.lowpass((msg2_BW/Fs),((msg2_BW+50)/Fs),1,60);

msg2_LowPassFilter = design(msg2_LowPassDesign, 'ellip');

msg2_recovery = filter(msg2_LowPassFilter, msg2_toBaseBand);

FD_msg2_recovery = fft(msg2_recovery);

figure(20);
%subplot(1,2,1);
plot(x_axis,fftshift(abs(FD_msg2_recovery)));
title('FD of final (Short BBCArabic2) Message');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');

%downsampling the signal to get the original signal
msg2_original_recovry = downsample(msg2_recovery, 20);
FD_msg2_final = fft(msg2_original_recovry);

msg2_y = fftshift(abs(FD_msg2_final));
length_of_msg2_y = length( (msg2_y)' );

figure(21);
%subplot(1,2,2);
plot( ((-length_of_msg2_y/2): (length_of_msg2_y/2-1)) ,msg2_y);
title('FD of original final (Short BBCArabic2) Message');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');


%----------------------------------------------------------------
%                       Detecting message (3)                   %
%----------------------------------------------------------------
%RF stage:
%first bandPassFilter to get the message
msg3_stp1 = ((200000)- msg3_BW-50);
msg3_pass1 = ((200000)- msg3_BW);
msg3_pass2 = ((200000)+ msg3_BW);
msg3_stp2 = ((200000)+ msg3_BW+50);

msg3_BandPassDesign = fdesign.bandpass(msg3_stp1,msg3_pass1,msg3_pass2,msg3_stp2,60,1,60,Fs);

msg3_BandPassFilter = design(msg3_BandPassDesign, 'ellip');

msg3_RF_BPF = filter( msg3_BandPassFilter, All_Modsignals);

FD_msg3_RF_BPF= fft(msg3_RF_BPF);

%to show detecting mssages after RF stage
figure(22);
%subplot(2,2,1);
plot(x_axis,fftshift(abs(FD_msg3_RF_BPF)));
title('FD of (Short FM9090) Message in (RF stage)');
ylabel('Amplitude of modulated signal in RF stage');
xlabel('Frequency');

%mixer stage:
%transmit the signal to IF stage
msg3_shift_IF = msg3_RF_BPF .* cos(2*pi*225*k*index*Ts);

FD_msg3_shift_IF = fft(msg3_shift_IF);

figure(23);
%subplot(2,2,2);
plot(x_axis,fftshift(abs(FD_msg3_shift_IF)));
title('FD of(Short FM9090) Message after (mixer stage) IF freq');
ylabel('Amplitude of modulated signal in IF frequency');
xlabel('Frequency');


%band pass filter to detect signal in IF frequency
msg3_IFstp1 = ((25*k)- msg3_BW-50);
msg3_IFpass1 = ((25*k)- msg3_BW);
msg3_IFpass2 = ((25*k)+ msg3_BW);
msg3_IFstp2 = ((25*k)+msg3_BW+50);

msg3_IFBandPassDesign = fdesign.bandpass(msg3_IFstp1 ,msg3_IFpass1,msg3_IFpass2 ,msg3_IFstp2,60,1,60,Fs);

msg3_IFBandPassFilter = design(msg3_IFBandPassDesign, 'ellip');

msg3_after_IFBPF = filter( msg3_IFBandPassFilter, msg3_shift_IF);

FD_msg3_after_IFBPF = fft(msg3_after_IFBPF);

figure(24);
%subplot(2,2,3);
plot(x_axis,fftshift(abs(FD_msg3_after_IFBPF)));
title('FD of(Short FM9090) Message after BPF around IF');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');

%return the message to the baseband
msg3_toBaseBand = msg3_after_IFBPF  .* cos(2*pi*25*k*index*Ts);

FD_msg3_toBaseBand = fft(msg3_toBaseBand);

figure(25);
%subplot(2,2,4);
plot(x_axis,fftshift(abs(FD_msg3_toBaseBand)));
title('FD of(Short FM9090) Message after BaseBand');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');

%lowpassfilter design to detect the final original signal
msg3_LowPassDesign = fdesign.lowpass((msg3_BW/Fs),((msg3_BW+50)/Fs),1,60);

msg3_LowPassFilter = design(msg3_LowPassDesign, 'ellip');

msg3_recovery = filter(msg3_LowPassFilter, msg3_toBaseBand);

FD_msg3_recovery = fft(msg3_recovery);

figure(26);
%subplot(1,2,1);
plot(x_axis,fftshift(abs(FD_msg3_recovery)));
title('FD of final (Short FM9090) Message');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');

%downsampling the signal to get the original signal
msg3_original_recovry = downsample(msg3_recovery, 20);
FD_msg3_final = fft(msg3_original_recovry);

msg3_y = fftshift(abs(FD_msg3_final));
length_of_msg3_y = length( (msg3_y)' );

figure(27);
%subplot(1,2,2);
plot( ((-length_of_msg3_y/2): (length_of_msg3_y/2-1)) ,msg3_y);
title('FD of original final (Short FM9090) Message');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');
%----------------------------------------------------------------
%                       Detecting message (4)                   %
%----------------------------------------------------------------
%RF stage:
%first bandPassFilter to get the message
msg4_stp1 = ((250000)- msg4_BW-50);
msg4_pass1 = ((250000)- msg4_BW);
msg4_pass2 = ((250000)+ msg4_BW);
msg4_stp2 = ((250000)+ msg4_BW+50);

msg4_BandPassDesign = fdesign.bandpass(msg4_stp1,msg4_pass1,msg4_pass2,msg4_stp2,60,1,60,Fs);

msg4_BandPassFilter = design(msg4_BandPassDesign, 'ellip');

msg4_RF_BPF = filter( msg4_BandPassFilter, All_Modsignals);

FD_msg4_RF_BPF= fft(msg4_RF_BPF);

%to show detecting mssages after RF stage
figure(28);
%subplot(2,2,1);
plot(x_axis,fftshift(abs(FD_msg4_RF_BPF)));
title('FD of (Short QuranPalestine) Message in (RF stage)');
ylabel('Amplitude of modulated signal in RF stage');
xlabel('Frequency');

%mixer stage:
%transmit the signal to IF stage
msg4_shift_IF = msg4_RF_BPF .* cos(2*pi*275*k*index*Ts);

FD_msg4_shift_IF = fft(msg4_shift_IF);

figure(29);
%subplot(2,2,2);
plot(x_axis,fftshift(abs(FD_msg4_shift_IF)));
title('FD of(Short QuranPalestine) Message after (mixer stage) IF freq');
ylabel('Amplitude of modulated signal in IF frequency');
xlabel('Frequency');


%band pass filter to detect signal in IF frequency
msg4_IFstp1 = ((25*k)- msg4_BW-50);
msg4_IFpass1 = ((25*k)- msg4_BW);
msg4_IFpass2 = ((25*k)+ msg4_BW);
msg4_IFstp2 = ((25*k)+msg4_BW+50);

msg4_IFBandPassDesign = fdesign.bandpass(msg4_IFstp1 ,msg4_IFpass1,msg4_IFpass2 ,msg4_IFstp2,60,1,60,Fs);

msg4_IFBandPassFilter = design(msg4_IFBandPassDesign, 'ellip');

msg4_after_IFBPF = filter( msg4_IFBandPassFilter, msg4_shift_IF);

FD_msg4_after_IFBPF = fft(msg4_after_IFBPF);

figure(30);
%subplot(2,2,3);
plot(x_axis,fftshift(abs(FD_msg4_after_IFBPF)));
title('FD of(Short QuranPalestine) Message after BPF around IF');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');

%return the message to the baseband
msg4_toBaseBand = msg4_after_IFBPF  .* cos(2*pi*25*k*index*Ts);

FD_msg4_toBaseBand = fft(msg4_toBaseBand);

figure(31);
%subplot(2,2,4);
plot(x_axis,fftshift(abs(FD_msg4_toBaseBand)));
title('FD of(Short QuranPalestine) Message after BaseBand');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');

%lowpassfilter design to detect the final original signal
msg4_LowPassDesign = fdesign.lowpass((msg4_BW/Fs),((msg4_BW+50)/Fs),1,60);

msg4_LowPassFilter = design(msg4_LowPassDesign, 'ellip');

msg4_recovery = filter(msg4_LowPassFilter, msg4_toBaseBand);

FD_msg4_recovery = fft(msg4_recovery);

figure(32);
%subplot(1,2,1);
plot(x_axis,fftshift(abs(FD_msg4_recovery)));
title('FD of final (Short QuranPalestine) Message');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');

%downsampling the signal to get the original signal
msg4_original_recovry = downsample(msg4_recovery, 20);
FD_msg4_final = fft(msg4_original_recovry);

msg4_y = fftshift(abs(FD_msg4_final));
length_of_msg4_y = length( (msg4_y)' );

figure(33);
%subplot(1,2,2);
plot( ((-length_of_msg4_y/2): (length_of_msg4_y/2-1)) ,msg4_y);
title('FD of original final (Short QuranPalestine) Message');
ylabel('Amplitude of modulated signal');
xlabel('Frequency');
%------------------------------------------------------------------
%----------------------------------------------------------------
%                         Check the audios                      %
%----------------------------------------------------------------
%hear the sound of the first message
 sound(msg1_original_recovry, Fs1);
 pause (16);
 sound(msg2_original_recovry, Fs2);
 pause (16);
 sound(msg3_original_recovry, Fs3);
 pause (16);
 sound(msg4_original_recovry, Fs4);


