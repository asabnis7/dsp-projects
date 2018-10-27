// Arjun Sabnis
// Spectrum analyzer main
// 10-27-2018

#include "spectra.h"

int main()
{
    double midiBase = 25.0;
    int noteLength = 12; 
    int sigSize = 10000;
    double * signal = new double[sigSize];
    double fsamp = 8192.0;
    int bins = 12;
    
    Octave oct1(midiBase,noteLength);
   
    for (int i = 0; i < sigSize; i++) 
        signal[i] = sin(2*pi*140*(0.01*i))+sin(2*pi*220*(0.02*i));
   
    qTransform spectrum(fsamp,oct1.getFreq(0),oct1.getFreq(noteLength-1),bins);
    Complex * cq = new Complex[spectrum.getK()];
    int kSize;
    int N = spectrum.getN();
    
    for (int g = 0; g < sigSize-N; g += N)
    {
        N = spectrum.getN();
        signal += g;
        spectrum.QFT(signal);
        cq = spectrum.getValues();
        kSize = spectrum.getK();
        spectrum.graphSpectrum();
    }
}
