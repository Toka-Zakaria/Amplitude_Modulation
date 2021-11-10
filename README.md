# Amplitude_Modulation
# "Super-heterodyne Receiver"

- The purpose of this project is to simulate the basic components of an analog communication system using
MATLAB programming. Specifically, an AM modulator and a corresponding super-heterodyne receiver
will be simulated using radio-station generated signals. The audio signals are uploaded on the repo, too

- The figure shows a typical AM transceiver. The input message is modulated and wirelessly transmitted. The
receiver detects the message using multiple stages of mixing and filtering 

![Capture](https://user-images.githubusercontent.com/75904835/141148528-1473740d-e37d-46e5-bebe-1ad1fe5a15b0.PNG)

- There are audio signals that represent the input message for the above system. The task is to design
the block diagram in the figure using MATLAB. The details are given as follows:

1. **The signals:** stereo (2-channel) signals are provided in the baseband. The signals are stored in
files with extension ‘wav’. we will read these files in MATLAB firstly,
For later processing, it is needed to obtain the sampling frequency (which was used to
digitize the recorded waves). The MATLAB function can return the sampling frequency. 
Each modulating signal (the messages) has two channels representing a stereo signal. It is wanted to
implement a monophonic receiver so there is no need for two separate channels. We are able to form single
channel stream by simply adding the two channels. 
**Important note:** that the given signals are not of equal
length, so we are going to force the short signals with zeros so they have all equal length.
_______________________________________________________________________________________________________________________

2. **The AM modulator:** the modulation type is DSB-SC for all the signals. The first signal is modulated
with 100 KHz carrier. Each following signal is modulated with a carrier of frequency
𝜔𝑛 = 100 + 𝑛Δ𝐹, where 𝚫𝑭 = 𝟓𝟎 KHz and the index 𝑛 is the signal index (𝑛 = 0 for the first signal
that is modulated at 100 KHz). The modulated signals are used to construct an FDM signal (FDM:
frequency division multiplexing). We can start writing your program using two modulating messages.
**Note:** that the values of the carrier frequencies are smaller than the actual AM/FM transmission values
that are in the order of megahertz. The small values of the carrier frequencies used in this project were
chosen to reduce the simulation complexity. 
Another important simulation parameter is the sampling frequency 𝐹𝑠 as mentioned before. 
It is must to increase the sampling frequency 𝐹𝑆 to avoid the violation of Nyquist criteria.
,say by 10 times. This is effectively done by increasing the number of samples of the modulating signals. That is, if the modulating signals are of
size 𝑁which is obtained using a sampling frequency 𝐹𝑠 ,then increasing the number of samples to 10𝑁
_________________________________________________________________________________________________________________________

3. **The wireless channel:** in real life the modulated FDM signal is transmitted over the air from the base
station. Simulating this wireless channel is out of the scope of this project.
_________________________________________________________________________________________________________________________

4. **The RF stage:**  this is the stage that performs interference-image rejection.
For simplicity, this stage will be implemented as a band-pass Filter (BPF) only, centered at the carrier
frequency 𝜔𝑛 (that is tunable at the desired station). 

__________________________________________________________________________________________________________________________

5. **The Oscillator:** this is the generator for a carrier frequency 𝜔𝑐 + 𝜔𝐼𝐹, where 𝜔𝑐 = 𝜔𝑛 + 𝑛Δ𝐹. The IF
frequency 𝝎𝑰𝑭 = 𝟐𝟓 KHz. The mixer is a simple multiplier in this simulation.
vi. The IF stage: similar to the RF stage, this stage is simply modeled as a band-pass filter only, centered
at the center frequency 𝜔𝐼𝐹.

___________________________________________________________________________________________________________________________

6. **The Baseband detection:** this is the final stage where the signal is obtained in the baseband. This stage
thus involves mixing with a carrier of suitable frequency (it is easy to guess its value) and filtering the
signal using a low-pass filter (LPF). The design of LPF can be done similarly to the BPF. 

