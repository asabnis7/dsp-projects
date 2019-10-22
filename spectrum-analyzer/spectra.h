// Arjun Sabnis
// Constant Q-transform Spectrum Analyzer
// 10/27/2018

#ifndef SPECTRA_H
#define SPECTRA_H

#include <iostream>
#include <iomanip>
#include <fstream>
#include <cstdlib>
#include <cmath>
#include <string>

#define pi 3.1415926


// Octave struct to create and store note frequencies
struct Octave
{
    private:
        double baseNote;
        int numNotes;
        double * noteFreqs;

    public:
        Octave() = default;                 // default constructor
        Octave(double base, int length);    // init n-note sequence
        ~Octave();                          // destructor
        
        double getFreq(int index);          // return given freq
        void print();                       // debugging
};


// Complex struct to handle floating-pt complex calculations
struct Complex 
{
    private:
        double real;
        double imag;
        double angle;
        double mag;

    public:
        Complex();                          // default 
        Complex(double i);                  // init with one #
        Complex(double re, double im);      // init with two #
        
        void eulerCalc();                   // compute Euler's form
        void cartCalc();                    // compute Cartesian equiv
        void setEuler(double m, double a);  // set complex num
        void setCart(double r, double i);   // set complex num
        
        // getters
        double getReal() const;
        double getImag() const;
        double getMag() const;
        double getAngle() const;

        // operators
        Complex & operator*(const double rhs);
        Complex & operator+(const Complex& rhs);
        Complex & operator/(const double rhs);
        friend Complex & operator*(const double lhs, Complex& rhs);

        void print();
};


// Hamming window function
void hamming(int length, double * window);


// Structure for Constant-Q transform
struct qTransform
{
    private:
        double fs;          // sampling rate
        double fo;          // min sequence freq
        double fmax;        // max sequence freq
        double Q;           // constant Q
        double K;           // FFT k-component
        int N;              // k-dep transform length
        double maxMag;      // normalization constant
        int bins;           // transform bins
        Complex * cq;       // Q-transform values
    
    public:
        qTransform(double samp, double fund, double max, int bins);
        ~qTransform();
        
        // getters
        Complex * getValues();              // return calculated QFT values
        int getK() const;                   // get # of frequency bins
        int getN() const;                   // get K-dep window length

        // qft spectrum functions
        void QFT(double * signal);          // calculate QFT
        void cqNormalize();                 // normalize by largest val
        void clear();                       // reset spectrum
        
        // debugging/display
        void printMag();
        void graphSpectrum();               // visual display
};

#endif
